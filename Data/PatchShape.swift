//
//  PatchShape.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import Rswift

enum PatchShape: Int64, CaseIterable {
    
    case circle = 0
    case square = 1
    case rectPortrait = 2
    case rectLandscape = 3
    
    var title: String {
        
        switch self {
            
        case .circle:
            return R.string.localizable.patchShapeCircle()
        case .square:
            return R.string.localizable.patchShapeSquare()
        case .rectPortrait:
            return R.string.localizable.patchShapeRectPortrait()
        case .rectLandscape:
            return R.string.localizable.patchShapeRectLandscape()
        }
    }
}
