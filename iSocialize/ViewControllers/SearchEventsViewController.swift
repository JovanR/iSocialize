//
//  SearchEventsViewController.swift
//  iSocialize
//
//  Created by Jovan R on 11/15/18.
//  Copyright © 2018 Jovan Rivera. All rights reserved.
//

import UIKit

class SearchEventsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var categories = [String]()
    var categoryIds = [String]()
    
    // Instantiate an array of dictionaries to store searched events
    var searchedEvents = [[String:String]]()
    
    @IBOutlet var searchLocationTextField: UITextField!
    @IBOutlet var searchKeywordTextField: UITextField!
    @IBOutlet var categoryPickerView: UIPickerView!
    
    @IBAction func SearchButtonPressed(_ sender: Any) {
        performSearch()
        performSegue(withIdentifier: "Perform Search", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCategories()
        
        // Sort categories in alphabetical order
        categories.sort{ $0 < $1 }
        
        // Show Category Picker View middle row as the selected one
        categoryPickerView.selectRow(Int(categories.count / 2), inComponent: 0, animated: false)
    }
    
    func performSearch(){
        /*************** List of Actions Performed below ***************
         1. Form the API search query based on user input
         2. Obtain JSON data from the eventful API for the search query.
         3. Extract all of the data items of interest from the JSON data.
         4. Create a array of dictionaries containing all of the searchedEvent data.
         ********************************************************************/
        
        /*
         ------------------------------------------------
         1. Form the API search query based on user input
         Example query: http://api.eventful.com/json/events/search?app_key=Cn8jSwzSL92VFNc8&keywords=books&category=music&date=Future
        -------------------------------------------------*/
        var apiSearchUrl = "http://api.eventful.com/json/events/search?app_key=Cn8jSwzSL92VFNc8"
        
        let category = categoryIds[categoryPickerView.selectedRow(inComponent: 0)]
        apiSearchUrl += "&category=\(category)"
        
        if searchKeywordTextField.text != "" && searchKeywordTextField.text != " "{
            var keyword = searchKeywordTextField.text
            keyword = keyword!.replacingOccurrences(of: " ", with: "+")
            apiSearchUrl += "&keywords=\(keyword!)"
        }
        
        if searchLocationTextField.text != "" && searchLocationTextField.text != " "{
            let location = searchLocationTextField.text
            apiSearchUrl += "&location=\(location!)"
        }
        
        apiSearchUrl += "&date=Future"
        
        /*
         ------------------------------------------------------------------
         2. Obtain JSON data from the Eventful API for the search query         ------------------------------------------------------------------
         */
        // Create a URL struct data structure from the API query URL string
        let url = URL(string: apiSearchUrl)
        
        /*
         We use the NSData object constructor below to download the JSON data via HTTP in a single thread in this method.
         Downloading large amount of data via HTTP in a single thread would result in poor performance.
         For better performance, NSURLSession should be used.
         */
        
        // Declare jsonData as an optional of type Data
        let jsonData: Data?
        
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "API Unrecognized!", messageBody: "")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            
            /* ----------------------------------------------------------------------------
             3. Extract all of the data items of interest from the JSON data.
             *  API Format provided in google docs *
             ----------------------------------------------------------------------------*/
            /*
             JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
             JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
             */
            
            let jsonDataDictionary = try! JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            let eventsDictionary =  jsonDataDictionary["events"] as! [String:[[String: AnyObject]]]
            
            let resultsArray =  eventsDictionary["event"]
            
            for i in 0..<resultsArray!.count{
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let title = resultsArray![i]["title"] as! String
                let latitude = resultsArray![i]["latitude"] as! String
                let longitude = resultsArray![i]["longitude"] as! String
                let url = resultsArray![i]["url"] as! String
                // region_name ?
                let start_time = resultsArray![i]["start_time"] as! String
                let venue_name = resultsArray![i]["venue_name"] as! String
                // venue_url ?
//                let imageDictionary = resultsArray![i]["image"] as! [String:String]
//                let imageURL = imageDictionary["url"]
                let city_name = resultsArray![i]["city_name"] as! String
                
                /* ----------------------------------------------------------------------------
                 4. Create a array of dictionaries containing all of the searchedEvent data.
                 ----------------------------------------------------------------------------*/
                var searchedEvent = [String:String]()
                searchedEvent["title"] = title
                searchedEvent["latitude"] = latitude
                searchedEvent["longitude"] = longitude
                searchedEvent["url"] = url
                searchedEvent["start_time"] = start_time
                searchedEvent["venue_name"] = venue_name
                searchedEvent["city_name"] = city_name
                searchedEvents.append(searchedEvent)
            }
            
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
    }
    
    /*
     -----------------------------
     MARK: - Get Categories
     -----------------------------
     */
    func getCategories(){
        let apiCategoriesURL = "http://api.eventful.com/json/categories/list?app_key=Cn8jSwzSL92VFNc8"
        
        // Create a URL struct data structure from the API query URL string
        let url = URL(string: apiCategoriesURL)
        
        /*
         We use the NSData object constructor below to download the JSON data via HTTP in a single thread in this method.
         Downloading large amount of data via HTTP in a single thread would result in poor performance.
         For better performance, NSURLSession should be used.
         */
        
        
        // Declare jsonData as an optional of type Data
        let jsonData: Data?
        
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "Category API Unrecognized!", messageBody: "")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            
            
            /*
             JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
             JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
             */
            
            /* --------------------------------------
             API Format provided in google docs
             --------------------------------------*/
            
            
            let jsonDataDictionary = try! JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            let categoryDict =  jsonDataDictionary["category"] as! [[String: AnyObject]]
            
            for i in 0..<categoryDict.count{
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let name = categoryDict[i]["name"] as! String
                categories.append(name)
                let id = categoryDict[i]["id"] as! String
                categoryIds.append(id)
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
        
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     ---------------------------------------
     MARK: - Picker View Data Source Methods
     ---------------------------------------
     */
    
    // Specifies how many components in the Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
     // Specifies how many rows in the Picker View component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    /*
     -----------------------------------
     MARK: - Picker View Delegate Method
     -----------------------------------
     */
    
    // Specifies title for a row in the Picker View component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Tag number is set in the Storyboard: 1 for dietLabelPickerView and 2 for healthLabelPickerView
        // We use Swift's ternary conditional operator:
        var rowTitle = categories[row]
        rowTitle = rowTitle.replacingOccurrences(of: "&amp;", with: "&")
        
        
        return rowTitle
    }
    

    /*
    // MARK: - Navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Perform Search" {
            
            // Obtain the object reference of the destination view controller
            let searchedEventsTableViewController: SearchedEventsTableViewController = segue.destination as! SearchedEventsTableViewController
            
            // Pass the data object to the downstream view controller object
            searchedEventsTableViewController.searchDataPassed = searchedEvents
        }
    }
}
