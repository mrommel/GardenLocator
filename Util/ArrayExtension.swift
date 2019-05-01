//
//  ArrayExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 01.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeFirst(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
