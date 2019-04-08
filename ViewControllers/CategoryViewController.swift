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
    
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseCategoryLabelIdentifier: String = "reuseCategoryLabelIdentifier"
    
    let nameIndexPath = IndexPath(row: 0, section: 0)
    
    let deleteButtonIndexPath = IndexPath(row: 0, section: 1)
    let addButtonIndexPath = IndexPath(row: 0, section: 2)

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
            self.viewModel = CategoryViewModel(name: name, childCategoryNames: [])
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
        
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !self.editMode {
            if section == 1 {
                return R.string.localizable.categorySubcategoriesTitle()
            }
        }
        return nil
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.viewModel == nil { // when we create a new category - we don't have items and we can't add children
            return 1
        }
        
        if self.editMode { // properties + delete button
            return 2
        }
        
        return 3 // properties + children + add button
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 // name
        }
        
        if section == 1 {
            if self.editMode {
                return 1 // delete button
            } else {
                return self.viewModel?.childCategoryNames.count ?? 0
            }
        }
        
        if section == 2 {
            if !self.editMode {
                return 1 // add button
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
    
    func getCategoryCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseCategoryLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseCategoryLabelIdentifier)
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
                cell.configure(title: R.string.localizable.categoryNameTitle(), textFieldValue: self.viewModel?.name ?? "", placeHolder: R.string.localizable.categoryNamePlaceholder())
                return cell
            } else {
                let cell = self.getNameCell()
                
                cell.textLabel?.text = R.string.localizable.categoryNameTitle()
                cell.detailTextLabel?.text = self.viewModel?.name ?? ""
                cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                
                return cell
            }
        }
        
        // delete button is only displayed in edit mode
        if indexPath == self.deleteButtonIndexPath {
            if self.editMode {
                let cell = self.getButtonCell()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = R.string.localizable.buttonDelete()
                cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
                return cell
            }
        }
        
        // add button is only displayed in view mode
        if indexPath == self.addButtonIndexPath {
            if !self.editMode {
                let cell = self.getButtonCell()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = R.string.localizable.categoryAddCategory()
                cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
                return cell
            }
        }
        
        if indexPath.section == 1 {
            if !self.editMode {
                let cell = getCategoryCell()
                cell.imageView?.image = R.image.category()
                cell.textLabel?.text = self.viewModel?.childCategoryName(at: indexPath.row)
                cell.textLabel?.textColor = App.Color.tableViewCellTextEnabledColor
                cell.accessoryType = .disclosureIndicator
                return cell
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
        
        if indexPath == self.addButtonIndexPath {
            
            if !self.editMode {
                
                self.interactor?.showCategoryWith(parent: self.viewModel)
            }
        }
        
        if indexPath.section == 1 {
            if let categoryName = self.viewModel?.childCategoryName(at: indexPath.row) {
                self.interactor?.showCategory(named: categoryName)
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
