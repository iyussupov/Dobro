//
//  Category.swift
//  Dobro
//
//  Created by Dev1 on 1/11/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import Foundation
import Parse

class Category {
    
    private var _categoryName: String?
    private var _categoryId: String?
    
    var categoryName: String? {
        return _categoryName
    }
    
    var categoryId: String? {
        return _categoryId
    }
    
    init (categoryName: String?) {
        self._categoryName = categoryName
    }
    
    init(categoryId: String, dictionary: PFObject) {
        
        self._categoryId = categoryId
        
        if let categoryName = dictionary["categoryName"] as? String {
            self._categoryName = categoryName
        }
        
    }
}