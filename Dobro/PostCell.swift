//
//  PostCellTableViewCell.swift
//  Dobro
//
//  Created by Dev1 on 1/11/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var featuredImg: UIImageView!
    
    @IBOutlet weak var excerptLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    private var _post: Post?
    
    var post: Post? {
        return _post
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func drawRect(rect: CGRect) {
        featuredImg.clipsToBounds = true
    }
    
    
    func configureCell(post: Post, img: UIImage?) {
        
        self._post = post
        
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
            self.dateLbl.text = Utilities.timeElapsed(seconds)
            
        }
        
        if post.featuredImg != nil {
            
            if img != nil {
                self.featuredImg.image = img
            } else {
                
                let featuredImage = post.featuredImg
                
                featuredImage!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)!
                        self.featuredImg.image = image
                        FeedVC.imageCache.setObject(image, forKey: self.post!.featuredImg!)
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
            }
            
            
        })
        
    }


}
