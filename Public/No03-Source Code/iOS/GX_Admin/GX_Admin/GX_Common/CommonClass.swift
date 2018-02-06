//
//  CommonClass.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/2/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class CommonClass {
    var user = UserLoginModel.init(username: "", accesstoken: "", userType: "")
    let savedUserKey = "savedUser"
/**
    progressBarDisplayer

    - Parameter msg: message for loading bar

    - Todo: show progress bar with indicator

    - Author: Quang Tan Dat

    - Returns: UIView
**/
    
   func progressBarDisplayer(msg:String, _ indicator:Bool, view : UIView) ->UIView {
        var messageFrame = UIView()
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.font = strLabel.font.withSize(14)
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        return messageFrame
        
    }
/**
    checkValidEmail

    - Parameter username: username

    - Todo: check if username is vaild

    - Author: Quang Tan Dat

    - Returns: Boolean
**/
    
   public static func checkValidEmail(username:String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: username)
    
    }
/**
    showAlert

    - Parameter message: message of alert
    - Parameter actions: action in aleart
    - Parameter viewController: what controller will push this alert

    - Todo: show Alert in view controller

    - Author: Quang Tan Dat
**/
    
   public static func showAlert(_ title: String?, message: String?,actions:[UIAlertAction],viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
/**
    loadRememberedUser


    - Todo: load user from nsuserdefault

    - Author: Quang Tan Dat

    - Returns: UserLoginModel
**/
    
        func loadRememberedUser()-> UserLoginModel{
            if let decodedNSDataBlob = UserDefaults.standard.object(forKey: savedUserKey) as? NSData {
                if let savedUser = NSKeyedUnarchiver.unarchiveObject(with: decodedNSDataBlob as Data) as? UserLoginModel {
                    user = savedUser
                    print(user)
                }
            }
            return user
        }
/**
    rememberUser

    - Parameter newUser: user login model

    - Todo: save seesion of user

    - Author: Quang Tan Dat
**/
    
        func rememberUser(newUser:UserLoginModel){
            user = newUser
            let archivedObject = NSKeyedArchiver.archivedData(withRootObject: newUser)
            let defaults = UserDefaults.standard
            defaults.set(archivedObject, forKey: savedUserKey)
            defaults.synchronize()
        }
/**
    changeToVietnamDate

    - Parameter value: string will be convert

    - Todo: convert to VietName date - HH-mm dd/mm/yyyy

    - Author: Quang Tan Dat

    - Returns: String
**/
    
    func changeToVietnamDate(value: String) -> String {
       
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let transferDate = formatter.date(from: value)
        let calendar = Calendar.current
        if transferDate == nil{
            return value
        }
        else {
            let newDate = calendar.date(byAdding: .hour, value: 7, to: transferDate!)
        let transferFormatter = DateFormatter()
        
        transferFormatter.timeZone = TimeZone(abbreviation: "GMT")
        transferFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
        
        let finalDate = transferFormatter.string(from: newDate!)
        
        return finalDate
        }
    }
/**
    convertDoubleToCurrency

    - Parameter number: number will be convert

    - Todo: convert to viet nam double

    - Author: Quang Tan Dat

    - Returns: String
**/
    
     func convertDoubleToCurrency(number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let string = formatter.string(from: number)
        let currencyString = string?.replacingOccurrences(of: ".", with: ",")
        var currency = ""
        if Locale.current.languageCode!.contains("vi") {
            currency = (currencyString?.replacingOccurrences(of: " ₫", with: ""))!
        } else {
            currency = (currencyString?.replacingOccurrences(of: "₫", with: ""))!
        }
        return currency
    }
}
