//
//  CategoryPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// View Controller must implement this
protocol CategoryViewInputProtocol {
    
    func presentUserFeedback(message: String)
    func updateViewModel(identifier: NSManagedObjectID?)
    func toggleDetail()
    func reloadDetail(with categoryViewModel: CategoryViewModel?)
}

enum CategoryFailure {
    
    case generic
    case notFound
}

protocol CategoryPresenterInputProtocol {
    
    var reuseNameLabelIdentifier: String { get }
    var reuseNameTextfieldIdentifier: String { get }
    
    func reloaded(with categoryViewModel: CategoryViewModel?)
    
    func getNameValueCell(for name: String, and value: String, in tableView: UITableView) -> UITableViewCell
    func getTextFieldCell(titled title: String, value: String, placeholder: String, tag: Int, in tableView: UITableView) -> TextInputTableViewCell
    func getCategoryCell(titled title: String, withAccessoryType accessoryType: UITableViewCell.AccessoryType, in tableView: UITableView) -> UITableViewCell
    func getButtonCell(titled title: String, in tableView: UITableView) -> UITableViewCell
    func getItemCell(titled title: String, in tableView: UITableView) -> UITableViewCell
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: CategoryFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: CategoryFailure)
}

class CategoryPresenter: NSObject {
    
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseCategoryLabelIdentifier: String = "reuseCategoryLabelIdentifier"
    let reuseItemLabelIdentifier: String = "reuseItemLabelIdentifier"
    
    var viewInput: CategoryViewInputProtocol?
    var interator: CategoryInteractorInputProtocol?
}

extension CategoryPresenter: CategoryPresenterInputProtocol {
    
    func reloaded(with categoryViewModel: CategoryViewModel?) {

        self.viewInput?.reloadDetail(with: categoryViewModel)
    }
    
    /// MARK:
    
    private func getNameValueCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNameLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNameLabelIdentifier)
    }
    
    func getCategoryCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseCategoryLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseCategoryLabelIdentifier)
    }
    
    func getItemCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseItemLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseItemLabelIdentifier)
    }
    
    func getButtonCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseButtonIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: self.reuseButtonIdentifier)
    }
    
    /// MARK:
    
    func getNameValueCell(for name: String, and value: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getNameValueCell(for: tableView)
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = value
        cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        
        return cell
    }
    
    func getTextFieldCell(titled title: String, value: String, placeholder: String, tag: Int, in tableView: UITableView) -> TextInputTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseNameTextfieldIdentifier) as! TextInputTableViewCell
        
        cell.configure(title: title, textFieldValue: value, placeHolder: placeholder)
        cell.textField.tag = tag
        cell.textField.delegate = self
        
        return cell
    }
    
    func getCategoryCell(titled title: String, withAccessoryType accessoryType: UITableViewCell.AccessoryType, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getCategoryCell(for: tableView)
        
        cell.imageView?.image = R.image.category()
        cell.textLabel?.text = title
        cell.textLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        cell.accessoryType = accessoryType
        
        return cell
    }
    
    func getButtonCell(titled title: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getButtonCell(for: tableView)
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = title
        cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
        
        return cell
    }
    
    func getItemCell(titled title: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getItemCell(for: tableView)
        
        cell.imageView?.image = R.image.pin()
        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    /// MARK: actions
    
    func saveSuccess(identifier: NSManagedObjectID?) {
        
        self.viewInput?.updateViewModel(identifier: identifier)
        self.viewInput?.presentUserFeedback(message: "Erfolgreich gespeichert")
        
        self.viewInput?.toggleDetail()
    }
    
    func saveFailure(failure: CategoryFailure) {
        
        self.viewInput?.presentUserFeedback(message: "Fehler beim speichern")
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Erfolgriech gelöscht")
        self.interator?.showCategories()
        
        self.viewInput?.toggleDetail()
    }
    
    func deleteFailure(failure: CategoryFailure) {
        
        self.viewInput?.presentUserFeedback(message: "Fehler beim Löschen")
    }
}

extension CategoryPresenter: UITextFieldDelegate {
    
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
