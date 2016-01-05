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
        let text = self.postText.text
        let user = PFUser.currentUser()
        
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let Post = PFObject(className:"Post")
                
                Post["text"] = text
                Post["user"] = user
                Post["location"] = geoPoint
                Post.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        
                        let userQuery = PFInstallation.query() as PFQuery!
                        userQuery.whereKey("location", nearGeoPoint: geoPoint!, withinKilometers: 1)
//
//                        let str_CurrentDeviceToken = installation.objectForKey("deviceToken")
//                        userQuery.whereKey("deviceToken", notEqualTo: str_CurrentDeviceToken!)
                        
                        let postId = Post.objectId!
                        let data = [
                            "alert" : "Help me!!!",
                            "badge" : "Increment",
                            "postId":"\(postId)"
                        ]
                        
                        let push = PFPush()
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
