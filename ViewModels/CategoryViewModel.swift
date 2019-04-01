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
    
    init(name: String, childCategoryNames: [String]) {
        self.name = name
        self.childCategoryNames = childCategoryNames
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
    }
    
    func childCategoryName(at index: Int) -> String {
        
        return self.childCategoryNames[index]
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty /* && self.patchName != ""*/
    }
}
