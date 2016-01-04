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
        
    }
    
    @IBAction func sendPost(sender: AnyObject) {
        let title = self.postTitle.text
        let text = self.postText.text
        let user = PFUser.currentUser()
        
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
                    } else {
                        // There was a problem, check error.description
                    }
                }
            }
        }
       
    }

}
