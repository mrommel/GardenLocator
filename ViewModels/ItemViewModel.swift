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
    
    init(latitude: Double, longitude: Double, name: String, patchName: String, notice: String) {
        self.identifier = nil
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.patchName = patchName
        self.notice = notice
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
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty /* && self.patchName != ""*/
    }
}
