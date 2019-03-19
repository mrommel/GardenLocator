//
//  PatchViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

class PatchViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    var backButton: UIBarButtonItem?
    
    // Misc
    var editMode: Bool = false
    //var router: Router?
    var presenter: PatchPresenterInputProtocol?
    var interactor: PatchInteractorInputProtocol?
    var viewModel: PatchViewModel?
    
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePatch))
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
    
    @IBAction func savePatch(sender: UIView?) {
        
        guard let cell = self.tableView.cellForRow(at: nameIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        var isNewPatch: Bool = false
        let name = cell.textFieldValue()

        if self.viewModel == nil {
            // create new patch
            self.viewModel = PatchViewModel(name: name)
            isNewPatch = true
        } else {
            // update current patch
            self.viewModel?.name = name
            isNewPatch = false
        }
        
        // is valid?
        if !(self.viewModel?.isValid() ?? false) {
            
            self.showError(title: "Invalid", message: "Name must not be empty")
            return
        }
        
        // save patch or new patch
        if isNewPatch {
            self.interactor?.create(patch: self.viewModel)
        } else {
            self.interactor?.save(patch: self.viewModel)
        }
            
        self.editMode = false
        self.setup()
    }
}

extension PatchViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            headerImageView.image = R.image.field()
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
        
        if self.editMode {
            return 1
        } else {
            return 1
        }
    }
    
    func getNameCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNameLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNameLabelIdentifier)
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
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = self.viewModel?.name ?? ""
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                    
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
        
        if indexPath == self.deleteButtonIndexPath {
        
            if self.editMode {
                
                if let patchViewModel = self.viewModel {
                    
                    self.askQuestion(title: "Sure?", message: "Do you really want to delete patch '\(patchViewModel.name)'?", buttonTitle: "Delete"){ (action) in
                        self.interactor?.delete(patch: patchViewModel)
                    }
                }
            } else {
                fatalError("Can't delete patch outside edit mode")
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PatchViewController: PatchViewInputProtocol {
    
    func presentUserFeedback(message: String) {
        
        self.showToast(message: message)
    }
}
