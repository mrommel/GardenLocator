//
//  CategoryDao.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData

protocol CategoryDaoProtocol {
    
    func fetch() -> [Category]?
    func get(by objectId: NSManagedObjectID) -> Category?
    func get(by name: String) -> Category?
    func create(named name: String, parent: Category?) -> Bool
    func save(category: Category?, parent: Category?) -> Bool
    func delete(category: Category?) -> Bool
    func deleteAll() -> Bool
}

class CategoryDao: BaseDao {
}

extension CategoryDao: CategoryDaoProtocol {
    
    func fetch() -> [Category]? {
        guard let context = self.context else {
            fatalError("Can't get context for fetching categories")
        }
        
        do {
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "parent == nil")
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func get(by objectId: NSManagedObjectID) -> Category? {
        
        guard let context = self.context else {
            fatalError("Can't get context for getting category")
        }
        
        do {
            return try context.existingObject(with: objectId) as? Category
        } catch {
            return nil
        }
    }
    
    func get(by name: String) -> Category? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating category")
        }
        
        do {
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            let patches = try context.fetch(fetchRequest)
            
            return patches.first
        } catch {
            return nil
        }
    }
    
    func create(named name: String, parent: Category?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating category")
        }
        
        let newCategory = Category(context: context)
        newCategory.name = name
        newCategory.parent = parent
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func save(category: Category?, parent: Category?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for category deletion")
        }
        
        guard let _ = category else {
            fatalError("Can't save nil category")
        }
        
        if parent != nil {
            category?.parent = parent
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func delete(category: Category?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for category deletion")
        }
        
        guard let category = category else {
            fatalError("Can't delete nil category")
        }
        
        context.delete(category)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func deleteAll() -> Bool {
        
        if let entityName = Category.entity().name {
            return self.deleteAllData(of: entityName)
        }
        
        return false
    }
    
}
