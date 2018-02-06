//
//  SettingViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/4/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import GooglePlacePicker
class SettingViewController: UIViewController {
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var labelDes: UILabel!
    var commonClass: CommonClass? = nil
    @IBOutlet weak var txtWork: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtName: UITextField!
     @IBOutlet weak var labelTitlUILabelal: UILabel!
  var reachability:DXReachabilitySwift? = DXReachabilitySwift.networkReachabilityForInternetConnection()
    var userInfo:UserInfo? = nil
    var userInfoLogin:UserLoginModel? = nil
    var api:GxApiClient? = nil
/**
    viewDidLoad()


    - Todo: setup UI

    - Author: Quang Tan Dat
**/
    
    override func viewDidLoad() {
        super.viewDidLoad()
         labelTitlUILabelal.text = NSLocalizedString("Personal", comment: "")
        commonClass = CommonClass()
         api = GxApiClient.init()
        userInfoLogin = self.commonClass?.loadRememberedUser()
        if (userInfoLogin?.userType == "staff"){
            self.labelDes.text = "Home"
        }
         placesClient = GMSPlacesClient.shared()
        txtWork.addTarget(self, action:#selector(textDidBeginEditing), for: UIControlEvents.editingDidBegin)
        
    }
/**
    check()


    - Todo: check network

    - Author: Quang Tan Dat

    - Returns: Boolean
**/
   
    func check()->Bool{
        guard let r = reachability else {
            return false
        }
        if r.isReachable  {
            return true
        } else {
            return false
        }
    }
/**
    viewWillAppear


    - Todo: setup UI and get data

    - Author: Quang Tan Dat
**/
    
    override func viewWillAppear(_ animated: Bool) {
        
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)! , success: {(json) in
            self.userInfo = UserInfo.init(json: json)
            
            self.txtPhone.text = self.userInfo?.mobile!
            self.txtName.text = self.userInfo?.firstname
            // if usertype in nsuser default is "company" -> set up UI
                if (self.userInfoLogin?.userType == "company"){
                    self.txtWork.text = self.userInfo?.workAddress
            }
                    // if usertype in nsuser default is "staff" -> set up UI
                else{
                    self.txtWork.text = self.userInfo?.homeAddress
            }
            
        }, failure: {() in
            
        })
    }
/**
    textDidBeginEditing()


    - Todo: call api google place

    - Author: Quang Tan Dat
**/
    
    @objc func textDidBeginEditing()
    {
        self.view.endEditing(true)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Setting", bundle:nil)
//        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "SearchAddressViewController") as! SearchAddressViewController
//
//        self.present(resultViewController, animated:true, completion:nil)
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.txtWork.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
                self.view.endEditing(true)
            } else {
                self.txtWork.text = "No place selected"
                self.view.endEditing(true)
            }
        })
    }


/**
    btnSaveTap


    - Todo: update profile user

    - Author: Quang Tan Dat
**/
    
    @IBAction func btnSaveTap(_ sender: Any) {
        if !check(){
            let actionNot  = UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
                
                
            })
            CommonClass.showAlert("Alert", message:"Check your network", actions:[actionNot],viewController: self)
        }
        else{
            // if user info is "company" = call api with diffrent parameter
       if (userInfoLogin?.userType == "company"){
         let actionNO = UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
            self.api?.apiUpdateUserInfo(firstName: self.txtName.text!, mobile: self.txtPhone.text!, workAddress: self.txtWork.text!, workLat: (self.userInfo?.workLat)!, workLong: (self.userInfo?.workLong)!, password: (self.userInfo?.password)!, homLat: (self.userInfo?.homeLat)!, homeLong: (self.userInfo?.homeLong)!, homeAddress: (self.userInfo?.homeAddress)!, success: {(json) in
            print(json)
        
        }, failure: {() in
            
        })
         })
        let actionNot  = UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in

        })
        CommonClass.showAlert("Alert", message:"Do you want to save ", actions:[actionNO,actionNot],viewController: self)
       }
           // if user info is "staff" = call api with diffrent parameter
       else{
        let actionNO = UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
            
            self.api?.apiUpdateUserInfo(firstName: self.txtName.text!, mobile: self.txtPhone.text!, workAddress: (self.userInfo?.workAddress)!, workLat: (self.userInfo?.workLat)!, workLong: (self.userInfo?.workLong)!, password: (self.userInfo?.password)!, homLat: (self.userInfo?.homeLat)!, homeLong: (self.userInfo?.homeLong)!, homeAddress: self.txtWork.text!, success: {(json) in
                
                
            }, failure: {() in
                
            })
        })
        let actionNot  = UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
            
         
        })
        CommonClass.showAlert("Alert", message:"Do you want to save", actions:[actionNO,actionNot],viewController: self)
        }
        }
    }
/**
    btnBackTap


    - Todo: back to previous screen

    - Author: Quang Tan Dat
**/
    
    @IBAction func btnBackTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenuLeftView"), object: nil)
        self.dismiss(animated: true, completion:nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
