//
//  EventDetailsViewController.swift
//  iSocialize
//
//  Created by Jovan R on 11/15/18.
//  Copyright © 2018 Jovan Rivera. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventDescriptionLabel: UITextView!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var moreInfoButton: UIButton!
    
    //Event data obtained from upstream view controller
    var eventDataObtained = [String]()
    
    /*
     eventDataPassed = [ "id",
     "title",
     "latitude",
     "longitude",
     "start_time",
     "venue_name",
     "venue_address",
     "region_name",
     "city_name",
     "imageURL",
     "description",
     "category"]*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        // Perform the segue named Event Trailer
        performSegue(withIdentifier: "Page View", sender: self)
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "Page View" {
            
//            // Obtain the object reference of the destination view controller
//            let pageViewController: PageViewController = segue.destination as! PageViewController
//            
//            //Pass the data object to the destination view controller object
//            pageViewController.eventDataPassed = eventDataObtained
            
        }
    }
    
}
