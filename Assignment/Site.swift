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
    
    init (
        title: String?,
        location: String?,
        siteType: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.location = location
        self.siteType = siteType
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return location
    }
}
