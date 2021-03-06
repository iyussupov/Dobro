//
//  WelcomeVC.swift
//  Dobro
//
//  Created by Dev1 on 12/29/15.
//  Copyright © 2015 FXofficeApp. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import Alamofire

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        //ProgressHUD.show("Signing in...", interaction: false)
        let permissions = []
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions as? [String]) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                if user![PF_USER_FACEBOOKID] == nil {
                    self.requestFacebook(user!)
                } else {
                    self.userLoggedIn(user!)
                }
            } else {
                if error != nil {
                    print(error)
                    if let info = error?.userInfo {
                        print(info)
                    }
                }
                //ProgressHUD.showError("Facebook sign in error")
            }
        }
    }
    
    func requestFacebook(user: PFUser) {
        let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields":"id,email,link,name"])
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                let userData = result as! [String: AnyObject]!
                self.processFacebook(user, userData: userData)
            } else {
                PFUser.logOut()
                //ProgressHUD.showError("Failed to fetch Facebook user data")
            }
        }
    }
    
    func processFacebook(user: PFUser, userData: [String: AnyObject]) {
        let facebookUserId = userData["id"] as! String
        let link = "http://graph.facebook.com/\(facebookUserId)/picture"
        //let url = NSURL(string: link)
        //let request = NSURLRequest(URL: url!)
        let params = ["height": "200", "width": "200", "type": "square"]
        Alamofire.request(.GET, link, parameters: params).response() {
            (request, response, data, error) in
            
            if error == nil {
                var image = UIImage(data: data! as NSData!)!
                
                if image.size.width > 280 {
                    image = Images.resizeImage(image, width: 280, height: 280)!
                }
                let filePicture = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6)!)
                filePicture!.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error != nil {
                        //ProgressHUD.showError("Error saving photo")
                    }
                })
                
                if image.size.width > 60 {
                    image = Images.resizeImage(image, width: 60, height: 60)!
                }
                let fileThumbnail = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6)!)
                fileThumbnail!.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error != nil {
                        //ProgressHUD.showError("Error saving thumbnail")
                    }
                })
                
                user[PF_USER_EMAILCOPY] = userData["email"]
                user[PF_USER_FULLNAME] = userData["name"]
                user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
                user[PF_USER_FACEBOOKID] = userData["id"]
                user[PF_USER_PICTURE] = filePicture
                user[PF_USER_THUMBNAIL] = fileThumbnail
                user.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if error == nil {
                        self.userLoggedIn(user)
                    } else {
                        PFUser.logOut()
                        if let info = error?.userInfo {
                            //ProgressHUD.showError("Login error")
                            print(info["error"] as! String)
                        }
                    }
                })
            } else {
                PFUser.logOut()
                if let info = error?.userInfo {
                    //ProgressHUD.showError("Failed to fetch Facebook photo")
                    print(info["error"] as! String)
                }
            }
        }
    }
    
    func userLoggedIn(user: PFUser) {
        //PushNotication.parsePushUserAssign()
        //ProgressHUD.showSuccess("Welcome back, \(user[PF_USER_FULLNAME])!")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
