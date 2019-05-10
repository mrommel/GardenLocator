//
//  ItemsViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class ItemsViewModel {
    
    let items: [ItemViewModel]
    
    init(items: [ItemViewModel]) {
        self.items = items
    }
    
    func itemName(at index: Int) -> String {
        
        return self.items[index].name
    }
}
