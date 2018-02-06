//
//  ViewController.swift
//  GX_Admin
//
//  Created by Iam H on 1/2/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
/**
    view did load function
     - Author: Quang Dat 11:32AM 2/1/2018
**/

    override func viewDidLoad() {
        super.viewDidLoad()
//        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(moveToLoginView), userInfo: nil, repeats: false)
    }
/**
    move to Login Page
    - Author: Quang Dat  11:32AM 2/1/2018
**/
    @objc func moveToLoginView(){
   //     let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
     //   self.present(controller, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

