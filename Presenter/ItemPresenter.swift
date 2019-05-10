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
    
    func getSectionHeader(titled title: String, in tableView: UITableView) -> UIView?
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: ItemFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: ItemFailure)
}

class ItemPresenter {
    
    let reuseCategoryHeaderIdentifier: String = "reuseCategoryHeaderIdentifier"
    
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
    
    /// MARK
    
    func getSectionHeader(titled title: String, in tableView: UITableView) -> UIView? {
        
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseCategoryHeaderIdentifier)
        sectionHeaderView?.textLabel?.text = title
        return sectionHeaderView
    }
}
