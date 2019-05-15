//
//  ItemPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData
import Rswift

// View Controller must implement this
protocol ItemViewInputProtocol {
    
    func presentUserFeedback(message: String)
    func updateViewModel(identifier: NSManagedObjectID?)
    func toggleDetail()
}

enum ItemFailure {
    
    case generic
    case notFound
}

protocol ItemPresenterInputProtocol {
    
    var reuseCategoryHeaderIdentifier: String { get }
    var reuseNameTextfieldIdentifier: String { get }
    var reuseNoticeTextfieldIdentifier: String { get }
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: ItemFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: ItemFailure)
    
    func getSectionHeader(titled title: String, in tableView: UITableView) -> UIView?
    
    func getNameValueCell(for name: String, and value: String, in tableView: UITableView) -> UITableViewCell
    func getTextFieldCell(titled: String, value: String, placeholder: String, tag: Int, in tableView: UITableView) -> TextInputTableViewCell
    func getPatchCell(titled title: String, detail: String, accessoryType: UITableViewCell.AccessoryType, in tableView: UITableView) -> UITableViewCell
    func getNoticeTextFieldCell(with value: String, in tableView: UITableView)  -> MultilineTextFieldTableViewCell
    func getNoticeTextCell(with value: String, in tableView: UITableView) -> UITableViewCell
    
    func getCategoryCell(titled title: String, in tableView: UITableView) -> UITableViewCell
    
    func getDeleteButtonCell(in tableView: UITableView) -> UITableViewCell
    func getAddCategoryButtonCell(in tableView: UITableView) -> UITableViewCell
}

class ItemPresenter: NSObject {
    
    let reuseCategoryHeaderIdentifier: String = "reuseCategoryHeaderIdentifier"
    
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reusePatchSelectionIdentifier: String = "reusePatchSelectionIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    let reuseNoticeLabelIdentifier: String = "reuseNoticeLabelIdentifier"
    let reuseCategoryIdentifier: String = "reuseCategoryIdentifier"
    let reuseAddCategoryIdentifier: String = "reuseAddCategoryIdentifier"
    let reuseNoticeTextfieldIdentifier: String = "reuseNoticeTextfieldIdentifier"
    
    var viewInput: ItemViewInputProtocol?
    var interator: ItemInteractorInputProtocol?
}

extension ItemPresenter: ItemPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?) {
        
        self.viewInput?.updateViewModel(identifier: identifier)
        self.viewInput?.presentUserFeedback(message: R.string.localizable.itemSaveSuccess())
        
        self.viewInput?.toggleDetail()
    }
    
    func saveFailure(failure: ItemFailure) {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.itemSaveFailure())
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.itemDeleteSuccess())
        self.interator?.showItems()
        
        self.viewInput?.toggleDetail()
    }
    
    func deleteFailure(failure: ItemFailure) {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.itemDeleteFailure())
    }
    
    /// MARK
    
    func getNameCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNameLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNameLabelIdentifier)
    }
    
    func getPatchCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reusePatchSelectionIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reusePatchSelectionIdentifier)
    }
    
    func getNoticeTextCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNoticeLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNoticeLabelIdentifier)
    }
    
    func getCategoryCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseCategoryIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: self.reuseCategoryIdentifier)
    }
    
    func getAddCategoryCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseAddCategoryIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: self.reuseAddCategoryIdentifier)
    }
    
    func getButtonCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseButtonIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: self.reuseButtonIdentifier)
    }
    
    /// MARK
    
    func getSectionHeader(titled title: String, in tableView: UITableView) -> UIView? {
        
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseCategoryHeaderIdentifier)
        sectionHeaderView?.textLabel?.text = title
        return sectionHeaderView
    }
    
    func getNameValueCell(for name: String, and value: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getNameCell(for: tableView)
        
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
    
    func getPatchCell(titled title: String, detail: String, accessoryType: UITableViewCell.AccessoryType, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getPatchCell(for: tableView)
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        cell.accessoryType = accessoryType
        
        return cell
    }
    
    func getNoticeTextFieldCell(with value: String, in tableView: UITableView)  -> MultilineTextFieldTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNoticeTextfieldIdentifier) as! MultilineTextFieldTableViewCell
        cell.configure(textFieldValue: value,
                       placeHolder: R.string.localizable.itemNoticePlaceholder())
        cell.textView.isScrollEnabled = false
        
        return cell
    }
    
    func getNoticeTextCell(with value: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getNoticeTextCell(for: tableView)
        
        cell.textLabel?.text = R.string.localizable.itemNoticeTitle()
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = value
        cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        
        return cell
    }
    
    func getCategoryCell(titled title: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getCategoryCell(for: tableView)
        cell.textLabel?.text = title
        cell.accessoryType = .none
        return cell
    }
    
    func getDeleteButtonCell(in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getButtonCell(for: tableView)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = R.string.localizable.buttonDelete()
        cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
        return cell
    }
    
    func getAddCategoryButtonCell(in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getAddCategoryCell(for: tableView)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = R.string.localizable.itemButtonAddCategory()
        cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
        return cell
    }
}

extension ItemPresenter: UITextFieldDelegate {
    
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
