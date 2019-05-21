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
import Rswift

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
    let initialLatitude = 52.492310
    let initialLongitude = 13.532160

    var presenter: ItemPresenterInputProtocol?
    var interactor: ItemInteractorInputProtocol?
    var viewModel: ItemViewModel?

    // tmp values
    var patchNameTmp: String = ""
    var longitudeTmp: Double = 0.0
    var latitudeTmp: Double = 0.0

    let nameIndexPath = IndexPath(row: 0, section: 0)
    let latitudeIndexPath = IndexPath(row: 1, section: 0)
    let longitudeIndexPath = IndexPath(row: 2, section: 0)
    let patchIndexPath = IndexPath(row: 3, section: 0)
    let noticeIndexPath = IndexPath(row: 4, section: 0)
    let deleteButtonIndexPath = IndexPath(row: 0, section: 2)
    
    private let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel?.name

        if self.viewModel == nil {
            self.editMode = true
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.presenter?.reuseCategoryHeaderIdentifier ?? "")
        self.tableView.register(TextInputTableViewCell.self, forCellReuseIdentifier: self.presenter?.reuseNameTextfieldIdentifier ?? "")
        self.tableView.register(MultilineTextFieldTableViewCell.self, forCellReuseIdentifier: self.presenter?.reuseNoticeTextfieldIdentifier ?? "")

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

        guard let noticeCell = self.tableView.cellForRow(at: self.noticeIndexPath) as? MultilineTextFieldTableViewCell else {
            return
        }

        var isNewPatch: Bool = false
        let name = nameCell.textFieldValue()
        let latitude = Double(self.latitudeTmp)
        let longitude = Double(self.longitudeTmp)
        let patchName = self.patchNameTmp
        let notice = noticeCell.textFieldValue()

        if self.viewModel == nil {
            // create new patch
            self.viewModel = ItemViewModel(latitude: latitude,
                longitude: longitude,
                name: name,
                patchName: patchName,
                notice: notice,
                categoryNames: [])
            isNewPatch = true
        } else {
            // update current patch
            self.viewModel?.latitude = latitude
            self.viewModel?.longitude = longitude
            self.viewModel?.name = name
            self.viewModel?.patchName = patchName
            self.viewModel?.notice = notice
            isNewPatch = false
        }

        // is valid?
        if !(self.viewModel?.isValid() ?? false) {

            self.showError(title: R.string.localizable.itemInvalidTitle(),
                message: R.string.localizable.itemInvalidMessage())
            return
        }

        // save patch or create new item
        if isNewPatch {
            self.interactor?.create(item: self.viewModel)
        } else {
            self.interactor?.save(item: self.viewModel)
        }
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

