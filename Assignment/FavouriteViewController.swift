//
//  FavouriteViewController.swift
//  Assignment
//
//  Created by Ben Shek on 10/1/2022.
//

import UIKit
import CoreData

class FavouriteViewController: UITableViewController {

    // Delete all record inside the table view
    @IBAction func deleteButton() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteSites")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        // Execute the delete request and update the database
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Fail to Delete")
        }
        // Reload the table once executed
        searchAndReloadTable(query: "")
    }
    
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let site = self.sites?.remove(at: indexPath.row) {
                managedObjectContext?.delete(site)
                try? self.managedObjectContext?.save()
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
