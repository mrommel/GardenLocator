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
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: CategoryPresenterInputProtocol? { get set }
    
    func refreshData(for identifier: NSManagedObjectID?)
    
    func create(category: CategoryViewModel?, parent: CategoryViewModel?)
    func save(category: CategoryViewModel?, parent: CategoryViewModel?)
    func delete(category: CategoryViewModel?)
    
    func showCategories()
    func showCategory(named name: String)
    func showCategoryWith(parent: CategoryViewModel?)
    
    func showItem(named name: String)
}

class CategoryInteractor {
    
    var router: Router?
    var categoryDao: CategoryDaoProtocol?
    var itemDao: ItemDaoProtocol?
    var presenterInput: CategoryPresenterInputProtocol?
}

extension CategoryInteractor: CategoryInteractorInputProtocol {
    
    func refreshData(for identifier: NSManagedObjectID?) {

        if let identifier = identifier, let category = self.categoryDao?.get(by: identifier) {
            let categoryViewModel = CategoryViewModel(category: category)
            presenterInput?.reloaded(with: categoryViewModel)
        }
    }
    
    func create(category: CategoryViewModel?, parent: CategoryViewModel?) {
        
        if let name = category?.name {
            
            var parentObject: Category? = nil
            if let parentIdentifier = parent?.identifier {
                parentObject = self.categoryDao?.get(by: parentIdentifier)
            }
            
            if let saved = self.categoryDao?.create(named: name, parent: parentObject) {
                if saved {
                    // put identifier into model
                    if let storedCategory = self.categoryDao?.get(by: name) {
                        let categoryViewModel = CategoryViewModel(category: storedCategory)
                        self.presenterInput?.reloaded(with: categoryViewModel)
    
                        self.presenterInput?.saveSuccess(identifier: storedCategory.objectID)
                    }
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure(failure: .generic)
    }
    
    func save(category: CategoryViewModel?, parent: CategoryViewModel?) {
        
        if let identifier = category?.identifier, let parentIdentifier = parent?.identifier {

            let parentObject = self.categoryDao?.get(by: parentIdentifier)
            guard let categoryObject = self.categoryDao?.get(by: identifier) else {
                fatalError()
            }
            
            categoryObject.name = category?.name
            
            if let saved = self.categoryDao?.save(category: categoryObject, parent: parentObject) {
                if saved {
                    let categoryViewModel = CategoryViewModel(category: categoryObject)
                    self.presenterInput?.reloaded(with: categoryViewModel)
                    
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
    
    func showCategory(named name: String) {
        
        if let category = self.categoryDao?.get(by: name) {
            let categoryViewModel = CategoryViewModel(category: category)
            self.router?.show(category: categoryViewModel, parent: nil)
        }
    }
    
    func showCategoryWith(parent: CategoryViewModel?) {
        
        self.router?.show(category: nil, parent: parent)
    }
    
    func showItem(named name: String) {
        
        if let item = self.itemDao?.get(by: name) {
            let itemViewModel = ItemViewModel(item: item)
            self.router?.show(item: itemViewModel)
        }
    }
}
