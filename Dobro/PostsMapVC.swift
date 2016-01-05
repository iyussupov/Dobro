//
//  PostsMapVC.swift
//  Dobro
//
//  Created by Dev1 on 1/4/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class PostsMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
            
        }
        else {
            Utilities.loginUser(self)
        }

        mapView.showsUserLocation = true
        mapView.delegate = self
        MapViewLocationManager.delegate = self
        MapViewLocationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
  
    }
    
    override func viewDidAppear(animated: Bool) {
        let annotationQuery = PFQuery(className: "Post")
        currentLoc = PFGeoPoint(location: MapViewLocationManager.location)
        //annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 10)
        annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinKilometers: 50)
        annotationQuery.findObjectsInBackgroundWithBlock {
            (posts, error) -> Void in
            if error == nil {
                // The find succeeded.
                
                for post in posts! {
                    let point = post["location"] as! PFGeoPoint
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    annotation.title = post["text"] as? String
                    self.mapView.addAnnotation(annotation)
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }
        
    }


}
