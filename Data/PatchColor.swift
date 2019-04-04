//
//  PatchColor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

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
            return R.string.localizable.colorMaroon()
        case .brown:
            return R.string.localizable.colorBrown()
        case .olive:
            return R.string.localizable.colorOlive()
        case .teal:
            return R.string.localizable.colorTeal()
        case .navy:
            return R.string.localizable.colorNavy()
            
        case .red:
            return R.string.localizable.colorRed()
        case .orange:
            return R.string.localizable.colorOrange()
        case .yellow:
            return R.string.localizable.colorYellow()
        case .lime:
            return R.string.localizable.colorLime()
        case .green:
            return R.string.localizable.colorGreen()
        case .cyan:
            return R.string.localizable.colorCyan()
        case .blue:
            return R.string.localizable.colorBlue()
        case .purple:
            return R.string.localizable.colorPurple()
        case .magenta:
            return R.string.localizable.colorMagenta()
            
        case .pink:
            return R.string.localizable.colorPink()
        case .apricot:
            return R.string.localizable.colorApricot()
        case .beige:
            return R.string.localizable.colorBeige()
        case .mint:
            return R.string.localizable.colorMint()
        case .lavendar:
            return R.string.localizable.colorLavendar()
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
