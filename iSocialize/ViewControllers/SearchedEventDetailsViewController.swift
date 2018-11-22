//
//  SearchedEventDetailsViewController.swift
//  iSocialize
//
//  Created by Jovan R on 11/15/18.
//  Copyright © 2018 Jovan Rivera. All rights reserved.
//

import UIKit

class SearchedEventDetailsViewController: UIViewController {

    var eventDataPassed = [String:String]()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = eventDataPassed["title"]
        
        // Set Event Image
        let eventImageUrl = eventDataPassed["imageURL"]
        if eventImageUrl == "null"{
            eventImageView.image = UIImage(named: "imageUnavailable.png")
        }
        else{
            if let url = URL(string: eventImageUrl!){
                let eventImageData = try? Data(contentsOf: url)
                
                if let imageData = eventImageData {
                    eventImageView.image = UIImage(data: imageData)
                } else {
                    eventImageView.image = UIImage(named: "imageUnavailable.png")
                }
            }
            else{
                eventImageView.image = UIImage(named: "imageUnavailable.png")
            }
        }
        
        descriptionTextView.text = eventDataPassed["description"]
        
        categoryLabel.text = eventDataPassed["category"]
        
        locationLabel.text = eventDataPassed["venue_address"]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
