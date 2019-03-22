//
//  PatchDao.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

protocol PatchDaoProtocol {
    
    func fetch() -> [Patch]?
    func get(by objectId: NSManagedObjectID) -> Patch?
    func get(by name: String) -> Patch?
    func create(named name: String) -> Bool
    func save(patch: Patch?) -> Bool
    func delete(patch: Patch?) -> Bool
    func deleteAll() -> Bool
}

class PatchDao: BaseDao {
}

extension PatchDao: PatchDaoProtocol {
    
    func fetch() -> [Patch]? {
        
        guard let context = self.context else {
            fatalError("Can't get context for fetching patches")
        }
        
        do {
            let fetchRequest: NSFetchRequest<Patch> = Patch.fetchRequest()
            //fetch.predicate = NSPredicate(format: "genreValue == %@", genre)
            //fetchRequest.sortDescriptors
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func get(by objectId: NSManagedObjectID) -> Patch? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating patch")
        }
        
        do {
            return try context.existingObject(with: objectId) as? Patch
        } catch {
            return nil
        }
    }
    
    func get(by name: String) -> Patch? {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating patch")
        }
        
        do {
            let fetchRequest: NSFetchRequest<Patch> = Patch.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)

            let patches = try context.fetch(fetchRequest)
            
            return patches.first
        } catch {
            return nil
        }
    }
    
    func create(named name: String) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for creating patch")
        }
        
        let newPatch = Patch(context: context)
        newPatch.name = name
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func save(patch: Patch?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let _ = patch else {
            fatalError("Can't save nil patch")
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func delete(patch: Patch?) -> Bool {
        
        guard let context = self.context else {
            fatalError("Can't get context for deletion")
        }
        
        guard let patch = patch else {
            fatalError("Can't delete nil patch")
        }
        
        context.delete(patch)
            
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func deleteAll() -> Bool {
        
        if let entityName = Patch.entity().name {
            return self.deleteAllData(of: entityName)
        }
        
        return false
    }
}
