//
//  ItemDao.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

protocol ItemDaoProtocol {
    
    func fetch() -> [Item]?
    func get(by objectId: NSManagedObjectID) -> Item?
    func get(by name: String) -> Item?
    func create(named name: String, latitude: Double, longitude: Double, patch: Patch) -> Bool
    func save(item: Item?) -> Bool
    func delete(item: Item?) -> Bool
    func deleteAll() -> Bool
}

class ItemDao: BaseDao {
}

extension ItemDao: ItemDaoProtocol {
    
    func fetch() -> [Item]? {
        
        guard let context = self.context else {
            fatalError("Can't get context for fetching patches")
        }
        
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            //fetch.predicate = NSPredicate(format: "genreValue == %@", genre)
            //fetchRequest.sortDescriptors
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func get(by objectId: NSManagedObjectID) -> Item? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating patch")
        }
        
        do {
            return try context.existingObject(with: objectId) as? Item
        } catch {
            return nil
        }
    }
    
    func get(by name: String) -> Item? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating patch")
        }
        
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            let items = try context.fetch(fetchRequest)
            
            return items.first
        } catch {
            return nil
        }
    }
    
    func create(named name: String, latitude: Double, longitude: Double, patch: Patch) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating patch")
        }
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.latitude = latitude
        newItem.longitude = longitude
        newItem.patch = patch
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func save(item: Item?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let _ = item else {
            fatalError("Can't save nil item")
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func delete(item: Item?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let item = item else {
            fatalError("Can't delete nil item")
        }
        
        context.delete(item)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func deleteAll() -> Bool {
        
        if let entityName = Item.entity().name {
            return self.deleteAllData(of: entityName)
        }
        
        return false
    }
}
