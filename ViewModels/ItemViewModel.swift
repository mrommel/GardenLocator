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
    
    init(latitude: Double, longitude: Double, name: String, patchName: String) {
        self.identifier = nil
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.patchName = patchName
    }
    
    init(item: Item) {
        self.identifier = item.objectID
        self.latitude = item.latitude
        self.longitude = item.longitude
        self.name = item.name ?? "---"
        
        if let itemPatch = item.patch {
            self.patchName = itemPatch.name ?? "---"
        } else {
            self.patchName = "---"
        }
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty && self.patchName != ""
    }
}
