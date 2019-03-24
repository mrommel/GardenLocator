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
    var itemNames: [String]

    init(name: String, latitude: Double, longitude: Double, shape: PatchShape) {
        self.identifier = nil
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.shape = shape
        self.itemNames = []
    }

    init(patch: Patch) {
        self.identifier = patch.objectID
        self.name = patch.name ?? "---"
        self.latitude = patch.latitude
        self.longitude = patch.longitude
        self.shape = patch.shape() ?? .circle
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
            circle.fillColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.5)
            circle.strokeColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0)
            circle.strokeWidth = 2
            
            return circle
        case .square:
            let delta = 1.0 // in meters
            
            let dx = delta * 0.0000089
            let dy = (delta * 0.0000089) / cos(self.latitude * 0.018)

            // Create a rectangular path
            let rect = GMSMutablePath()
            rect.add(CLLocationCoordinate2D(latitude: self.latitude + dx, longitude: self.longitude - dy))
            rect.add(CLLocationCoordinate2D(latitude: self.latitude + dx, longitude: self.longitude + dy))
            rect.add(CLLocationCoordinate2D(latitude: self.latitude - dx, longitude: self.longitude + dy))
            rect.add(CLLocationCoordinate2D(latitude: self.latitude - dx, longitude: self.longitude - dy))

            // Create the polygon, and assign it to the map.
            let polygon = GMSPolygon(path: rect)
            polygon.fillColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.5)
            polygon.strokeColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1.0)
            polygon.strokeWidth = 2

            return polygon
            /*case .rectPortrait:
                 <#code#>
                 case .rectLandscape:
                 <#code#> */
        }

        //return nil
    }
}
