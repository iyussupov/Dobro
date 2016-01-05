//
//  AppDelegate.swift
//  Dobro
//
//  Created by Dev1 on 12/29/15.
//  Copyright © 2015 FXofficeApp. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        Parse.setApplicationId("pnZbBxanuai1tf1dLbY78WLzEOSDxFGteIfHE2uZ", clientKey: "Dcr17fpUF5DPer8t5OvDywtGItaPBCiLkG7T0y14")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        //Push
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error:NSError?) -> Void in
            if error == nil {
                
                let installation = PFInstallation.currentInstallation()
                installation.setDeviceTokenFromData(deviceToken)
                installation["location"] = geoPoint
                installation.saveInBackground()
                
            } else {
                print ("geoError \(error?.localizedDescription)")
            }
        }
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if let postId = userInfo["postId"] as? String {
            
           
            let rootViewController = self.window!.rootViewController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EventVC") as! EventVC
            setViewController.post = postId
            rootViewController!.navigationController!.popToViewController(setViewController, animated: false)
            
        } else {
            PFPush.handlePush(userInfo)
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.badge = 0
        currentInstallation.saveEventually()
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }


}

