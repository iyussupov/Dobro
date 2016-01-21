//
//  EventVC.swift
//  Dobro
//
//  Created by Dev1 on 1/5/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class EventVC: UIViewController {
    
    @IBOutlet weak var featuredImg: UIImageView!
    
    @IBOutlet weak var excerptLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var authorLocationLbl: UILabel!

    var postKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.parseEvent()
        
    }
    
    func parseEvent() {
        if postKey != nil {
            let PostsQuery: PFQuery =  PFQuery(className:"Post")
            PostsQuery.includeKey("category")
            PostsQuery.getObjectInBackgroundWithId(postKey! as String, block: { (object, error) -> Void in
                if error == nil {
                    let key = object!.objectId as String!
                    let date = object!.createdAt as NSDate!
                    let post = Post(postKey: key, date: date, dictionary: object!)
                    
                    if let content = post.content where content != "" {
                        self.excerptLbl.text = content
                    } else {
                        self.excerptLbl.text = nil
                    }
                    
                    if let category = post.category where category != "" {
                        self.categoryLbl.text = category
                    } else {
                        self.categoryLbl.text = nil
                    }
                    
                    if let date = post.date where date != "" {
                        
                        let seconds = NSDate().timeIntervalSinceDate(date)
                        self.dateLbl.text = Utilities.timeElapsed(seconds).uppercaseString
                        
                    }
                    
                    if let authorName = post.authorName where authorName != "" {
                        
                        self.authorName.text = authorName.uppercaseString
                        
                    }
                    
                    if post.featuredImg != nil {
                        
                        var img: UIImage?
                        
                        if let url = post.featuredImg {
                            
                            img = FeedVC.imageCache.objectForKey(url) as? UIImage
                            
                        }
                        
                        if img != nil {
                            self.featuredImg.image = img
                        } else {
                            
                            let featuredImage = post.featuredImg
                            
                            featuredImage!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    let image = UIImage(data:imageData!)!
                                    self.featuredImg.image = image
                                    FeedVC.imageCache.setObject(image, forKey: post.featuredImg!)
                                }
                            }
                            
                        }
                        
                    } else {
                        self.featuredImg.image = UIImage(named: "mask")
                    }
                    
                    PFGeoPoint.geoPointForCurrentLocationInBackground({ (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                        if error == nil {
                            let point = post.location
                            let currentDistance = Double(round(10*geoPoint!.distanceInKilometersTo(point))/10)
                            if currentDistance < 1.0 && currentDistance != 0.0 {
                                
                                self.distanceLbl.text = "\(Int(round(1000*geoPoint!.distanceInKilometersTo(point))/1))m"
                                
                            } else if currentDistance == 0.0 {
                                
                                self.distanceLbl.text = "Near"
                                
                            } else {
                                
                                self.distanceLbl.text = "\(currentDistance)km"
                                
                            }
                            
                            let geoCoder = CLGeocoder()
                            let location = CLLocation(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
                            
                            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                                
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placemarks?[0]
                                
                                let city = placeMark.addressDictionary!["City"] as? String
                                let country = placeMark.addressDictionary!["CountryCode"] as? String
                                
                                self.authorLocationLbl.text = "\(city!.uppercaseString), \(country!.uppercaseString)"
                                
                                
                            })
                            
                            
                            
                        }
                        
                        
                    })
                    
                }
                
            })
            
        }
    }


}
