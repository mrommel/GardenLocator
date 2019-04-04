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

extension Patch {
 
    func shape() -> PatchShape? {
        return PatchShape.init(rawValue: self.type)
    }
    
    func color() -> PatchColor? {
        return PatchColor.init(rawValue: self.colorValue)
    }
    
    func coord() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
