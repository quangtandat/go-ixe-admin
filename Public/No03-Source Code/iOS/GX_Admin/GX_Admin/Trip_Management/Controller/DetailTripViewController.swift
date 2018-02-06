//
//  DetailTripViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/9/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class DetailTripViewController: UIViewController {

    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var lblEstimateFare: UILabel!
    @IBOutlet weak var btnsetTrip: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblnameEn: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    var api:GxApiClient? = nil
    var commonClass = CommonClass()
    var tripInfoDetail:TripModel? = nil
    
    @IBAction func btnSetTripTap(_ sender: Any) {
//        let sendDriver = UINib(nibName: "Senddriver", bundle: nil).instantiate(withOwner: nil, options: nil).first as! Senddriver
//       // sendDriver.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        sendDriver.center = self.view.convert(self.view.center, from: sendDriver)
//
//        sendDriver.frame.origin.y = self.view.frame.origin.y + 100
//        sendDriver.frame.size.height = self.view.frame.size.height - 200
//        sendDriver.frame.origin.x =  30
//        sendDriver.frame.size.width = self.view.frame.size.width - 60
         NotificationCenter.default.post(name: Notification.Name(rawValue: "viewBlurShow"), object: nil)
      
//        let blurView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        blurView.backgroundColor = .black
//        blurView.alpha = 0.5
//        self.view.addSubview(blurView)
       //self.view.addSubview(sendDriver)

        
     //   booking, waitto accept driver,
    }
    @IBAction func btnBackTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        let currency = commonClass.convertDoubleToCurrency(number: (tripInfoDetail?.estimate_fare! as! NSNumber))
        self.lblStart.text = tripInfoDetail?.start_address
        self.lblEnd.text = tripInfoDetail?.end_address
        self.lblDate.text = commonClass.changeToVietnamDate(value: (tripInfoDetail?.request_time)!)
        self.lblType.text = tripInfoDetail?.payment_type
        self.lblnameEn.text = tripInfoDetail?.request_id
        self.lblEstimateFare.text = NSLocalizedString("Price:  ", comment: "") + currency + "VND"
        if tripInfoDetail?.promo_code != ""{
            self.lblPromoCode.text = tripInfoDetail?.promo_code
        }
        else{
            self.lblPromoCode.text = NSLocalizedString("No promotion  ", comment: "")
        }
        self.lblStatus.text = TripModel.status[(tripInfoDetail?.status)!]
        switch(self.lblStatus.text!){
        case "Waiting":
            lblStatus.backgroundColor = UIColor.init(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
            
        case "On driving":
            lblStatus.backgroundColor = UIColor.init(red: 51/255, green: 122/255, blue: 183/255, alpha: 1)
            
        case "Complete":
            lblStatus.backgroundColor = UIColor.init(red: 0/255, green: 166/255, blue: 90/255, alpha: 1)
            
        case "Cancel":
            lblStatus.backgroundColor = UIColor.init(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
            
        case "On driving":
            lblStatus.backgroundColor = UIColor.init(red: 0/255, green: 192/255, blue: 239/225, alpha: 1)
        case "Booking":
            lblStatus.backgroundColor = UIColor.init(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
        default:
            break
        }
        if tripInfoDetail?.status == "BOOKING" && tripInfoDetail?.request_type == "1"{
            self.btnsetTrip.isHidden = false
        }
        else if tripInfoDetail?.status == "WAIT_TO_ACCEPT_BY_DRIVER"{
            self.btnsetTrip.isHidden = false
        }
        else{
            self.btnsetTrip.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
//(tripInfoDetail?.status)! == "WAIT_TO_ACCEPT_BY_DRIVER" || tripInfoDetail?.request_type == "1"
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
