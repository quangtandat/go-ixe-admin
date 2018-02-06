//
//  DriverNavigationViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/9/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class DriverNavigationViewController: UINavigationController {
var driverInfoDetail:DriverModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let driverVC = self.topViewController as! DriverDetailViewController
        driverVC.driverInfoDetail = driverInfoDetail
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
