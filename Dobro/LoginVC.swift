//
//  LoginVC.swift
//  Dobro
//
//  Created by Dev1 on 12/29/15.
//  Copyright © 2015 FXofficeApp. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.emailField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.login()
        }
        return true
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.login();
    }
    
    func login() {
        let email = emailField.text!.lowercaseString
        let password = passwordField.text
        
        if email.characters.count == 0 {
            //ProgressHUD.showError("Email field is empty.")
            return
        } else {
            //ProgressHUD.showError("Password field is empty.")
        }
        
        //ProgressHUD.show("Signing in...", interaction: true)
        
        PFUser.logInWithUsernameInBackground(email, password: password!) { (user, error) -> Void in
            if user != nil {
               // PushNotication.parsePushUserAssign()
               // ProgressHUD.showSuccess("Welcome back, \(user[PF_USER_FULLNAME])!")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let info = error?.userInfo {
                    print(info["error"] as! String)
                }
            }
        }
    }

}
