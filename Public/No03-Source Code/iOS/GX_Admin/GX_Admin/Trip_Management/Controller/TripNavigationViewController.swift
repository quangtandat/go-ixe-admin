//
//  TripNavigationViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/9/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class TripNavigationViewController: UINavigationController {
    var tapGesture: UITapGestureRecognizer? = nil
    var blurView: UIView? = nil
    var sendDriver:Senddriver? = nil
    var tripInfoDetail:TripModel? = nil
    override func viewDidLoad() {
        let tripVC = self.topViewController as! DetailTripViewController
        tripVC.tripInfoDetail = tripInfoDetail
        NotificationCenter.default.addObserver(self, selector: #selector(viewBlurShow(_:)), name: NSNotification.Name(rawValue: "viewBlurShow"), object: nil)
       
    }
    @objc func viewBlurShow(_:NSNotification){
        
        sendDriver = UINib(nibName: "Senddriver", bundle: nil).instantiate(withOwner: nil, options: nil).first as? Senddriver
        
        sendDriver?.m_product_id = (tripInfoDetail?.m_product_province_id)!
       // sendDriver?.center = self.view.convert(self.view.center, from: sendDriver)
        sendDriver?.tripDetail = tripInfoDetail
        sendDriver?.getDetailTrip()
        
      //  sendDriver?.alpha = 0
        sendDriver?.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.maxY, width: self.view.frame.size.width - 60, height: self.view.frame.size.height - 200)
        
//        sendDriver?.frame.origin.y = self.view.frame.origin.y + 100
//        sendDriver?.frame.size.height = self.view.frame.size.height - 200
//        sendDriver?.frame.origin.x =  30
//        sendDriver?.frame.size.width = self.view.frame.size.width - 60
         tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
            
       
                 blurView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        blurView?.backgroundColor = .black
        blurView?.alpha = 0.5
      
        blurView?.addGestureRecognizer(tapGesture!)
        self.view.addSubview(blurView!)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {() in
         //   self.sendDriver?.alpha = 1
            self.sendDriver?.frame = CGRect.init(x: 30, y: self.view.frame.origin.y + 100, width: self.view.frame.size.width - 60, height: self.view.frame.size.height - 200)
        }, completion: {(Bool) in

        })
        self.view.addSubview(self.sendDriver!)
        
}
    @objc func closePopup(){
        blurView?.removeFromSuperview()
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {() in
           
            self.sendDriver?.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.maxY, width: self.view.frame.size.width - 60, height: self.view.frame.size.height - 200)
        }, completion: {(Bool) in
            self.sendDriver?.removeFromSuperview()
        })
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        if tapGesture != nil{
        self.view.removeGestureRecognizer(tapGesture!)
        }
    }
}
