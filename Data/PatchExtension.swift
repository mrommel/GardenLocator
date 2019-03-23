//
//  PatchExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 23.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import GoogleMaps

enum PatchShape: Int64, CaseIterable{
    
    case circle = 0
    case square = 1
    //case rectPortrait = 2
    //case rectLandscape = 3
    
    var title: String {
        
        switch self {
            
        case .circle:
            return "Circle" // TODO translate
        case .square:
            return "Square" // TODO translate
        }
    }
}

extension Patch {
 
    func shape() -> PatchShape? {
        
        return PatchShape.init(rawValue: self.type)
    }
}
