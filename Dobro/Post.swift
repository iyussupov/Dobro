//
//  Post.swift
//  Dobro
//
//  Created by Dev1 on 1/4/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import Foundation
import Parse

class Post {
    
    private var _featuredImg: PFFile?
    
    private var _content: String?
    
    private var _location: PFGeoPoint?
    
    private var _date: NSDate?
    
    private var _postKey: String!
    
    private var _category:String!
    
    private var _authorName:String?
    
    /*
    
    private var _category: String?
    
    private var _commentCount: Int!
    */
    
    var content: String? {
        return _content
    }
    
    var location: PFGeoPoint? {
        return _location
    }
    
    var postKey: String? {
        return _postKey
    }
    
    
    var date: NSDate? {
        return _date
    }
    var featuredImg: PFFile? {
        return _featuredImg
    }
    
    var category: String? {
        return _category
    }
    
    var authorName: String? {
        return _authorName
    }
    
    /*
    
    var commentCount: Int? {
        return _commentCount
    }
    */
    init ( content: String?, location: PFGeoPoint?, authorName: String?, date: NSDate?, postKey: String?, featuredImg: PFFile?, category: String? /* commentCount:Int?*/ ) {
        
        self._content = content
        self._location = location
        self._date = date
        self._postKey = postKey
        
        self._category = category
        self._featuredImg = featuredImg
        self._date = date
        self._authorName = authorName
        
        /*
        self._commentCount = commentCount
        */
    }
    
    init(postKey: String, date: NSDate, dictionary: PFObject) {
        
        self._postKey = postKey
        self._date = date
        
        if let location = dictionary["location"] as? PFGeoPoint {
            self._location = location
        }
        
        if let content = dictionary["text"] as? String {
            self._content = content
        }
        
        if let authorName = dictionary["user"]["fullname"] as? String {
            self._authorName = authorName
        }
        
        if let category = dictionary["category"]["categoryName"] as? String {
            self._category = category
        }
        
        if let featuredImg = dictionary["featuredImage"] as? PFFile {
            self._featuredImg = featuredImg
        }
        
        /*
        if let commentCount = dictionary["comments"] as? Int {
            self._commentCount = commentCount
        }
        */
        
    }
    
}
