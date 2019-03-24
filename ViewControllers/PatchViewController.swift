//
//  PatchViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift
import GoogleMaps
import CoreData

class PatchViewController: UIViewController {
    
    // Views
    var mapView: GMSMapView?
    @IBOutlet weak var tableView: UITableView!
    var backButton: UIBarButtonItem?
    
    // Misc
    var editMode: Bool = false
    var camera: GMSCameraPosition?
    var shape: GMSOverlay?
    var presenter: PatchPresenterInputProtocol?
    var interactor: PatchInteractorInputProtocol?
    var viewModel: PatchViewModel?
    let locationManager = CLLocationManager()
    let initialLatitude = 52.520736
    let initialLongitude = 13.409423
    
    // tmp values
    var shapeTmp: PatchShape = .circle
    var longitudeTmp: Double = 0.0
    var latitudeTmp: Double = 0.0
    
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    let reuseItemLabelIdentifier: String = "reuseItemLabelIdentifier"
    let reuseShapeSelectionIdentifier: String = "reuseShapeSelectionIdentifier"
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
    let latitudeIndexPath = IndexPath(row: 1, section: 0)
    let longitudeIndexPath = IndexPath(row: 2, section: 0)
    let shapeIndexPath = IndexPath(row: 3, section: 0)
    
    let deleteButtonIndexPath = IndexPath(row: 0, section: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel?.name
        
        if viewModel == nil {
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
            self.shapeTmp = model.shape
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
            self.shape = model.polygon()
            self.shape?.map = self.mapView
        }
        
        // store back button
        self.backButton = self.navigationItem.backBarButtonItem
        
        self.setup()
    }
    
    func setup() {
        
        if self.editMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditMode))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePatch))
            
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
    
    @IBAction func savePatch(sender: UIView?) {
        
        guard let cell = self.tableView.cellForRow(at: nameIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        var isNewPatch: Bool = false
        let name = cell.textFieldValue()
        let latitude = Double(self.latitudeTmp)
        let longitude = Double(self.longitudeTmp)
        let shapeValue = self.shapeTmp

        if self.viewModel == nil {
            // create new patch
            self.viewModel = PatchViewModel(name: name,
                                            latitude: latitude,
                                            longitude: longitude,
                                            shape: shapeValue)
            isNewPatch = true
        } else {
            // update current patch
            self.viewModel?.name = name
            self.viewModel?.latitude = latitude
            self.viewModel?.longitude = longitude
            self.viewModel?.shape = shapeValue
            isNewPatch = false
        }
        
        // is valid?
        if !(self.viewModel?.isValid() ?? false) {
            
            self.showError(title: R.string.localizable.patchInvalidTitle(),
                           message: R.string.localizable.patchInvalidMessage())
            return
        }
        
        // save patch or new patch
        if isNewPatch {
            self.interactor?.create(patch: self.viewModel)
            
            // show the polygon
            self.shape = self.viewModel?.polygon()
            self.shape?.map = self.mapView
        } else {
            self.interactor?.save(patch: self.viewModel)
        }
            
        self.editMode = false
        self.setup()
    }
}

