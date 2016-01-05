//
//  EventVC.swift
//  Dobro
//
//  Created by Dev1 on 1/5/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit

class EventVC: UIViewController {

    var post:String?
    
    @IBOutlet weak var postId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.postId.text = "\(post)"
    }


}
