//
//  PatchesViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class PatchesViewModel {
    
    let patches: [PatchViewModel]
    
    init(patches: [PatchViewModel]) {
        
        self.patches = patches
    }
    
    func patchName(at index: Int) -> String {
        
        return self.patches[index].name
    }
    
    func itemNames(at index: Int) -> [String] {
        
        return self.patches[index].itemNames
    }
}
