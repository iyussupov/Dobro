//
//  PostCellTableViewCell.swift
//  Dobro
//
//  Created by Dev1 on 1/11/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var featuredImg: UIImageView!
    
    @IBOutlet weak var excerptLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    
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
            
            let Date:NSDateFormatter = NSDateFormatter()
            Date.dateFormat = "yyyy-MM-dd"
            self.dateLbl.text = Date.stringFromDate(date)
            
        }
        
        if post.featuredImg != nil {
            
            if img != nil {
                self.featuredImg.image = img
            } else {
                
                let featuredImage = post.featuredImg
                
                featuredImage!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)!
                        print(image)
                        self.featuredImg.image = image
                        FeedVC.imageCache.setObject(image, forKey: self.post!.featuredImg!)
                    }
                }
                
            }
            
        } else {
            self.featuredImg.image = UIImage(named: "mask")
        }
        
    }


}
