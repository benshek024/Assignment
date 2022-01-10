//
//  FavouriteViewController.swift
//  Assignment
//
//  Created by Ben Shek on 10/1/2022.
//

import UIKit
import CoreData

class FavouriteViewController: UITableViewController {

    var sites: [FavouriteSites]?
    
    var managedObjectContext : NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchAndReloadTable(query: "")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sites = self.sites {
            return sites.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let site = self.sites?[indexPath.row] {
            cell.textLabel?.text = "\(site.siteName!)"
        }
        return cell
    }
    
    func searchAndReloadTable(query: String) {
        if let managedObjectContext = self.managedObjectContext {
            let fetchRequest = NSFetchRequest<FavouriteSites>(entityName: "FavouriteSites")
            if query.count > 0 {
                let predicate = NSPredicate(format: "[cd] %@", query)
                fetchRequest.predicate = predicate
            }
            
            do {
                let favSites = try managedObjectContext.fetch(fetchRequest)
                self.sites = favSites
                self.tableView.reloadData()
            } catch {
                print("Fail to Load Data, \(error)")
            }
        }
    }
}
