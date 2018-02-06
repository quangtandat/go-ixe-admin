//
//  SigninViewController.swift
//  GX_Admin
//
//  Created by Iam H on 1/3/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import CryptoSwift
class SigninViewController: UIViewController {
    var reachability:DXReachabilitySwift? = DXReachabilitySwift.networkReachabilityForInternetConnection()
    var commonClass:CommonClass? = nil
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    var api:GxApiClient? = nil
    var activityView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        api = GxApiClient.init()
        commonClass = CommonClass()
        
    }
/**
    viewWillAppear


    - Todo: setup UI

    - Author: Quang Tan Dat
**/
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: "token") != nil){
            self.view.isHidden = true
        }
        else{
            self.view.isHidden = false
        }
    }
/**
    buttonLogin_Pressed


    - Todo: action when tap button login

    - Author: Quang Tan Dat
**/
    
    @IBAction func buttonLogin_Pressed(_ sender: Any) {
        if !check(){
            let actionNot  = UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
                
                
            })
            CommonClass.showAlert("Alert", message:NSLocalizedString("No internet connection. Please try again !", comment: ""), actions:[actionNot],viewController: self)
        }
        else{
            showActivity()
           //if email and password is not empty check email if it vaild
            if (self.textfieldEmail.text != "" || self.textfieldPassword.text != ""){
              
                if(!CommonClass.checkValidEmail(username: textfieldEmail.text!)){
                    alertShow(title: "Login Failed", meassage: NSLocalizedString("Email is invalid", comment: ""))
                }
        // if email is vaild encrypt password and call api login to get userType. after that call call api authen set usertype and get all user infomation
                else{
                    let encryptPassword = Encrypt.encript(input: textfieldPassword.text)
                    api?.apiLogin(username: textfieldEmail.text!, password: encryptPassword, success: {(json) in
                        let userType = json["user_type"] as? String
                        self.api?.apiAuthen(user_name: self.textfieldEmail.text!, password: encryptPassword, user_type: userType!, success: {(json) in
                            self.hideActivity()
                            let user = UserLoginModel.init(username: json["user_name"] as! String, accesstoken: json["access_token"] as! String, userType: json["user_type"] as! String)
                            // save session
                            self.commonClass?.rememberUser(newUser: user)
                            //move to trip view controller
                            self.presentToTripManagementVC()
                        }, failure: {() in
                            self.hideActivity()
                        })
                        // something wrong with api
                    }, failure: {() in
                        self.hideActivity()
                        self.alertShow(title: "Thông báo", meassage: "Email và Password không đúng")
                        
                    })
                }
            }
            else{ // if email and password empty show alert
                hideActivity()
                alertShow(title: "Thông báo", meassage: "Email và Password không được để trống")
            }
        }
    }
/**
    alertShow

    - Parameter title: title of alert
    - Parameter meassage: message of alert

    - Todo: show alert

    - Author: Quang Tan Dat
**/
    
    func alertShow(title:String, meassage:String){
        let actionNO = UIAlertAction(title: "ok", style: .cancel, handler: {(action:UIAlertAction) in
        })
        CommonClass.showAlert(title, message:meassage, actions:[actionNO],viewController: self)
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
    showActivity()


    - Todo: show loading with indicator

    - Author: Quang Tan Dat
**/
    
    func showActivity() {
        activityView = UIButton(frame: CGRect.init(x: 0, y: -100, width: self.view.frame.width, height: self.view.frame.height - 20))
        activityView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityView?.alpha = 0.2
        
        let progressActivity =
            
            commonClass?.progressBarDisplayer(msg : NSLocalizedString("Loading...", comment: ""), true, view : self.view)
        
        activityView?.addSubview(progressActivity!)
        view.addSubview(activityView!)
    }
/**
    hideActivity()


    - Todo: hide loading with indicator

    - Author: Quang Tan Dat
**/
    
    func hideActivity() {
        self.activityView?.isHidden = true
    }
  
}

extension SigninViewController {

/**
    presentToTripManagementVC


    - Todo: go to trip management screen

    - Author: Quang Tan Dat
**/
    
    fileprivate func presentToTripManagementVC() {
        let storyBoard = UIStoryboard(name: "TripManagement", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TripMangementVC")
        
        self.present(vc, animated: true, completion: nil)
    }
  
}

