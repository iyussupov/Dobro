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
                    print(post)
                }
            })
            
        }
    }


}
