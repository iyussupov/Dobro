//
//  PostCreateVC.swift
//  Dobro
//
//  Created by Dev1 on 1/4/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class PostCreateVC: UIViewController {

    
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
           
        }
        else {
            Utilities.loginUser(self)
        }
        
    }
    
    @IBAction func sendPost(sender: AnyObject) {
        let title = self.postTitle.text
        let text = self.postText.text
        let user = PFUser.currentUser()
        
        
        let installation = PFInstallation.currentInstallation()
        print("installation: \(installation)")
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let Post = PFObject(className:"Post")
                
                Post["title"] = title
                Post["text"] = text
                Post["user"] = user
                Post["location"] = geoPoint
                Post.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        
                        let userQuery = PFInstallation.query() as PFQuery!
                        userQuery.whereKey("location", nearGeoPoint: geoPoint!, withinKilometers: 50)
                        
                        var str_CurrentDeviceToken = installation.objectForKey("deviceToken")
                        
                        print(str_CurrentDeviceToken)
                        
                        if str_CurrentDeviceToken == nil {
                            str_CurrentDeviceToken = "095ba25a8862b7ce7a25bbc698efda31f05c9127ff7f69d44603c7f57bcf7bjo"
                        }
                        
                        print(str_CurrentDeviceToken)
                        
                        userQuery.whereKey("deviceToken", notEqualTo: str_CurrentDeviceToken!)
                        
                        
                        let data = ["\(text)":"alert", "1":"badge", "":"sound"]
                        
                        let push = PFPush.init()
                        push.setQuery(userQuery)
                        push.setData(data)
                        push.sendPushInBackground()
                        
                        
                        
                    } else {
                        // There was a problem, check error.description
                    }
                }
            }
        }
       
    }

}
