//
//  ItemViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    var backButton: UIBarButtonItem?
    
    // Misc
    var editMode: Bool = false

    var presenter: ItemPresenterInputProtocol?
    var interactor: ItemInteractorInputProtocol?
    var viewModel: ItemViewModel?
    
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
    let latitudeIndexPath = IndexPath(row: 1, section: 0)
    let longitudeIndexPath = IndexPath(row: 2, section: 0)
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
        
        // store back button
        self.backButton = self.navigationItem.backBarButtonItem
        
        self.setup()
    }
    
    func setup() {
        
        if self.editMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditMode))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        } else {
            self.navigationItem.leftBarButtonItem = self.backButton
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEditMode))
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
        
        guard let nameCell = self.tableView.cellForRow(at: nameIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        guard let latitudeCell = self.tableView.cellForRow(at: latitudeIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        guard let longitudeCell = self.tableView.cellForRow(at: longitudeIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        var isNewPatch: Bool = false
        let name = nameCell.textFieldValue()
        let latitude = Double(latitudeCell.textFieldValue()) ?? 0.0
        let longitude = Double(longitudeCell.textFieldValue()) ?? 0.0
        
        if self.viewModel == nil {
            // create new patch
            self.viewModel = ItemViewModel(latitude: latitude, longitude: longitude, name: name)
            isNewPatch = true
        } else {
            // update current patch
            self.viewModel?.latitude = latitude
            self.viewModel?.longitude = longitude
            self.viewModel?.name = name
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
        
        self.editMode = false
        self.setup()
    }
}

extension ItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 && !self.editMode {
            return 100.0
        } else {
            return 20.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 && !self.editMode {
            let headerImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
            headerImageView.image = R.image.pin()
            headerImageView.contentMode = .scaleAspectFit
            
            let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
            headerView.addSubview(headerImageView)
            return headerView
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
                return 3
            } else {
                return 1
            }
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.editMode {
            if indexPath == self.nameIndexPath {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: "Name", textFieldValue: self.viewModel?.name ?? "", placeHolder: "Enter some text!")
                return cell
            } else if indexPath == self.latitudeIndexPath {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: "Latitude", textFieldValue: "\(self.viewModel?.latitude ?? 0.0)", placeHolder: "Enter some latitude")
                return cell
            } else if indexPath == self.longitudeIndexPath {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
                cell.configure(title: "Longitude", textFieldValue: "\(self.viewModel?.longitude ?? 0.0)", placeHolder: "Enter some longitude")
                return cell
            } else /* if indexPath.section == 1 */ {
                if let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameLabelIdentifier) {
                    return cell
                } else {
                    return UITableViewCell(style: .default, reuseIdentifier: reuseNameLabelIdentifier)
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameLabelIdentifier) {
                return cell
            } else {
                return UITableViewCell(style: .default, reuseIdentifier: reuseNameLabelIdentifier)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.editMode && indexPath.section == 1 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Delete"
            cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
        } else if !self.editMode {
            
            if indexPath == self.nameIndexPath {
                cell.textLabel?.text = self.viewModel?.name ?? ""
            } else if indexPath == self.latitudeIndexPath {
                cell.textLabel?.text = "\(self.viewModel?.latitude ?? 0.0)"
            } else if indexPath == self.longitudeIndexPath {
                cell.textLabel?.text = "\(self.viewModel?.longitude ?? 0.0)"
            }
            
            cell.textLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == self.deleteButtonIndexPath {
            
            if self.editMode {
                
                if let itemViewModel = self.viewModel {
                    let alertController = UIAlertController(title: "Sure?", message: "Do you really want to delete patch '\(itemViewModel.name)'?", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alertController.addAction(cancelAction)
                    
                    let okAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                        self.interactor?.delete(item: itemViewModel)
                    }
                    
                    alertController.addAction(okAction)
                    
                    alertController.view.tintColor = App.Color.alertControllerTintColor
                    alertController.view.backgroundColor = App.Color.alertControllerBackgroundColor
                    
                    self.present(alertController, animated: true, completion: nil)
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
}
