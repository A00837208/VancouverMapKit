//
//  FireHalls.swift
//  VancouverMapKit
//
//  Created by Andrew Walsh on 2016-03-30.
//  Copyright © 2016 Andrew Walsh. All rights reserved.
//

import Foundation
import MapKit
import Contacts

// A firehall object that implements MKAnnotation. Includes a Title, Location Name, and Coordinates of the location.
class FireHalls: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    // Argument is an array of FireHall JSON-Value objects. Returns a FireHall object
    // with values based on their corresponding JSON index.
    class func fromJSON(json: [JSONValue]) -> FireHalls? {
        var title: String
        
        // If the title exists set it to its value otherwise set it to an empty string
        if let titleOrNil = json[8].string {
            title = titleOrNil
        } else {
            title = ""
        }
        let locationName = json[11].string
        
        // Convert lat and long values to doubles
        let latitude = (json[9].string! as NSString).doubleValue
        let longitude = (json[10].string! as NSString).doubleValue
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return FireHalls(title: title, locationName: locationName!, coordinate: coordinate)
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // Annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): self.subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}