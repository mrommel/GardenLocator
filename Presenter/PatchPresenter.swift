//
//  PatchPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData
import Rswift

enum PatchFailure {
    
    case generic
    case notFound
}

// View Controller must implement this
protocol PatchViewInputProtocol {
    
    func updateViewModel(identifier: NSManagedObjectID?)
    func presentUserFeedback(message: String)
}

protocol PatchPresenterInputProtocol {
    
    var reuseButtonIdentifier: String { get }
    var reuseNameLabelIdentifier: String { get }
    var reuseNameTextfieldIdentifier: String { get }
    var reuseItemLabelIdentifier: String { get }
    var reuseShapeSelectionIdentifier: String { get }
    var reuseColorSelectionIdentifier: String { get }
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: PatchFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: PatchFailure)
    
    func getNameValueCell(for name: String, and value: String, in tableView: UITableView) -> UITableViewCell
    func getTextFieldCell(titled: String, value: String, placeholder: String, tag: Int, in tableView: UITableView) -> TextInputTableViewCell
    func getItemCell(for itemName: String, in tableView: UITableView) -> UITableViewCell
    func getShapeCell(for value: String, in tableView: UITableView) -> UITableViewCell
    func getColorCell(for value: String, in tableView: UITableView) -> UITableViewCell
    func getButtonCell(in tableView: UITableView) -> UITableViewCell
}

class PatchPresenter: NSObject {
    
    let reuseButtonIdentifier: String = "reuseButtonIdentifier"
    let reuseNameLabelIdentifier: String = "reuseNameLabelIdentifier"
    let reuseNameTextfieldIdentifier: String = "reuseNameTextfieldIdentifier"
    let reuseItemLabelIdentifier: String = "reuseItemLabelIdentifier"
    let reuseShapeSelectionIdentifier: String = "reuseShapeSelectionIdentifier"
    let reuseColorSelectionIdentifier: String = "reuseColorSelectionIdentifier"
    
    var viewInput: PatchViewInputProtocol?
    var interator: PatchInteractorInputProtocol?
}

extension PatchPresenter: PatchPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?) {
        
        self.viewInput?.updateViewModel(identifier: identifier)
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchSaveSuccess())
    }
    
    func saveFailure(failure: PatchFailure) {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchSaveFailure())
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchDeleteSuccess())
        self.interator?.showPatches()
    }
    
    func deleteFailure(failure: PatchFailure) {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchDeleteFailure())
    }
    
    /// MARK:
    
    private func getNameValueCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseNameLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseNameLabelIdentifier)
    }
    
    private func getItemCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseItemLabelIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseItemLabelIdentifier)
    }
    
    private func getShapeCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseShapeSelectionIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseShapeSelectionIdentifier)
    }
    
    private func getColorCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseColorSelectionIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: self.reuseColorSelectionIdentifier)
    }
    
    private func getButtonCell(for tableView: UITableView) -> UITableViewCell {
        
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
    
    func getItemCell(for itemName: String, in tableView: UITableView) -> UITableViewCell {
    
        let cell = getItemCell(for: tableView)
        cell.imageView?.image = R.image.pin()
        cell.textLabel?.text = itemName
        cell.textLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func getShapeCell(for value: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getShapeCell(for: tableView)
        
        cell.textLabel?.text = R.string.localizable.itemShapeTitle()
        cell.detailTextLabel?.text = value
        cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        cell.accessoryType = .none
        
        return cell
    }
    
    func getColorCell(for value: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getColorCell(for: tableView)
        
        cell.textLabel?.text = R.string.localizable.itemColorTitle()
        cell.detailTextLabel?.text = value
        cell.detailTextLabel?.textColor = App.Color.tableViewCellTextEnabledColor
        cell.accessoryType = .none
        
        return cell
    }
    
    func getButtonCell(in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getButtonCell(for: tableView)
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = R.string.localizable.buttonDelete()
        cell.textLabel?.textColor = App.Color.tableViewCellDeleteButtonColor
        
        return cell
    }
}

extension PatchPresenter: UITextFieldDelegate {
    
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
