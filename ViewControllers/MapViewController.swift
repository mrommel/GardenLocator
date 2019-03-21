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
    var markers: [GMSMarker] = []
    
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
