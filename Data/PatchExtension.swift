//
//  PatchExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 23.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import GoogleMaps
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

enum PatchColor: Int64, CaseIterable {
    
    case maroon
    case brown
    case olive
    case teal
    case navy
    
    case red
    case orange
    case yellow
    case lime
    case green
    case cyan
    case blue
    case purple
    case magenta
    
    case pink
    case apricot
    case beige
    case mint
    case lavendar
    
    var title: String {
        switch self {
        case .maroon:
            return "Maroon"
        case .brown:
            return "Brown"
        case .olive:
            return "Olive"
        case .teal:
            return "Teal"
        case .navy:
            return "Navy"
            
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        case .yellow:
            return "Yellow"
        case .lime:
            return "Lime"
        case .green:
            return "Green"
        case .cyan:
            return "Cyan"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .magenta:
            return "Magenta"
            
        case .pink:
            return "Pink"
        case .apricot:
            return "Apricot"
        case .beige:
            return "Beige"
        case .mint:
            return "Mint"
        case .lavendar:
            return "Lavendar"
        }
    }
    
    var color: UIColor {
        switch self {
        case .maroon:
            return UIColor(hex: "#800000")
        case .brown:
            return UIColor(hex: "#9A6324")
        case .olive:
            return UIColor(hex: "#808000")
        case .teal:
            return UIColor(hex: "#469990")
        case .navy:
            return UIColor(hex: "#000075")
            
        case .red:
            return UIColor(hex: "#e6194B")
        case .orange:
            return UIColor(hex: "#f58231")
        case .yellow:
            return UIColor(hex: "#ffe119")
        case .lime:
            return UIColor(hex: "#bfef45")
        case .green:
            return UIColor(hex: "#3cb44b")
        case .cyan:
            return UIColor(hex: "#42d4f4")
        case .blue:
            return UIColor(hex: "#4363d8")
        case .purple:
            return UIColor(hex: "#911eb4")
        case .magenta:
            return UIColor(hex: "#f032e6")
            
        case .pink:
            return UIColor(hex: "#fabebe")
        case .apricot:
            return UIColor(hex: "#ffd8b1")
        case .beige:
            return UIColor(hex: "#fffac8")
        case .mint:
            return UIColor(hex: "#aaffc3")
        case .lavendar:
            return UIColor(hex: "#e6beff")
        }
    }
}

extension Patch {
 
    func shape() -> PatchShape? {
        
        return PatchShape.init(rawValue: self.type)
    }
    
    func color() -> PatchColor? {
        
        return PatchColor.init(rawValue: self.colorValue)
    }
}
