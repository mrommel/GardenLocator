//
//  CategoryViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class CategoryViewModel {
    
    var identifier: NSManagedObjectID?
    var name: String
    var childCategoryNames: [String]
    var itemNames: [String]
    
    init(name: String, childCategoryNames: [String], itemNames: [String]) {
        self.name = name
        self.childCategoryNames = childCategoryNames
        self.itemNames = itemNames
    }
    
    init(category: Category) {
        self.identifier = category.objectID
        self.name = category.name ?? "---"
        
        self.childCategoryNames = []
        if let categories = category.children?.allObjects as? [Category] {
            for category in categories {
                self.childCategoryNames.append(category.name ?? "--")
            }
        }
        
        self.itemNames = []
        if let items = category.items?.allObjects as? [Item] {
            for item in items {
                self.itemNames.append(item.name ?? "--")
            }
        }
    }
    
    func childCategoryName(at index: Int) -> String {
        
        return self.childCategoryNames[index]
    }
    
    func itemName(at index: Int) -> String {
        
        return self.itemNames[index]
    }
    
    func removeItem(named itemName: String) {
        
        self.itemNames.removeFirst(object: itemName)
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty /* && self.patchName != ""*/
    }
}