extension ItemViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 280.0
        } else {
            return App.Constants.tableSectionHeaderHeight
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let presenter = self.presenter else {
            fatalError("presenter not present")
        }
        
        if section == 0 {
            return self.mapView
        } else if section == 1 {
            return presenter.getSectionHeader(titled: R.string.localizable.itemCategories(),
                                              in: self.tableView)
        } else {
            return nil
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {

        if self.editMode && self.viewModel != nil {
            return 3
        } else {
            return 2
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        // only show when in edit mode
        if !self.editMode {
            return []
        }
        
        if indexPath.section == 0 {
            return []
        }
        
        if indexPath.section == 1 {
            // add category button should not have delete action
            if indexPath.row == self.viewModel?.categoryNames.count ?? 0 {
                return []
            }
            
            // only categoryies
            let deleteAction = UITableViewRowAction(style: .destructive, title: R.string.localizable.buttonDelete()) { (action, indexPath) in
                
                if let categoryName = self.viewModel?.categoryName(at: indexPath.row) {
                    self.viewModel?.removeCategory(named: categoryName)
                    self.tableView.reloadData()
                }
            }
            
            return [deleteAction]
        }

        return []
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.editMode && self.viewModel != nil {
            if section == 0 {
                return 5 // name, lat, lon, patch, notice
            } else if section == 1 {
                return (self.viewModel?.categoryNames.count ?? 0) + 1 // number of categories + add button
            } else {
                return 1
            }
        } else {
            if section == 0 {
                return 5 // name, lat, lon, patch, notice
            } else {
                return self.viewModel?.categoryNames.count ?? 0 // number of categories
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == noticeIndexPath {
            if self.editMode {
                let height = self.viewModel?.notice.heightWithConstrained(width: self.view.bounds.width - 30, font: App.Font.textViewFont) ?? 50
                return max(height + 24, 50)
            } else {
                let height = self.viewModel?.notice.heightWithConstrained(width: self.view.bounds.width - 100, font: App.Font.textViewFont) ?? 50
                return max(height + 24, 50)
            }
        }
        
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let presenter = self.presenter else {
            fatalError("presenter not present")
        }
        
        if indexPath == self.nameIndexPath {

            if self.editMode {
                return presenter.getTextFieldCell(titled: R.string.localizable.itemNameTitle(),
                                                  value: self.viewModel?.name ?? "",
                                                  placeholder: R.string.localizable.itemNamePlaceholder(),
                                                  tag: 0,
                                                  in: tableView)
            } else {
                return presenter.getNameValueCell(for: R.string.localizable.itemNameTitle(),
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
                                                  in: self.tableView)
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
                    in: self.tableView)
            } else {
                return presenter.getNameValueCell(for: R.string.localizable.itemLongitudeTitle(),
                                                  and: "\(self.viewModel?.longitude ?? self.longitudeTmp)",
                    in: self.tableView)
            }
        }

        if indexPath == self.patchIndexPath {

            return presenter.getPatchCell(titled: R.string.localizable.itemPatch(),
                                          detail: self.viewModel?.patchName ?? self.patchNameTmp,
                                          accessoryType: self.editMode ? .none : .disclosureIndicator,
                                          in: self.tableView)
        }

        if indexPath == self.noticeIndexPath {

            if self.editMode {
                return presenter.getNoticeTextFieldCell(with: self.viewModel?.notice ?? "",
                                                        in: self.tableView)
            } else {
                return presenter.getNoticeTextCell(with: self.viewModel?.notice ?? "",
                                                   in: self.tableView)
            }
        }
        
        // categories
        if indexPath.section == 1 {
            if self.editMode {
                if indexPath.row < self.viewModel?.categoryNames.count ?? 0 {
                    return presenter.getCategoryCell(titled: self.viewModel?.categoryName(at: indexPath.row) ?? "",
                                                     in: self.tableView)
                } else {
                    return presenter.getAddCategoryButtonCell(in: self.tableView)
                }
            } else {
                return presenter.getCategoryCell(titled: self.viewModel?.categoryName(at: indexPath.row) ?? "",
                                                 in: self.tableView)
            }
        }

        if indexPath == self.deleteButtonIndexPath {
            if self.editMode {
                return presenter.getDeleteButtonCell(in: self.tableView)
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

                self.interactor?.showPatchName(title: R.string.localizable.itemPatch(), data: data, selectedIndex: selectedIndex, onSelect: { newSelection in

                        self.viewModel?.patchName = newSelection
                        self.patchNameTmp = newSelection
                        self.tableView.reloadRows(at: [self.patchIndexPath], with: .automatic)
                    })
            } else {
                self.interactor?.showPatch(named: self.viewModel?.patchName ?? "--")
            }
        }
        
        if indexPath.section == 1 { // categories
            
            if self.editMode && indexPath.row == self.viewModel?.categoryNames.count ?? 0 {
                // add category
                guard let data = self.interactor?.getAllCategoryNames() else {
                    fatalError("Can't get all categories names")
                }
                
                self.interactor?.showCategoryName(title: R.string.localizable.itemCategoriesNew(), data: data, selectedIndex: 0, onSelect: { newSelection in
                    
                    // store
                    self.viewModel?.addCategory(named: newSelection)
                    
                    // update
                    self.tableView.reloadData()
                })
            }
            
            if !self.editMode {
                // goto selcted category
                
            }
        }

        if indexPath == self.deleteButtonIndexPath {

            if self.editMode {

                if let itemViewModel = self.viewModel {

                    self.askQuestion(title: R.string.localizable.itemDeleteQuestionTitle(),
                        message: R.string.localizable.itemDeleteQuestionMessage(itemViewModel.name),
                        buttonTitle: R.string.localizable.buttonDelete()) { (action) in
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

    }
}
