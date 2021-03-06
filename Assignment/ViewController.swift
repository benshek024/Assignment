//
//  ViewController.swift
//  Assignment
//
//  Created by Ben Shek on 4/1/2022.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

struct favourite {
    static var isFavClicked = false
    static var longitude: Double?
    static var latitude: Double?
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var lng = 114.1694
    var lat = 22.3193
    
    var latitude: Double?
    var longitude: Double?
    
    var tString = "Title"
    var lString = "Location"
    var sString = "Site Type"
    
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
    var selectedAnnotation: Site?
    var siteCoord: CLLocationCoordinate2D!
    var a: Double = 0.0
    var b: Double = 0.0
    
    @IBOutlet fileprivate var mapView: MKMapView!
    
    // Center current view back to user current location
    @IBAction func centerButton(_ sender: Any) {
        checkLocationAuthorization()
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        guard let favouritevc = storyboard?.instantiateViewController(identifier: "favourite_sites") as? FavouriteViewController
        else {
            return
        }
        favouritevc.modalPresentationStyle = .fullScreen
        present(favouritevc, animated: true)
    }
    
    // Right side button of the map annotation callout
    let detailBTN = UIButton(type: .detailDisclosure)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show Compass
        mapView.showsCompass = false
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        mapView.addSubview(compass)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -25).isActive = true
        compass.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 125).isActive = true
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Call function when isFavClicked is true
        if favourite.isFavClicked == true {
            favouriteClicked()
        } else {
            return
        }
    }
    
    // Zoom current view to selected favourite site
    func favouriteClicked() {
        if let siteLat = favourite.latitude { a = siteLat }
        if let siteLng = favourite.longitude { b = siteLng }
        let siteCoord = CLLocationCoordinate2D(latitude: a, longitude: b)

        mapView.zoomToLocation(siteCoord)
        favourite.isFavClicked = false
    }
    
    // Checking location authorization from user
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
    
    // Assign annotation data to variables when selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        if let annotation = view.annotation as? Site {
            // Set title, location, site type, longitude and latitude to correspondent variables
            tString = annotation.title!
            lString = annotation.location!
            sString = annotation.siteType!
            lng = annotation.coordinate.longitude
            lat = annotation.coordinate.latitude
            // Debug
            print("Title is: \(tString)")
            print("Location is: \(lString)" )
            print("Site Type is: \(sString)")
            print("Longtitude is: \(lng)")
            print("Latitude is: \(lat)")
        }
    }
    
    // Assign data to detail view variables to display it when clicked right callout button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // Create an instance of DetailViewController
        guard let detailvc = storyboard?.instantiateViewController(identifier: "detail_vc") as? DetailViewController
        else {
            return
        }
        
        // Assign variables
        detailvc.tString = tString
        detailvc.lString = lString
        detailvc.sString = sString
        detailvc.lat = lat
        detailvc.lng = lng
        
        // Show detail view for site
        present(detailvc, animated: true)
    }
}

// Center current view to desired region
public extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000) {
        let coordRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordRegion, animated: true)
    }
    
    func zoomToLocation(_ location: CLLocationCoordinate2D, latMeters: CLLocationDistance = 100, lngMeters: CLLocationDistance = 100) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: latMeters, longitudinalMeters: lngMeters)
        setRegion(region, animated: true)
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

