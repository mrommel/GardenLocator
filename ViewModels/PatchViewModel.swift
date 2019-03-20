//
//  PatchViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class PatchViewModel {
    
    let identifier: NSManagedObjectID?
    var name: String
    var itemNames: [String]
    
    init(name: String) {
        self.identifier = nil
        self.name = name
        self.itemNames = []
    }
    
    init(patch: Patch) {
        self.identifier = patch.objectID
        self.name = patch.name ?? "---"
        self.itemNames = []
        
        if let items = patch.items?.allObjects as? [Item] {
            for item in items {
                self.itemNames.append(item.name ?? "--")
            }
        }
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty
    }
    
    func itemName(at index: Int) -> String {
        
        return self.itemNames[index]
    }
}
