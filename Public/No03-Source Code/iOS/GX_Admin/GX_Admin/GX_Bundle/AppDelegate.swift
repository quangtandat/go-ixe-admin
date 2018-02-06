//
//  AppDelegate.swift
//  GX_Admin
//
//  Created by Iam H on 1/2/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var common = CommonClass()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let userInfoLogin = common.loadRememberedUser()
       FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyAbwZX27pHfu1hViq-sttjx0f8e-LEW3-E"); GMSPlacesClient.provideAPIKey("AIzaSyAbwZX27pHfu1hViq-sttjx0f8e-LEW3-E")
       // GMSMap
        if(userInfoLogin.accesstoken != ""){
            guard let rootVC = window?.rootViewController else { return false }
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVCV2")
            
            vc.view.frame = rootVC.view.frame
            vc.view.layoutIfNeeded()
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = vc
                
            }, completion: { (Bool) in
                let storyBoard1 = UIStoryboard(name: "TripManagement", bundle: nil)
                let trip = storyBoard1.instantiateViewController(withIdentifier: "TripMangementVC")
                vc.present(trip, animated: false, completion: nil)
            })
        }
        else{
        guard let rootVC = window?.rootViewController else { return false }
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVCV2")
        
        vc.view.frame = rootVC.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = vc
        }, completion: nil)
    }
        return true
}

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

