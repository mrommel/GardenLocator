//
//  ItemViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class ItemViewModel {
    
    var identifier: NSManagedObjectID?
    var name: String
    var latitude: Double
    var longitude: Double
    var patchName: String
    var notice: String
    var categoryNames: [String]
    
    init(latitude: Double, longitude: Double, name: String, patchName: String, notice: String, categoryNames: [String]) {
        self.identifier = nil
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.patchName = patchName
        self.notice = notice
        self.categoryNames = categoryNames
    }
    
    init(item: Item) {
        self.identifier = item.objectID
        self.latitude = item.latitude
        self.longitude = item.longitude
        self.name = item.name ?? "---"
        self.notice = item.notice ?? "---"
        
        if let itemPatch = item.patch {
            self.patchName = itemPatch.name ?? "---"
        } else {
            self.patchName = "---"
        }
        
        self.categoryNames = []
        if let categories = item.categories?.allObjects as? [Category] {
            for category in categories {
                self.categoryNames.append(category.name ?? "--")
            }
        }
    }
    
    func addCategory(named categoryName: String) {
        
        self.categoryNames.append(categoryName)
    }
    
    func removeCategory(named categoryName: String) {
        
        self.categoryNames.removeFirst(object: categoryName)
    }
    
    func categoryName(at index: Int) -> String {
        
        return self.categoryNames[index]
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty /* && self.patchName != ""*/
    }
}
