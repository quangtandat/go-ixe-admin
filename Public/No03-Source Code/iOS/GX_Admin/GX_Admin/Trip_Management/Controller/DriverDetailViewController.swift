//
//  DriverDetailViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/9/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class DriverDetailViewController: UIViewController {
    var driverInfoDetail:DriverModel? = nil
    
    @IBOutlet weak var txtId: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtStatus: UITextField!
/**
    viewDidLoad()


    - Todo: set up UI get data

    - Author: Quang Tan Dat
**/
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.txtId.text = driverInfoDetail?.id
        self.txtName.text = driverInfoDetail?.first_name
        self.txtPhone.text = driverInfoDetail?.mobile
        let status = driverInfoDetail?.status
        switch (status){
        case "VERIFY_SPENDING"?:
            self.txtStatus.text = "Chờ xác nhận"
        case "ACTIVATED"?:
            self.txtStatus.text = "Đã kích hoạt"
        case "TRIAL"?:
            self.txtStatus.text = "Dùng thử"
        case "DEACTIVED"?:
            self.txtStatus.text = "Ngưng kích hoạt"
        case "VERIFIED"?:
            self.txtStatus.text = "Đã xác nhận"
        case .none:
            break;
        case .some(_):
            break;
        }
       
    }
/**
    btnBackTap


    - Todo: back to driver management screen

    - Author: Quang Tan Dat
**/

    @IBAction func btnBackTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
