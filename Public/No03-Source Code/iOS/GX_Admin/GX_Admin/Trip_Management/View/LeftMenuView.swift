//
//  LeftMenuView.swift
//  GX_Admin
//
//  Created by Iam H on 1/3/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuView: UIView {
    
    @IBOutlet weak var txtName: UILabel!
    var user = UserLoginModel.init(username: "", accesstoken: "", userType: "")
   
    let savedUserKey = "savedUser"
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewBlur: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var btnTripTap: UIButton!
/**
     btnTripTap
     
     
     - Todo: action when tap button trip in left menu
     
     - Author: Quang Tan Dat
**/
    @IBAction func btnTripTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenuLeftView"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tripTap"), object: nil)
    }
/**
    btnDriverTap


    - Todo: action when tap button driver in left menu

    - Author: Quang Tan Dat
**/
    
    @IBAction func btnDriverTap(_ sender: Any) {
       
  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenuLeftView"), object: nil)
         NotificationCenter.default.post(name: Notification.Name(rawValue: "driverTap"), object: nil)
    }
/**
    viewBlur_Pressed


    - Todo: action when tap view blur

    - Author: Quang Tan Dat
**/
    
    @IBAction func viewBlur_Pressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenuLeftView"), object: nil)
    }
/**
     btnSignOutTap
     
     
     - Todo: action when tap button log out in left menu
     
     - Author: Quang Tan Dat
**/
    @IBAction func btnSignOutTap(_ sender: Any) {
        
       
        if let decodedNSDataBlob = UserDefaults.standard.object(forKey: savedUserKey) as? NSData {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
                
            
        }
         NotificationCenter.default.post(name: Notification.Name(rawValue: "logOutTap"), object: nil)
    }
    
/**
    settingViewTap


    - Todo: action when tap button setting in left menu

    - Author: Quang Tan Dat
**/
 
    @IBAction func settingViewTap(_ sender: Any) {
         NotificationCenter.default.post(name: Notification.Name(rawValue: "settingViewTap"), object: nil)
      
    }
    
}
