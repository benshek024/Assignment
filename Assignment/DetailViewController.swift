//
//  DetailViewController.swift
//  Assignment
//
//  Created by Ben Shek on 8/1/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var siteTypeLabel: UILabel!
    
    var tString : String?
    var lString : String?
    var sString : String?
    
    var site: Site?
    
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
