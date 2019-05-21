//
//  CategoryViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData
import UIKit

class CategoryViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    var backButton: UIBarButtonItem?
    
    // Misc
    var editMode: Bool = false
    var presenter: CategoryPresenterInputProtocol?
    var interactor: CategoryInteractorInputProtocol?
    var viewModel: CategoryViewModel?
    var parentViewModel: CategoryViewModel?
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
    
    let deleteButtonIndexPath = IndexPath(row: 0, section: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel?.name
        
        if viewModel == nil {
            self.editMode = true
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(TextInputTableViewCell.self , forCellReuseIdentifier: self.presenter?.reuseNameTextfieldIdentifier ?? "")
        
        // store back button
        self.backButton = self.navigationItem.backBarButtonItem
        
        // register for notifications when the keyboard appears:
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let identifier = self.viewModel?.identifier {
            self.interactor?.refreshData(for: identifier)
        }
    }
    
    func setup() {
        
        if self.editMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditMode))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCategory))
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
    
    @IBAction func saveCategory(sender: UIView?) {
        
        guard let cell = self.tableView.cellForRow(at: nameIndexPath) as? TextInputTableViewCell else {
            return
        }
        
        var isNewCategory: Bool = false
        let name = cell.textFieldValue()
        
        if self.viewModel == nil {
            // create new category
            self.viewModel = CategoryViewModel(name: name, childCategoryNames: [], itemNames: [])
            isNewCategory = true
        } else {
            // update current category
            self.viewModel?.name = name
            isNewCategory = false
        }
        
        // is valid?
        if !(self.viewModel?.isValid() ?? false) {
            
            self.showError(title: "Alles falsch", message: "Geht nicht")
            return
        }
        
        // save patch or new patch
        if isNewCategory {
            self.interactor?.create(category: self.viewModel, parent: self.parentViewModel)
        } else {
            self.interactor?.save(category: self.viewModel, parent: self.parentViewModel)
        }
        
        self.editMode = false
        self.setup()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        //self.tableView.contentOffset.y = 200
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        //self.tableView.contentOffset.y = 0
    }
}

extension CategoryViewController: CategoryViewInputProtocol {
    
    func updateViewModel(identifier: NSManagedObjectID?) {
        
        self.viewModel?.identifier = identifier
    }
    
    func presentUserFeedback(message: String) {
        
        self.showToast(message: message)
    }

    func toggleDetail() {
        
        self.editMode = false
        self.setup()
    }
    
    func reloadDetail(with categoryViewModel: CategoryViewModel?) {
        
        self.viewModel = categoryViewModel
        
        self.tableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return App.Constants.tableSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return R.string.localizable.categorySubcategoriesTitle()
        }
        
        if section == 2 {
            if !self.editMode {
                return R.string.localizable.categoryItemsTitle()
            }
        }

        return nil
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.viewModel == nil { // when we create a new category - we don't have items and we can't add children
            return 1
        }
        
        if self.editMode { // properties + children + delete button
            return 3
        }
        
        return 3 // properties + children + add child button
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 // name
        }
        
        if section == 1 {
            if self.editMode {
                return self.viewModel?.childCategoryNames.count ?? 0
            } else {
                return (self.viewModel?.childCategoryNames.count ?? 0) + 1 // add child button
            }
        }
        
        if section == 2 {
            if self.editMode {
                return 1 // delete button
            } else {
                return self.viewModel?.itemNames.count ?? 0 // items <<<<
            }
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // only show when in edit mode
        if !self.editMode {
            return []
        }
        
        if indexPath.section == 1 {
        
            // add category button should not have delete action
            if indexPath.row == self.viewModel?.childCategoryNames.count ?? 0 {
                return []
            }
            
            let deleteAction = UITableViewRowAction(style: .destructive, title: R.string.localizable.buttonDelete()) { (action, indexPath) in
                
                if let itemName = self.viewModel?.itemName(at: indexPath.row) {
                    self.viewModel?.removeItem(named: itemName)
                    self.tableView.reloadData()
                }
            }
            
            return [deleteAction]
        }
        
        return []
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = self.presenter else {
            fatalError("presenter not present")
        }
        
        if indexPath == self.nameIndexPath {
            
            if self.editMode {
                return presenter.getTextFieldCell(titled: R.string.localizable.categoryNameTitle(),
                                                  value: self.viewModel?.name ?? "",
                                                  placeholder: R.string.localizable.categoryNamePlaceholder(),
                                                  tag: 0,
                                                  in: self.tableView)
            } else {
                return presenter.getNameValueCell(for: R.string.localizable.categoryNameTitle(),
                                                  and: self.viewModel?.name ?? "",
                                                  in: self.tableView)
            }
        }
        
        if indexPath.section == 1 {
            
            if !self.editMode {
                if indexPath.row < self.viewModel?.childCategoryNames.count ?? 0 {
                    return presenter.getCategoryCell(titled: self.viewModel?.childCategoryName(at: indexPath.row) ?? "",
                                                     withAccessoryType: self.editMode ? .none : .disclosureIndicator,
                                                     in: self.tableView)
                } else {
                    return presenter.getButtonCell(titled: R.string.localizable.categoryAddCategory(),
                                                   in: self.tableView)
                }
            } else {
                return presenter.getCategoryCell(titled: self.viewModel?.childCategoryName(at: indexPath.row) ?? "",
                                                 withAccessoryType: self.editMode ? .none : .disclosureIndicator,
                                                 in: self.tableView)
            }
        }
        
        if indexPath.section == 2 {
            
            if self.editMode {
                // delete button is only displayed in edit mode
                if indexPath == self.deleteButtonIndexPath {
                    if self.editMode {
                        return presenter.getButtonCell(titled: R.string.localizable.buttonDelete(),
                                                       in: self.tableView)
                    }
                }
            } else {
                return presenter.getItemCell(titled: self.viewModel?.itemName(at: indexPath.row) ?? "",
                                             in: self.tableView)
            }
        }

        fatalError("unknown view cell requested for \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == self.deleteButtonIndexPath {
            
            if self.editMode {
                
                if let categoryViewModel = self.viewModel {
                    
                    self.askQuestion(title: R.string.localizable.categoryDeleteQuestionTitle(),
                                     message: R.string.localizable.categoryDeleteQuestionMessage(categoryViewModel.name),
                                     buttonTitle: R.string.localizable.buttonDelete()) { (action) in
                                        self.interactor?.delete(category: categoryViewModel)
                    }
                }
                return
            }
        }
        
        if indexPath.section == 1 {
            if !self.editMode {
                if indexPath.row < self.viewModel?.childCategoryNames.count ?? 0 {
                    if let categoryName = self.viewModel?.childCategoryName(at: indexPath.row) {
                        self.interactor?.showCategory(named: categoryName)
                    }
                } else {
                    self.interactor?.showCategoryWith(parent: self.viewModel)
                }
            }
        }
        
        if indexPath.section == 2 {
            if !self.editMode {
                if let itemName = self.viewModel?.itemName(at: indexPath.row) {
                    self.interactor?.showItem(named: itemName)
                }
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
