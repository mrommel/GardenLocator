//
//  CategoryExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 01.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

extension Category {
    
    func path() -> String? {
        
        if self.parent == nil {
            return self.name
        }
        
        if let parentString = self.parent?.path(), let name = self.name {
            return "\(parentString) > \(name)"
        }
        
        return "---"
    }
}
