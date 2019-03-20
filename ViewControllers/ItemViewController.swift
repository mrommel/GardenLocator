//
//  ItemViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class ItemViewController: UIViewController {
    
    // Views
    var mapView: GMSMapView?
    @IBOutlet weak var tableView: UITableView!
    var backButton: UIBarButtonItem?
    
    // Misc
    var editMode: Bool = false
    var camera: GMSCameraPosition?
    var itemMarker: GMSMarker?
    let locationManager = CLLocationManager()
    let initialLatitude = 52.520736
    let initialLongitude = 13.409423

    var presenter: ItemPresenterInputProtocol?
    var interactor: ItemInteractorInputProtocol?
    var viewModel: ItemViewModel?
    
    // tmp values
    var patchNameTmp: String = ""
    var longitudeTmp: Double = 0.0
    var latitudeTmp: Double = 0.0
    
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reusePatchSelectionIdentifier: String = "reusePatchSelectionIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
    let latitudeIndexPath = IndexPath(row: 1, section: 0)
    let longitudeIndexPath = IndexPath(row: 2, section: 0)
    let patchIndexPath = IndexPath(row: 3, section: 0)
    let deleteButtonIndexPath = IndexPath(row: 0, section: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.viewModel?.name
        
        if self.viewModel == nil {
            self.editMode = true
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(TextInputTableViewCell.self , forCellReuseIdentifier: reuseNameTextfieldIdentifier)
        
        if let model = self.viewModel {
            self.camera = GMSCameraPosition.camera(withLatitude: model.latitude, longitude: model.longitude, zoom: 20)
            self.latitudeTmp = model.latitude
            self.longitudeTmp = model.longitude
            self.patchNameTmp = model.patchName
        } else {
            self.camera = GMSCameraPosition.camera(withLatitude: self.initialLatitude, longitude: self.initialLongitude, zoom: 20)
        }
        
        // init map in table header
        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280), camera: self.camera!)
        self.mapView?.settings.myLocationButton = true
        self.mapView?.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        // add marker
        if let model = self.viewModel {
            let coordinate = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
            self.itemMarker = GMSMarker(position: coordinate)
            self.itemMarker?.title = model.name
            self.itemMarker?.map = self.mapView
        }
        
        // store back button
        self.backButton = self.navigationItem.backBarButtonItem
        
        self.setup()
    }
    
    func setup() {
        
        if self.editMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditMode))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
            
            // unlock movement of camera
            self.mapView?.settings.setAllGesturesEnabled(true)
            self.mapView?.isMyLocationEnabled = true
            self.mapView?.settings.myLocationButton = true
        } else {
            self.navigationItem.leftBarButtonItem = self.backButton
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEditMode))
        
            // lock / reset movement of camera
            if let model = self.viewModel {
                self.camera = GMSCameraPosition.camera(withLatitude: model.latitude, longitude: model.longitude, zoom: 20)
            } else {
                self.camera = GMSCameraPosition.camera(withLatitude: self.initialLatitude, longitude: self.initialLongitude, zoom: 20)
            }
            self.mapView?.settings.setAllGesturesEnabled(false)
            self.mapView?.isMyLocationEnabled = false
            self.mapView?.settings.myLocationButton = false
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func enableEditMode(sender: UIView?) {
        
        self.editMode = true
        self.setup()
    }
    
    @IBAction func cancelEditMode(sender: UIView?) {
        
        self.editMode = false
        self.setup()
    }
    
    @IBAction func saveItem(sender: UIView?) {
        
        guard let nameCell = self.tableView.cellForRow(at: self.nameIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        var isNewPatch: Bool = false
        let name = nameCell.textFieldValue()
        let latitude = Double(self.latitudeTmp)
        let longitude = Double(self.longitudeTmp)
        let patchName = self.patchNameTmp
        
        if self.viewModel == nil {
            // create new patch
            self.viewModel = ItemViewModel(latitude: latitude,
                                           longitude: longitude,
                                           name: name,
                                           patchName: patchName)
            isNewPatch = true
        } else {
            // update current patch
            self.viewModel?.latitude = latitude
            self.viewModel?.longitude = longitude
            self.viewModel?.name = name
            self.viewModel?.patchName = patchName
            isNewPatch = false
        }
        
        // is valid?
        if !(self.viewModel?.isValid() ?? false) {
            
            self.showError(title: "Invalid", message: "Name must not be empty")
            return
        }
        
        // save patch or create new item
        if isNewPatch {
            self.interactor?.create(item: self.viewModel)
        } else {
            self.interactor?.save(item: self.viewModel)
        }
    }
}

