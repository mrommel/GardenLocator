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
    
    init(name: String) {
        self.name = name
    }
    
    init(category: Category) {
        self.identifier = category.objectID
        self.name = category.name ?? "---"
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty /* && self.patchName != ""*/
    }
}
