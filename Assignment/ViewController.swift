//
//  ViewController.swift
//  Assignment
//
//  Created by Ben Shek on 4/1/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    let map = MKMapView()
    let hkCoord = CLLocation(latitude: 22.3193, longitude: 114.1694)
    let mapBoundary = MKCoordinateRegion()
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.centerToLocation(hkCoord)
        
        // Set the region for camera
        let region = MKCoordinateRegion(center: hkCoord.coordinate,
                                        latitudinalMeters: 55000,
                                        longitudinalMeters: 70000)
        
        // Set camera zoom out range
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
        
        // Set camera constrains
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region),
                                  animated: true)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    
}

// Center current view to desired region
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000) {
        let coordRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordRegion, animated: true)
    }
}

