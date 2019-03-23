//
//  MapViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 20.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class MapViewModel {
    
    let items: [ItemViewModel]
    let patches: [PatchViewModel]
    
    init(items: [ItemViewModel], patches: [PatchViewModel]) {
        self.items = items
        self.patches = patches
    }
}