extension ItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 280.0
        } else {
            return 20.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return self.mapView
        } else {
            return nil
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.editMode && self.viewModel != nil {
            return 2
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.editMode && self.viewModel != nil {
            if section == 0 {
                return 4
            } else {
                return 1
            }
        } else {
            return 4
        }
    }
    
    func getNameCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNameLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNameLabelIdentifier)
    }
    
    func getPatchCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reusePatchSelectionIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reusePatchSelectionIdentifier)
    }
    
    func getButtonCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseButtonIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: self.reuseButtonIdentifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath == self.nameIndexPath {
            
            if self.editMode {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: "Name", textFieldValue: self.viewModel?.name ?? "", placeHolder: "Enter some text!")
                cell.textField.tag = 0
                cell.textField.delegate = self
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = self.viewModel?.name ?? ""
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                
                return cell
            }
        }
        
        if indexPath == self.latitudeIndexPath {
            
            if self.editMode {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: "Latitude", textFieldValue: "\(self.viewModel?.latitude ?? self.latitudeTmp)", placeHolder: "Enter some latitude")
                cell.textField.tag = 1
                cell.textField.delegate = self
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = "Latitude"
                cell.detailTextLabel?.text = "\(self.viewModel?.latitude ?? self.latitudeTmp)"
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                
                return cell
            }
        }
        
        if indexPath == self.longitudeIndexPath {
            
            if self.editMode {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: "Longitude", textFieldValue: "\(self.viewModel?.longitude ?? self.longitudeTmp)", placeHolder: "Enter some longitude")
                cell.textField.tag = 2
                cell.textField.delegate = self
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = "Longitude"
                cell.detailTextLabel?.text = "\(self.viewModel?.longitude ?? self.longitudeTmp)"
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                
                return cell
            }
        }
        
        if indexPath == self.patchIndexPath {
            
            if self.editMode {
                let cell = self.getPatchCell()
                
                cell.textLabel?.text = "Patch"
                if let viewModel = self.viewModel {
                    cell.detailTextLabel?.text = viewModel.patchName
                } else {
                    cell.detailTextLabel?.text = self.patchNameTmp
                }
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                cell.accessoryType = .none
                
                return cell
            } else {
                let cell = self.getPatchCell()
                
                cell.textLabel?.text = "Patch"
                cell.detailTextLabel?.text = self.viewModel?.patchName
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
        }
        
        if indexPath == self.deleteButtonIndexPath {
            if self.editMode {
                let cell = self.getButtonCell()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "Delete"
                cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
                return cell
            } else {
                fatalError("can't have a delete button outside edit mode")
            }
        }
        
        fatalError("unknown view cell requested for \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == self.patchIndexPath {
            
            if self.editMode {
        
                guard let data = self.interactor?.getAllPatchNames() else {
                    fatalError("Can't get all patch names")
                }
                
                var selectedIndex: Int = data.firstIndex(of: self.viewModel?.patchName ?? "--") ?? -1
                if selectedIndex == -1 {
                    selectedIndex = 0
                }
                
                self.interactor?.showPatchName(title: "Patch", data: data, selectedIndex: selectedIndex, onSelect: { newSelection in
                    
                    print("newSelection: \(newSelection)")
                    self.viewModel?.patchName = newSelection
                    self.patchNameTmp = newSelection
                    self.tableView.reloadRows(at: [self.patchIndexPath], with: .automatic)
                })
            } else {
                self.interactor?.showPatch(named: self.viewModel?.patchName ?? "--")
            }
        }
        
        if indexPath == self.deleteButtonIndexPath {
            
            if self.editMode {
                
                if let itemViewModel = self.viewModel {
                    
                    self.askQuestion(title: "Sure?", message: "Do you really want to delete item '\(itemViewModel.name)'?", buttonTitle: "Delete"){ (action) in
                        self.interactor?.delete(item: itemViewModel)
                    }
                }
                
            } else {
                fatalError("Can't delete item outside edit mode")
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ItemViewController: ItemViewInputProtocol {
    
    func presentUserFeedback(message: String) {
        
        self.showToast(message: message)
    }
    
    func updateViewModel(identifier: NSManagedObjectID?) {
        
        self.viewModel?.identifier = identifier
    }
    
    func toggleDetail() {
        self.editMode = false
        self.setup()
    }
}

extension ItemViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if !self.editMode {
            return
        }
        
        self.itemMarker?.position = position.target
        
        self.viewModel?.latitude = position.target.latitude
        self.viewModel?.longitude = position.target.longitude
        
        self.latitudeTmp = position.target.latitude
        self.longitudeTmp = position.target.longitude
        
        self.tableView.reloadRows(at: [self.latitudeIndexPath, self.longitudeIndexPath], with: .automatic)
    }
}

extension ItemViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView?.mapType = .satellite
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !self.editMode {
            return
        }
        
        guard let location = locations.first else {
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        
        self.itemMarker?.position = location.coordinate
        
        self.viewModel?.latitude = location.coordinate.latitude
        self.viewModel?.longitude = location.coordinate.longitude
        
        self.latitudeTmp = location.coordinate.latitude
        self.longitudeTmp = location.coordinate.longitude
        
        self.tableView.reloadRows(at: [self.latitudeIndexPath, self.longitudeIndexPath], with: .automatic)
    }
}

extension ItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
