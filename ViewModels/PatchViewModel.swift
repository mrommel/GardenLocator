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
    
    init(name: String) {
        self.identifier = nil
        self.name = name
    }
    
    init(patch: Patch) {
        self.identifier = patch.objectID
        self.name = patch.name ?? "---"
    }
    
    func isValid() -> Bool {
        return !self.name.isEmpty
    }
}
