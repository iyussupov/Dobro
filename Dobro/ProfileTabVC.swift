//
//  ProfileTabVC.swift
//  Dobro
//
//  Created by Dev1 on 12/29/15.
//  Copyright © 2015 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class ProfileTabVC: UIViewController, UIActionSheetDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if PFUser.currentUser() != nil {
            //self.loadUser()
        } else {
            Utilities.loginUser(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func logout() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Log out")
        actionSheet.showFromTabBar(self.tabBarController!.tabBar)
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        self.logout()
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            PFUser.logOut()
            //PushNotication.parsePushUserResign()
            //Utilities.postNotification(NOTIFICATION_USER_LOGGED_OUT)
            //self.cleanup()
            Utilities.loginUser(self)
        }
    }
}
