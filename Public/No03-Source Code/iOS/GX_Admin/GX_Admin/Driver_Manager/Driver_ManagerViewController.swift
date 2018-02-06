//
//  Driver_ManagerViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/5/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class Driver_ManagerViewController: UIViewController {

    var leftMenuView: LeftMenuView!
    var window: UIWindow?
    var api:GxApiClient? = nil
    var userInfoLogin:UserLoginModel? = nil
    var commonClass = CommonClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotification()
        self.addNibFile()
        api = GxApiClient()
        self.userInfoLogin = commonClass.loadRememberedUser()
    }
    @objc func driverViewTap(_:NSNotification){
        let storyBoardSetting = UIStoryboard(name: "Driver_Manager", bundle: nil)
        let settingView = storyBoardSetting.instantiateViewController(withIdentifier: "Driver_ManagerViewController")
        self.present(settingView, animated: true, completion: nil)
    }
    @objc func settingViewTap(_:NSNotification){
        let storyBoardSetting = UIStoryboard(name: "Setting", bundle: nil)
        let settingView = storyBoardSetting.instantiateViewController(withIdentifier: "SettingNaV")
        self.present(settingView, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(driverViewTap(_:)), name: NSNotification.Name(rawValue: "driverTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkInternet(_:)), name: NSNotification.Name(rawValue: "logOutTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingViewTap(_:)), name: NSNotification.Name(rawValue: "settingViewTap"), object: nil)
    }
    @objc func checkInternet(_:NSNotification) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func buttonMenu_Pressed(_ sender: Any) {
        self.leftMenuView.isHidden = false
        self.moveMenuLeftView()
    }
}

extension Driver_ManagerViewController {
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideMenuLeftView), name: NSNotification.Name(rawValue: "hideMenuLeftView"), object: nil)
    }
    
    
    fileprivate func addNibFile() {
        self.leftMenuView = UINib(nibName: "LeftMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LeftMenuView
        self.leftMenuView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(leftMenuView)
        self.leftMenuView.isHidden = true
        
        self.animationNibFile()
    }
    
    private func animationNibFile() {
        leftMenuView.viewMenu.layer.transform = CATransform3DMakeTranslation(-500, 0, 0)
        leftMenuView.viewBlur.alpha = 0.0
    }
    
    fileprivate func moveMenuLeftView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.leftMenuView.viewMenu.layer.transform = CATransform3DIdentity
            
            self.leftMenuView.viewBlur.alpha = 0.7
        }, completion: {(Bool) in
            self.api?.apiGetUserInfo(userType: (self.userInfoLogin?.userType)!, success: {(json) in
                self.leftMenuView.txtName.text = json["first_name"] as? String
            }, failure: {() in
                
            })
        })
    }
    
    @objc func hideMenuLeftView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.leftMenuView.viewMenu.layer.transform = CATransform3DMakeTranslation(-500, 0, 0)
            self.leftMenuView.viewBlur.alpha = 0.0
        }) { (finished) in
            self.leftMenuView.isHidden = true
        }
    }

}
