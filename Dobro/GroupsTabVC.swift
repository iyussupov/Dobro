//
//  GroupsTabVC.swift
//  Dobro
//
//  Created by Dev1 on 12/29/15.
//  Copyright © 2015 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class GroupsTabVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if PFUser.currentUser() != nil {
            //self.loadGroups()
        }
        else {
            Utilities.loginUser(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
