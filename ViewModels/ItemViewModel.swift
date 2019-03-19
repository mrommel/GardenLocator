//
//  ItemViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData

class ItemViewModel {
    
    let identifier: NSManagedObjectID?
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double, name: String) {
        self.identifier = nil
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
    
    init(item: Item) {
        self.identifier = item.objectID
        self.latitude = item.latitude
        self.longitude = item.longitude
        self.name = item.name ?? "---"
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty
    }
}
