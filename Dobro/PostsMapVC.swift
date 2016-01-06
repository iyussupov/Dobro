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

class PostsMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    var posts = [Post]()
    
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
        
  
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "myNotificationReceived", name: "pushNotification", object: nil)
        
        getPosts()
        
    }
    
    func myNotificationReceived() {
        let badgeValue = self.tabBarController?.tabBar.items![0].badgeValue
        
        if badgeValue != nil {
            self.tabBarController?.tabBar.items![0].badgeValue = (Int(badgeValue!)! + 1).description
        } else {
            self.tabBarController?.tabBar.items![0].badgeValue = "1"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.items![0].badgeValue = nil
        
        
    }
    
    func getPosts() {
        
        let annotationQuery = PFQuery(className: "Post")
        currentLoc = PFGeoPoint(location: MapViewLocationManager.location)
        //annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 10)
        annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinKilometers: 50)
        annotationQuery.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                
                for object in objects! {
                    
                    let key = object.objectId as String!
                    let date = object.createdAt as NSDate!
                    let post = Post(postKey: key, date: date, dictionary: object)
                    
                    let point = post.location
                    
                    let coordinate = CLLocationCoordinate2DMake(point!.latitude, point!.longitude)
                    let ann = CustomAnnotation(identifier: key, title: post.content!, subtitle: "", coordinate: coordinate, color: .Red)
                    
                    self.mapView.addAnnotation(ann)
                    
                    self.posts.append(post)
                    
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }
    }
    
    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation
        {
            let identifier = annotation.identifier
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier!) as? MKPinAnnotationView
            {
                view = dequeuedView
                view.annotation = annotation
            }
            else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.animatesDrop = true
                view.leftCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.rightCalloutAccessoryView = UIButton(type: .ContactAdd) as UIView
                view.pinColor = annotation.color!
                
                let calloutButton = UIButton(type: .DetailDisclosure) as UIButton
                view.rightCalloutAccessoryView = calloutButton
                
                //view.image
                //MKAnnotationView 32 x 29
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as! CustomAnnotation!
        let postKey = annotation.identifier!
        if control == view.rightCalloutAccessoryView {
          performSegueWithIdentifier("EventVC", sender: postKey)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventVC" {
            if let EventVC = segue.destinationViewController as? EventVC {
                if let postKey = sender as? String {
                    EventVC.postKey = postKey
                }
            }
        }
    }


}
