//
//  MapViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 16.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import GoogleMaps
import Rswift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // Misc
    var presenter: MapPresenterInputProtocol?
    var interactor: MapInteractorInputProtocol?
    var viewModel: MapViewModel?
    
    // marker
    var markers: [GMSOverlay] = []
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.mapsTitle()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.fetch()
    }
    
    func populateMarker() {
        
        for marker in self.markers {
            marker.map = nil
        }
        
        self.markers.removeAll()
        
        if let items = self.viewModel?.items {
            for item in items {
                let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                let itemMarker = GMSMarker(position: coordinate)
                itemMarker.title = item.name
                itemMarker.map = self.mapView
                self.markers.append(itemMarker)
            }
        }
        
        if let patches = self.viewModel?.patches {
            for patch in patches {
                if let patchMarker = patch.polygon() {
                    patchMarker.map = self.mapView
                    self.markers.append(patchMarker)
                }
                
                let coordinate = CLLocationCoordinate2D(latitude: patch.latitude, longitude: patch.longitude)
                let patchTextMarker = GMSMarker(position: coordinate)
                patchTextMarker.icon = self.imageWith(name: patch.name)
                patchTextMarker.map = self.mapView
                self.markers.append(patchTextMarker)
            }
        }
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        nameLabel.textColor = .white
        nameLabel.font = App.Font.alertTextFont
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
}

extension MapViewController: MapViewInputProtocol {
    
    func present(viewModel: MapViewModel?) {
        
        self.viewModel = viewModel
        self.populateMarker()
    }
    
    func presentNoItemsHint() {
        
        self.viewModel = nil
        self.populateMarker()
    }
}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }

        self.locationManager.startUpdatingLocation()
        
        self.mapView.mapType = .satellite
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
        
        self.locationManager.stopUpdatingLocation()
    }
}