extension PatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 280.0
        } else {
            return 30.0
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
        
        if self.viewModel == nil { // when we create a new patch - we don't have items
            return 1
        }
        
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4 // name, lat, lon, shape
        }
        
        if section == 1 {
            if self.editMode {
                return 1 // delete button
            } else {
                return self.viewModel?.itemNames.count ?? 0
            }
        }
        
        return 0
    }
    
    func getNameCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNameLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNameLabelIdentifier)
    }
    
    func getItemCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseItemLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseItemLabelIdentifier)
    }
    
    func getShapeCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseShapeSelectionIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseShapeSelectionIdentifier)
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
                cell.configure(title: R.string.localizable.patchNameTitle(), textFieldValue: self.viewModel?.name ?? "", placeHolder: R.string.localizable.patchNamePlaceholder())
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = R.string.localizable.patchNameTitle()
                cell.detailTextLabel?.text = self.viewModel?.name ?? ""
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                    
                return cell
            }
        }
        
        if indexPath == self.latitudeIndexPath {
            
            if self.editMode {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: R.string.localizable.itemLatitudeTitle(),
                               textFieldValue: "\(self.viewModel?.latitude ?? self.latitudeTmp)",
                    placeHolder: R.string.localizable.itemLatitudePlaceholder())
                cell.textField.tag = 1
                cell.textField.delegate = self
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = R.string.localizable.itemLatitudeTitle()
                cell.detailTextLabel?.text = "\(self.viewModel?.latitude ?? self.latitudeTmp)"
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                
                return cell
            }
        }
        
        if indexPath == self.longitudeIndexPath {
            
            if self.editMode {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: R.string.localizable.itemLongitudeTitle(),
                               textFieldValue: "\(self.viewModel?.longitude ?? self.longitudeTmp)",
                    placeHolder: R.string.localizable.itemLongitudePlaceholder())
                cell.textField.tag = 2
                cell.textField.delegate = self
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = R.string.localizable.itemLongitudeTitle()
                cell.detailTextLabel?.text = "\(self.viewModel?.longitude ?? self.longitudeTmp)"
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                
                return cell
            }
        }
        
        if indexPath == self.shapeIndexPath {
            
            if self.editMode {
                let cell = self.getShapeCell()
                
                cell.textLabel?.text = "Shape"
                if let viewModel = self.viewModel {
                    cell.detailTextLabel?.text = viewModel.shape.title
                } else {
                    cell.detailTextLabel?.text = self.shapeTmp.title
                }
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                cell.accessoryType = .none
                
                return cell
            } else {
                let cell = self.getShapeCell()
                
                cell.textLabel?.text = "Shape"
                cell.detailTextLabel?.text = self.viewModel?.shape.title
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                cell.accessoryType = .none
                
                return cell
            }
        }
        
        // delete button is only display in edit mode
        if indexPath == self.deleteButtonIndexPath {
            if self.editMode {
                let cell = self.getButtonCell()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = R.string.localizable.buttonDelete()
                cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
                return cell
            }
        }
        
        if indexPath.section == 1 {
            if !self.editMode {
                let cell = getItemCell()
                cell.imageView?.image = R.image.pin()
                cell.textLabel?.text = self.viewModel?.itemName(at: indexPath.row)
                cell.textLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        
        fatalError("unknown view cell requested for \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == self.shapeIndexPath {
            
            if self.editMode {
                
                let data = PatchShape.allCases.map { $0.title }
                
                var selectedIndex: Int = data.firstIndex(of: self.viewModel?.shape.title ?? "--") ?? -1
                if selectedIndex == -1 {
                    selectedIndex = 0
                }
                
                self.interactor?.showPatchShapes(title: "Shape", data: data, selectedIndex: selectedIndex, onSelect: { newSelection in
                    
                    if let newShape = PatchShape.allCases.first(where: { $0.title == newSelection }) {
                    
                        self.viewModel?.shape = newShape
                        self.shapeTmp = newShape
                        
                        // reset old marker
                        self.shape?.map = nil
                        
                        self.shape = self.viewModel?.polygon()
                        self.shape?.map = self.mapView
                    }
                    self.tableView.reloadRows(at: [self.shapeIndexPath], with: .automatic)
                })
            }
        }
        
        if indexPath == self.deleteButtonIndexPath {
        
            if self.editMode {
                
                if let patchViewModel = self.viewModel {
                    
                    self.askQuestion(title: R.string.localizable.patchDeleteQuestionTitle(),
                                     message: R.string.localizable.patchDeleteQuestionMessage(patchViewModel.name),
                                     buttonTitle: R.string.localizable.buttonDelete()){ (action) in
                        self.interactor?.delete(patch: patchViewModel)
                    }
                }
                return
            }
        }
        
        if indexPath.section == 1 {
            let itemName = self.viewModel?.itemName(at: indexPath.row)
            self.interactor?.showItem(named: itemName ?? "--")
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PatchViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if !self.editMode {
            return
        }
        
        // TODO
        if let circle = self.shape as? GMSCircle {
            circle.position = position.target
        } else if let polygon = self.shape as? GMSPolygon {
            polygon.center(at: position.target)
        }
        // self.itemMarker?.position = position.target
        
        self.viewModel?.latitude = position.target.latitude
        self.viewModel?.longitude = position.target.longitude
        
        self.latitudeTmp = position.target.latitude
        self.longitudeTmp = position.target.longitude
        
        self.tableView.reloadRows(at: [self.latitudeIndexPath, self.longitudeIndexPath], with: .automatic)
    }
}

extension PatchViewController: CLLocationManagerDelegate {
    
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
        
        // self.itemMarker?.position = location.coordinate // TODO
        
        self.viewModel?.latitude = location.coordinate.latitude
        self.viewModel?.longitude = location.coordinate.longitude
        
        self.latitudeTmp = location.coordinate.latitude
        self.longitudeTmp = location.coordinate.longitude
        
        self.tableView.reloadRows(at: [self.latitudeIndexPath, self.longitudeIndexPath], with: .automatic)
    }
}

extension PatchViewController: PatchViewInputProtocol {
    
    func updateViewModel(identifier: NSManagedObjectID?) {
        
        self.viewModel?.identifier = identifier
    }
    
    func presentUserFeedback(message: String) {
        
        self.showToast(message: message)
    }
}

extension PatchViewController: UITextFieldDelegate {
    
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
