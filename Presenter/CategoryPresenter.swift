//
//  CategoryPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData

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
    
    func reloaded(with categoryViewModel: CategoryViewModel?)
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: CategoryFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: CategoryFailure)
}

class CategoryPresenter {
    
    var viewInput: CategoryViewInputProtocol?
    var interator: CategoryInteractorInputProtocol?
}

extension CategoryPresenter: CategoryPresenterInputProtocol {
    
    func reloaded(with categoryViewModel: CategoryViewModel?) {

        self.viewInput?.reloadDetail(with: categoryViewModel)
    }
    
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
