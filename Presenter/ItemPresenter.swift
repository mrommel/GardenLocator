//
//  ItemPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData

// View Controller must implement this
protocol ItemViewInputProtocol {
    
    func presentUserFeedback(message: String)
    func updateViewModel(identifier: NSManagedObjectID?)
}

enum ItemFailure {
    
    case generic
    case notFound
}

protocol ItemPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: ItemFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: ItemFailure)
}

class ItemPresenter {
    
    var viewInput: ItemViewInputProtocol?
    var interator: ItemInteractorInputProtocol?
    
    init() {
        
    }
}

extension ItemPresenter: ItemPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?) {
        
        self.viewInput?.updateViewModel(identifier: identifier)
        self.viewInput?.presentUserFeedback(message: "Successfully saved")
        self.interator?.showItems()
    }
    
    func saveFailure(failure: ItemFailure) {
        
        self.viewInput?.presentUserFeedback(message: "Could not save")
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Successfully deleted")
        self.interator?.showItems()
    }
    
    func deleteFailure(failure: ItemFailure) {
        
        self.viewInput?.presentUserFeedback(message: "Could not delete")
    }
}
