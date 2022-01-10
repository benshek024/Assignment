//
//  FavouriteSites+CoreDataProperties.swift
//  Assignment
//
//  Created by Ben Shek on 11/1/2022.
//
//

import Foundation
import CoreData


extension FavouriteSites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteSites> {
        return NSFetchRequest<FavouriteSites>(entityName: "FavouriteSites")
    }

    @NSManaged public var siteName: String?
    @NSManaged public var siteLongtitude: Double
    @NSManaged public var siteLatitude: Double

}

extension FavouriteSites : Identifiable {

}
