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
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var stopTimeLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    
    
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
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy HH:mm"
        
        let start_time = eventDataPassed["start_time"]
        if let date = dateFormatterGet.date(from: start_time!) {
            startTimeLabel.text = dateFormatterPrint.string(from: date)
        }
        
        let stop_time = eventDataPassed["stop_time"]
        if let date = dateFormatterGet.date(from: stop_time!) {
            stopTimeLabel.text = dateFormatterPrint.string(from: date)
        }
        
        countryLabel.text = eventDataPassed["country_name"]
        
        regionLabel.text = eventDataPassed["region_name"]
        
        cityLabel.text = eventDataPassed["city_name"]
        
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
