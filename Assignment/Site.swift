//
//  Site.swift
//  Assignment
//
//  Created by Ben Shek on 6/1/2022.
//

import Foundation
import MapKit

class Site: NSObject, MKAnnotation {
    let title: String?  // Site title
    let location: String?   // Site location
    let siteType: String?   // Site type (e.g., Theme park, statue, museum)
    let coordinate: CLLocationCoordinate2D  // Site location coordinate
    
    // Annotations customisation
    
    
    // Read the GeoJson file
    init? (feature: MKGeoJSONFeature) {
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let siteData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: siteData),
            let sites = json as? [String: Any]
        else {
            return nil
        }
        
        // Set the properties to related fields
        title = sites["title"] as? String
        location = sites["location"] as? String
        siteType = sites["siteType"] as? String
        coordinate = point.coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return location
    }
}
