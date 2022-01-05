//
//  Site.swift
//  Assignment
//
//  Created by Ben Shek on 6/1/2022.
//

import Foundation
import MapKit

class Site: NSObject, MKAnnotation {
    let title: String?
    let location: String?
    let siteType: String?
    let coordinate: CLLocationCoordinate2D
    
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
