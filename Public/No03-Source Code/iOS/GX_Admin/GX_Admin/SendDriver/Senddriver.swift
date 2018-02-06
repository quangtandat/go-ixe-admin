//
//  Senddriver.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/10/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import Firebase
let identifier = "Cell"
 var driverArray:[DriverModel]? = [DriverModel]();

class Senddriver: UIView {
    var tripDetail:TripModel? = nil
     var api:GxApiClient? = nil
     var userInfoLogin:UserLoginModel? = nil
     var commonClass = CommonClass()
    var m_product_id = ""
    var ref:DatabaseReference? = nil
    var refLocation:DatabaseReference? = nil
    @IBOutlet weak var tableView: UITableView!
/**
    awakeFromNib


    - Todo: set up UI get data

    - Author: Quang Tan Dat
**/
    
        override func awakeFromNib() {
          driverArray?.removeAll()
       checkOnlineUser()
             api = GxApiClient()
             self.userInfoLogin = commonClass.loadRememberedUser()
        tableView.dataSource = self
            tableView.delegate = self
            self.layer.cornerRadius = 30
            self.layer.borderWidth = 1
    // call api apiGetUserInfo to get province name, after that call api apiGetDriverList to get driver
            api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
                let userInfo = UserInfo.init(json: json)
                self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: self.m_product_id, search: "", status: "", page: "0", rowperPage:"1000", success: {(json) in
                    let result = json["result"] as! NSArray
                    for var i:[String:Any] in (result as! [[String:Any]]){
             // admin only set trip to driver with verify, trial and activated
                        if (i["status"] as? String == "VERIFY" || i["status"] as? String  == "TRIAL"||i["status"] as? String  == "ACTIVATED") {
                       
                        let driverInfo = DriverModel.init(json: i as! [String : Any])
                        driverArray?.append(driverInfo)
                        }
                    }
                  
                    self.tableView.reloadData()
                }, failure:{() in
                    
                })
            }, failure: {() in
                
            })
            
            self.backgroundColor = .clear
            tableView.register(UINib(nibName: "choseDriverTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
          
    }
/**
    getDetailTrip


    - Todo: set reference to firebase to get detail trip

    - Author: Quang Tan Dat
**/
    
    func getDetailTrip(){
        
         ref = Database.database().reference().child("request").child((tripDetail?.request_id)!)
    }
/**
     checkOnlineUser
     
     
     - Todo: set reference to firebase to get user online
     
     - Author: Quang Tan Dat
**/
    func checkOnlineUser(){
        refLocation = Database.database().reference().child("location")
       
            
    }
}
extension Senddriver:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
       
        
            
        return driverArray!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? choseDriverTableViewCell
        cell?.lblName.text = driverArray?[indexPath.row].first_name
        cell?.lblType.text = driverArray?[indexPath.row].name_lo
        
        cell?.lblRate.text = driverArray?[indexPath.row].mobile
     //obseve if firebase has node of driver it will notify that user is online
        refLocation?.child("drivers").observeSingleEvent(of: .value, with: { (snapshot) in
          
            let id = driverArray![indexPath.row].id! + "," + driverArray![indexPath.row].name_en!
               // if snapshot has child it will know user is online
                if snapshot.hasChild(id){
                    let onlineID = driverArray![indexPath.row]
                    driverArray?.remove(at: indexPath.row)
                    driverArray?.insert(onlineID, at: 0)
            // change UI
                    cell?.onlineView.backgroundColor = .green
                    cell?.onlineView.clipsToBounds = true
                   
                    cell?.onlineView.layer.cornerRadius =  (cell?.onlineView.frame.size.width)!/2

                    
                //else user will be notified is offline and change UI
                }else{
                     cell?.onlineView.layer.cornerRadius =  (cell?.onlineView.frame.size.width)!/2
                 
                     cell?.onlineView.backgroundColor = .red
                     cell?.onlineView.clipsToBounds = true
                    
                    
                }
            
        })

        return cell!
    }
}
extension Senddriver:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if status of trip is booking update on firebase status is BOOKING
        if (tripDetail?.status == "BOOKING"){
             let actionOK  = UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
             let refOnlineDriver = Database.database().reference().child("users_online").child("drivers").child(driverArray![indexPath.row].id!)
          refOnlineDriver.observeSingleEvent(of: .value, with: {(snapshot) in
            refOnlineDriver.child("request_candidates").updateChildValues([(self.tripDetail?.request_id)!:self.tripDetail?.request_id])
            self.api?.assignTrip(m_driver_id: (driverArray?[indexPath.row].id)!, request_id: (self.tripDetail?.request_id)!, status: "BOOKING", success: {(json) in
                self.ref?.updateChildValues(["status":"BOOKING"])
            }, failure: {() in
                
            })
            })
             })
            let actionNot  = UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
            })
            CommonClass.showAlert(NSLocalizedString("Thông báo", comment: ""), message:NSLocalizedString("Bạn đã chắc chắn chưa", comment: ""), actions:[actionOK,actionNot],viewController: self.next?.next as! TripNavigationViewController )
            
        }
            // if status of trip is WAITING with request type = 1 change sttus on firebase is DRIVER_ARRIVING_ASSIGN_BY_ADMIN
        else{
            let actionOK  = UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
           
            let refOnlineDriver = Database.database().reference().child("users_online").child("drivers").child(driverArray![indexPath.row].id!)
            refOnlineDriver.observeSingleEvent(of: .value, with: {(snapshot) in
                refOnlineDriver.child("request_candidates").updateChildValues([(self.tripDetail?.request_id)!:self.tripDetail?.request_id])
                    self.api?.assignTrip(m_driver_id: (driverArray?[indexPath.row].id)!, request_id: (self.tripDetail?.request_id)!, status: "DRIVER_ARRIVING_ASSIGN_BY_ADMIN", success: {(json) in
                        self.ref?.updateChildValues(["status":"DRIVER_ARRIVING_ASSIGN_BY_ADMIN"])
                        
                    }, failure: {() in
                })
            })
        })
            let actionNot  = UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
            })
            CommonClass.showAlert("Alert", message:"Are you sure", actions:[actionOK,actionNot],viewController: self.next?.next as! TripNavigationViewController )
        }
    }
}
