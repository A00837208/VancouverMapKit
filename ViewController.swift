//
//  ViewController.swift
//  VancouverMapKit
//
//  Created by Andrew Walsh on 2016-03-30.
//  Copyright © 2016 Andrew Walsh. All rights reserved.
//
// This app parses a JSON file into an array of firehalls, then displays
// them as annotation pins, with a callout info button that launches the Apple Maps app
//
// Product\Scheme\Edit Scheme  to set default location

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Array of FireHall objects
    var firehalls = [FireHalls]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // Set initial location to Vancouver coordinates
        let initialLocation = CLLocation(latitude: 49.246292, longitude: -123.116226)
        
        // Call the helper method to zoom into initialLocation on startup
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        
        mapView.addAnnotations(firehalls)
        
        mapView.delegate = self
    }
    
    // specify the rectangular region to display to get a correct zoom level
    let regionRadius: CLLocationDistance = 2700 // metres (2.7km)
    
    // location argument is the center point
    func centerMapOnLocation(location: CLLocation) {
        // multiply region radius by 2 to get the East/West and North/South diameters
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func loadInitialData() {
        // Read the PublicFireHalls.json file into an NSData object
        let fileName = NSBundle.mainBundle().pathForResource("PublicFireHalls", ofType: "json");
        var data: NSData?
        do {
            data = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        // Use NSJSONSerialization to obtain a JSON object
        var jsonObject: AnyObject? = nil
        if let data = data {
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        // Checks that JSON object is a dictionary where keys are strings and values can be AnyObject
        if let jsonObject = jsonObject as? [String: AnyObject],
        // Loop through JSON object with key of 'data' and ensure each element is an array
        let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
            for firehallJSON in jsonData {
                if let firehallJSON = firehallJSON.array,
                    // Pass each firehall array to the fromJSON method. If it returns a valid FireHall object add it to firehall array.
                    firehall = FireHalls.fromJSON(firehallJSON) {
                        firehalls.append(firehall)
                }
            }
        }
    }
}

