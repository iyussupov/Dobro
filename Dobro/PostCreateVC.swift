//
//  PostCreateVC.swift
//  Dobro
//
//  Created by Dev1 on 1/4/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class PostCreateVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var currentCategoryLbl: UILabel!
    @IBOutlet weak var featuredImg: UIImageView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryDoneLbl: UIButton!
    @IBOutlet weak var sendBtnLbl: UIButton!
    
    @IBAction func selectCategory(sender: AnyObject) {
        self.categoryPicker.hidden = false
        self.categoryDoneLbl.hidden = false
        self.sendBtnLbl.hidden = true
        
    }
    
    var categoryArray:[String] = []
    var categoryInt = 0
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
           
        }
        else {
            Utilities.loginUser(self)
        }
        
        self.postText.layer.borderWidth = 1
        self.postText.layer.borderColor = UIColor.grayColor().CGColor
        postText.delegate = self
        
        
        
        let CategoryQuery: PFQuery =  PFQuery(className:"Category")
        CategoryQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let categoryId = object.objectId
                    let category = Category(categoryId: categoryId!, dictionary: object)
                    self.categories.append(category)
                    self.categoryArray.append(category.categoryName!)
                }
                
                self.categoryPicker.delegate = self
            } else {
                
            }
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            postText.resignFirstResponder()
            return false
        }
        return true
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInt = row
    }
    
    @IBAction func categorySelectedBtn(sender: AnyObject) {
        self.categoryPicker.hidden = true
        self.categoryDoneLbl.hidden = true
        self.sendBtnLbl.hidden = false
        self.currentCategoryLbl.text = categoryArray[categoryInt]
    }
    
    @IBAction func chooseImageFromLibrary(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    @IBAction func chooseImageFromCamera(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.featuredImg.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sendPost(sender: AnyObject) {
        let text = self.postText.text
        let user = PFUser.currentUser()
        let data = UIImageJPEGRepresentation(self.featuredImg.image!, 0.75)
        let imageFile = PFFile(name: "image.jpg", data: data!)
        
        let categoryId = categories[categoryInt].categoryId
        
        if text != "" && categoryId != nil {
            
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if error == nil {
                    let Post = PFObject(className:"Post")
                    
                    Post["text"] = text
                    Post["user"] = user
                    
                    let categoryObjectId = PFObject(withoutDataWithClassName: "Category", objectId: categoryId)
                    Post.setObject(categoryObjectId, forKey: "category")
                    
                    Post["featuredImage"] = imageFile
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
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
       
    }

}
