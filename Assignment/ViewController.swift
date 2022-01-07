//
//  ViewController.swift
//  Assignment
//
//  Created by Ben Shek on 4/1/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    // Hong Kong coordinate
    let hkCoord = CLLocation(latitude: 22.3193, longitude: 114.1694)
    
    // Map filters
    let amPark = MKPointOfInterestCategory.amusementPark
    let aquarium = MKPointOfInterestCategory.aquarium
    let beach = MKPointOfInterestCategory.beach
    let museum = MKPointOfInterestCategory.museum
    let nPark = MKPointOfInterestCategory.nationalPark
    
    let mapMeters: Double = 10000
    
    private var sites: [Site] = []
    
    @IBOutlet private var mapView: MKMapView!
    
    let detailBTN = UIButton(type: .detailDisclosure)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tracking user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        checkLocationAuthorization()
        setCameraContrains()
        
        // Apply map filter with included parameters
        mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [amPark, aquarium, beach, museum, nPark]))
        
        // Call function to load geojson data and show them on the map
        loadGeoJson()
        mapView.addAnnotations(sites)
        
    }
    
    func checkLocationAuthorization() {
        // If the location services in enabled on device, do the following things
        if CLLocationManager.locationServicesEnabled() {
            // Checking if user granted access to location tracking
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                // If not, center the map to default coordinate
                print("No access")
                // Center the map to Hong Kong as default if no access
                mapView.centerToLocation(hkCoord)
            case .authorizedAlways, .authorizedWhenInUse:
                // If yes, start the tracking process and center the view to user
                print("Have access")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                centerViewToUser()
            @unknown default:
                break
            }
        } else {
            // Print error if not enabled
            print("Location services are not enabled")
        }
    }
    
    func setCameraContrains() {
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
    }
    
    // Center the current map view to user
    func centerViewToUser() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: mapMeters, longitudinalMeters: mapMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Load geojson data
    func loadGeoJson() {
        
        // Try to read map.geojson
        guard
            let file = Bundle.main.url(forResource: "map", withExtension: "geojson"),
            let siteData = try? Data(contentsOf: file)
        else {
            return
        }
        
        do {
            // Obtain features data in geojson
            let features = try MKGeoJSONDecoder()
                .decode(siteData).compactMap { $0 as? MKGeoJSONFeature}
            
            // Transform features into Site objects
            let featuresObj = features.compactMap(Site.init)
            // Append to sites array
            sites.append(contentsOf: featuresObj)
        } catch {
            // Print the error if catch it
            print("Unexpected Error: \(error)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let detailvc = storyboard?.instantiateViewController(identifier: "detail_vc") as? DetailViewController
        else {
            return
        }
        present(detailvc, animated: true)
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

// Showing callout bubble when annotations on the map are clicked
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
            // If visale then apply title and subtitle based on their properties
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x:-5, y:5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = detailBTN
        }
        return view
    }
}

