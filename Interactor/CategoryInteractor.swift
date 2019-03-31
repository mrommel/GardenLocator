//
//  CategoryInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData

protocol CategoryInteractorInputProtocol {
    
    var router: Router? { get set }
    var categoryDao: CategoryDaoProtocol? { get set }
    var presenterInput: CategoryPresenterInputProtocol? { get set }
    
    func create(category: CategoryViewModel?)
    func save(category: CategoryViewModel?)
    func delete(category: CategoryViewModel?)
    
    func showCategories()
}

class CategoryInteractor {
    
    var router: Router?
    var categoryDao: CategoryDaoProtocol?
    var presenterInput: CategoryPresenterInputProtocol?
}

extension CategoryInteractor: CategoryInteractorInputProtocol {
    
    func create(category: CategoryViewModel?) {
        
        if let name = category?.name {
            
            if let saved = self.categoryDao?.create(named: name) {
                if saved {
                    
                    // put identifier into model
                    if let storedItem = self.categoryDao?.get(by: name) {
                        self.presenterInput?.saveSuccess(identifier: storedItem.objectID)
                    }
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure(failure: .generic)
    }
    
    func save(category: CategoryViewModel?) {
        
        if let identifier = category?.identifier {

            let categoryObject = self.categoryDao?.get(by: identifier)
            
            categoryObject?.name = category?.name
            
            if let saved = self.categoryDao?.save(category: categoryObject) {
                if saved {
                    self.presenterInput?.saveSuccess(identifier: identifier)
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure(failure: .generic)
    }
    
    func delete(category: CategoryViewModel?) {
        
        if let identifier = category?.identifier {
            let categoryObject = self.categoryDao?.get(by: identifier)
            
            if let deleted = self.categoryDao?.delete(category: categoryObject) {
                if deleted {
                    self.presenterInput?.deleteSuccess()
                }
            }
        }
        
        self.presenterInput?.deleteFailure(failure: .generic)
    }
    
    func showCategories() {
        // we are in the details > go back
        self.router?.popViewController()
    }
}
