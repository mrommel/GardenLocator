//
//  GMSPolygonExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 23.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import GoogleMaps

extension GMSPolygon {
    
    func center(at center: CLLocationCoordinate2D) {
        
        let delta = 1.0 // in meters
        
        let dx = delta * 0.0000089
        let dy = (delta * 0.0000089) / cos(center.latitude * 0.018)
        
        // Create a rectangular path
        let rect = GMSMutablePath()
        rect.add(CLLocationCoordinate2D(latitude: center.latitude + dx, longitude: center.longitude - dy))
        rect.add(CLLocationCoordinate2D(latitude: center.latitude + dx, longitude: center.longitude + dy))
        rect.add(CLLocationCoordinate2D(latitude: center.latitude - dx, longitude: center.longitude + dy))
        rect.add(CLLocationCoordinate2D(latitude: center.latitude - dx, longitude: center.longitude - dy))
        
        self.path = rect
    }
}
