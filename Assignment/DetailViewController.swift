//
//  DetailViewController.swift
//  Assignment
//
//  Created by Ben Shek on 8/1/2022.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    
    var favVC = FavouriteViewController()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var siteTypeLabel: UILabel!
    
    // Save site to favourite
    @IBAction func favouriteButton() {
        if let context = self.managedObjectContext {
            // Add site name, site longitude and latitude as new object
            if let newFavSite = NSEntityDescription.insertNewObject(forEntityName: "FavouriteSites", into: context) as? FavouriteSites {
                newFavSite.siteName = self.titleLabel.text
                newFavSite.siteLongtitude = self.lng!
                newFavSite.siteLatitude = self.lat!
            }
            do {
                try context.save()
                // Merge record that already exists in favourite site view no matter how many times user has pressed Add to Favourite button
                managedObjectContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                self.dismiss(animated: true)
            } catch {
                print("Fail to Save, \(error)")
            }
            // Reload table when saved
            favVC.searchAndReloadTable(query: "")
        }
    }
    
    var lng : Double?
    var lat : Double?
    
    var tString : String?
    var lString : String?
    var sString : String?
    
    var site: Site?
    var favSite : FavouriteSites?
    
    var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tText = tString {
            self.titleLabel.text = tText
        }
        
        if let lText = lString {
            self.locationLabel.text = lText
        }
        
        if let sText = sString {
            self.siteTypeLabel.text = sText
        }
    }
}
