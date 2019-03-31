//
//  PatchViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreData
import GoogleMaps

class PatchViewModel {

    var identifier: NSManagedObjectID?
    var name: String
    var latitude: Double
    var longitude: Double
    var shape: PatchShape
    var color: PatchColor
    var itemNames: [String]

    init(name: String, latitude: Double, longitude: Double, shape: PatchShape, color: PatchColor) {
        self.identifier = nil
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.shape = shape
        self.color = color
        self.itemNames = []
    }

    init(patch: Patch) {
        self.identifier = patch.objectID
        self.name = patch.name ?? "---"
        self.latitude = patch.latitude
        self.longitude = patch.longitude
        self.shape = patch.shape() ?? .circle
        self.color = patch.color() ?? .maroon
        self.itemNames = []

        if let items = patch.items?.allObjects as? [Item] {
            for item in items {
                self.itemNames.append(item.name ?? "--")
            }
        }
    }

    func isValid() -> Bool {
        return !self.name.isEmpty
    }

    func itemName(at index: Int) -> String {

        return self.itemNames[index]
    }

    func polygon() -> GMSOverlay? {

        switch shape {

        case .circle:
            let radius = 1.0 // in meters
            
            let circleCenter = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            let circle = GMSCircle(position: circleCenter, radius: radius)
            circle.fillColor = self.color.color.withAlphaComponent(0.5)
            circle.strokeColor = self.color.color
            circle.strokeWidth = 2
            
            return circle
        case .square:
            return createRectangle(cx: 1.0, cy: 1.0)
        case .rectPortrait:
            return createRectangle(cx: 1.0, cy: 1.5)
        case .rectLandscape:
            return createRectangle(cx: 1.5, cy: 1.0)
        }
    }
    
    func createRectangle(cx: Double, cy: Double) -> GMSPolygon {
        
        let delta = 1.0 // in meters
        
        let dx = delta * 0.0000089 * cx
        let dy = ((delta * 0.0000089) / cos(self.latitude * 0.018)) * cy
        
        // Create a rectangular path
        let rect = GMSMutablePath()
        rect.add(CLLocationCoordinate2D(latitude: self.latitude + dx, longitude: self.longitude - dy))
        rect.add(CLLocationCoordinate2D(latitude: self.latitude + dx, longitude: self.longitude + dy))
        rect.add(CLLocationCoordinate2D(latitude: self.latitude - dx, longitude: self.longitude + dy))
        rect.add(CLLocationCoordinate2D(latitude: self.latitude - dx, longitude: self.longitude - dy))
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = self.color.color.withAlphaComponent(0.5)
        polygon.strokeColor = self.color.color
        polygon.strokeWidth = 2
        
        return polygon
    }
}

extension CLLocationCoordinate2D {
    
    func shiftedByMetersIn(latitudeDir: Double, longitudeDir: Double) -> CLLocationCoordinate2D {
    
        let delta = 1.0 // in meters
        
        let dx = delta * 0.0000089 * latitudeDir
        let dy = ((delta * 0.0000089) / cos(self.latitude * 0.018)) * longitudeDir
        
        return CLLocationCoordinate2D(latitude: self.latitude + dx, longitude: self.longitude + dy)
    }
}
