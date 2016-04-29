//
//  VCMapView.swift
//  VancouverMapKit
//
//  Created by Andrew Walsh on 2016-03-30.
//  Copyright © 2016 Andrew Walsh. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    //  Gets called for each annotation (pin) that is added to the map
    //  Check to see if an annotation (pin) is no longer visible in the view before creating
    //  a new one
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? FireHalls {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            // Reuses an annotation (pin)
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            //Creates a new annotation (pin) if one cannot be dequed
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    
    // This function configures the callout to include a detail disclosure info button
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            
            // Gets FireHall object that was tapped
            let location = view.annotation as! FireHalls
            
            // Launch with directions mode set to driving, this can be changed to walking or transit.
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            // Call to launch Maps with the tapped location and specified launch options
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}