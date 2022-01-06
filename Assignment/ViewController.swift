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
        
        mapView.delegate = self
        mapView.centerToLocation(hkCoord)
        
        // Set the region for camera
        let region = MKCoordinateRegion(center: hkCoord.coordinate,
                                        latitudinalMeters: 55000,
                                        longitudinalMeters: 70000)
        
        // Set camera zoom out range
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        
        // Set camera constrains
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region),
                                  animated: true)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // Big Buddha data
        let bigBuddha = Site(title: "The Big Buddha",
                             location: "Ngong Ping, Lantau Island",
                             siteType: "Large Bronze Statue",
                             coordinate: CLLocationCoordinate2D(latitude: 22.254106, longitude: 113.905144))
        mapView.addAnnotation(bigBuddha)
        
        // Disneyland data
        let disneyland = Site(title: "Hong Kong Disneyland",
                              location: "Penny's Bay, Lantau Island",
                              siteType: "Theme Park",
                              coordinate: CLLocationCoordinate2D(latitude: 22.313333, longitude: 114.043333))
        mapView.addAnnotation(disneyland)
        
        // Ocean Park data
        let oceanpark = Site(title: "Ocean Park",
                             location: "Wong Chuk Hank, Hong Kong Island",
                             siteType: "Theme Park",
                             coordinate: CLLocationCoordinate2D(latitude: 22.245861, longitude: 114.175917))
        mapView.addAnnotation(oceanpark)
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

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Check if annotation is a Site object
        guard let annotation = annotation as? Site else {
            return nil
        }
        
        let identifier = "site"
        var view: MKMarkerAnnotationView
        
        // Check invisable annotations and reuse it
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            // If visale then apply  title and subtitle based on their properties
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x:-5, y:5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

