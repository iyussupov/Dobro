//
//  RegisterVC.swift
//  Dobro
//
//  Created by Dev1 on 12/29/15.
//  Copyright © 2015 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.nameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.nameField {
            self.emailField.becomeFirstResponder()
        } else if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.register()
        }
        return true
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        self.register()
    }
    
    func register() {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text!.lowercaseString
        
        if name!.characters.count == 0 {
            //ProgressHUD.showError("Name must be set.")
            return
        }
        if password.characters.count == 0 {
            //ProgressHUD.showError("Password must be set.")
            return
        }
        if email!.characters.count == 0 {
            //ProgressHUD.showError("Email must be set.")
            return
        }
        
        //ProgressHUD.show("Please wait...", interaction: false)
        
        let user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        user[PF_USER_EMAILCOPY] = email
        user[PF_USER_FULLNAME] = name
        user[PF_USER_FULLNAME_LOWER] = name!.lowercaseString
        user.signUpInBackgroundWithBlock { succeeded, error -> Void in
            if error == nil {
                //PushNotication.parsePushUserAssign()
                //ProgressHUD.showSuccess("Succeeded.")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let userInfo = error?.userInfo {
                    print(userInfo["error"] as! String)
                }
            }
        }
    }

}
