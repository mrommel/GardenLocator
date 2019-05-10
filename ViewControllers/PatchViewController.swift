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
    let initialLatitude = 52.492310
    let initialLongitude = 13.532160
    
    // tmp values
    var shapeTmp: PatchShape = .circle
    var longitudeTmp: Double = 0.0
    var latitudeTmp: Double = 0.0
    var colorTmp: PatchColor = .maroon
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
    let latitudeIndexPath = IndexPath(row: 1, section: 0)
    let longitudeIndexPath = IndexPath(row: 2, section: 0)
    let shapeIndexPath = IndexPath(row: 3, section: 0)
    let colorIndexPath = IndexPath(row: 4, section: 0)
    
    let deleteButtonIndexPath = IndexPath(row: 0, section: 1)
    
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel?.name
        
        if viewModel == nil {
            self.editMode = true
        } 
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(TextInputTableViewCell.self, forCellReuseIdentifier: self.presenter?.reuseNameTextfieldIdentifier ?? "")
        
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
        
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setup()
        
        self.networkManager.reachability?.whenUnreachable = { _ in
            self.interactor?.showOfflinePage()
        }
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
        let colorValue = self.colorTmp

        if self.viewModel == nil {
            // create new patch
            self.viewModel = PatchViewModel(name: name,
                                            latitude: latitude,
                                            longitude: longitude,
                                            shape: shapeValue,
                                            color: colorValue)
            isNewPatch = true
        } else {
            // update current patch
            self.viewModel?.name = name
            self.viewModel?.latitude = latitude
            self.viewModel?.longitude = longitude
            self.viewModel?.shape = shapeValue
            self.viewModel?.color = colorValue
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.tableView.contentOffset.y = 200
        self.mapView?.isHidden = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.tableView.contentOffset.y = 0
        self.mapView?.isHidden = false
    }
}

extension PatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 280.0
        } else {
            return App.Constants.tableSectionHeaderHeight
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
            return 5 // name, lat, lon, shape, color
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = self.presenter else {
            fatalError("presenter not present")
        }
        
        if indexPath == self.nameIndexPath {
            
            if self.editMode {
                return presenter.getTextFieldCell(titled: R.string.localizable.patchNameTitle(),
                                                  value: self.viewModel?.name ?? "",
                                                  placeholder: R.string.localizable.patchNamePlaceholder(),
                                                  tag: 0,
                                                  in: tableView)
            } else {
                return presenter.getNameValueCell(for: R.string.localizable.patchNameTitle(),
                                                  and: self.viewModel?.name ?? "",
                                                  in: self.tableView)
            }
        }
        
        if indexPath == self.latitudeIndexPath {
            
            if self.editMode {
                return presenter.getTextFieldCell(titled: R.string.localizable.itemLatitudeTitle(),
                                                 value: "\(self.viewModel?.latitude ?? self.latitudeTmp)",
                                                 placeholder: R.string.localizable.itemLatitudePlaceholder(),
                                                 tag: 1,
                                                 in: tableView)
            } else {
                return presenter.getNameValueCell(for: R.string.localizable.itemLatitudeTitle(),
                                                  and: "\(self.viewModel?.latitude ?? self.latitudeTmp)",
                                                  in: self.tableView)
            }
        }
        
        if indexPath == self.longitudeIndexPath {
            
            if self.editMode {
                return presenter.getTextFieldCell(titled: R.string.localizable.itemLongitudeTitle(),
                                                  value: "\(self.viewModel?.longitude ?? self.longitudeTmp)",
                    placeholder: R.string.localizable.itemLongitudePlaceholder(),
                    tag: 2,
                    in: tableView)
            } else {
                return presenter.getNameValueCell(for: R.string.localizable.itemLongitudeTitle(),
                                                  and: "\(self.viewModel?.longitude ?? self.longitudeTmp)",
                                                  in: self.tableView)
            }
        }
        
        if indexPath == self.shapeIndexPath {
            
            if self.editMode {
                return presenter.getShapeCell(for: self.viewModel?.shape.title ?? self.shapeTmp.title, in: self.tableView)
            } else {
                return presenter.getShapeCell(for: self.viewModel?.shape.title ?? "", in: self.tableView)
            }
        }
        
        if indexPath == self.colorIndexPath {
            
            if self.editMode {
                return presenter.getColorCell(for: self.viewModel?.color.title ?? self.colorTmp.title, in: self.tableView)
            } else {
                return presenter.getColorCell(for: self.viewModel?.color.title ?? "", in: self.tableView)
            }
        }
        
        // delete button is only display in edit mode
        if indexPath == self.deleteButtonIndexPath {
            if self.editMode {
                return presenter.getButtonCell(in: self.tableView)
            }
        }
        
        if indexPath.section == 1 {
            if !self.editMode {
                return presenter.getItemCell(for: self.viewModel?.itemName(at: indexPath.row) ?? "", in: self.tableView)
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
                
                self.interactor?.showPatchShapes(title: R.string.localizable.itemShapeTitle(), data: data, selectedIndex: selectedIndex, onSelect: { newSelection in
                    
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
        
        if indexPath == self.colorIndexPath {
            
            if self.editMode {
                
                let data = PatchColor.allCases.map { $0.title }
                
                var selectedIndex: Int = data.firstIndex(of: self.viewModel?.color.title ?? "--") ?? -1
                if selectedIndex == -1 {
                    selectedIndex = 0
                }
                
                self.interactor?.showPatchShapes(title: R.string.localizable.itemColorTitle(), data: data, selectedIndex: selectedIndex, onSelect: { newSelection in
                    
                    if let newColor = PatchColor.allCases.first(where: { $0.title == newSelection }) {
                        
                        self.viewModel?.color = newColor
                        self.colorTmp = newColor
                        
                        // reset old marker
                        self.shape?.map = nil
                        
                        self.shape = self.viewModel?.polygon()
                        self.shape?.map = self.mapView
                    }
                    self.tableView.reloadRows(at: [self.colorIndexPath], with: .automatic)
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
            if let itemName = self.viewModel?.itemName(at: indexPath.row) {
                self.interactor?.showItem(named: itemName)
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PatchViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if !self.editMode {
            return
        }
        
        if let circle = self.shape as? GMSCircle {
            circle.position = position.target
        } else if let polygon = self.shape as? GMSPolygon {
            polygon.center(at: position.target)
        }
        
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


