//
//  UserInfo.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/4/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class UserInfo {
    var id: String!
    var m_company_id: String!
    var user_name:String!
    var email: String!
    var gcm_regid: String!
    var imei: String!
    var password: String!
    var firstname: String!
    var mobile: String!
    var userType: String!
    var isOnline: String!
    var introduceCode: String!
    var rate: String!
    var lastLoginAddress: String!
    var homeLat: Double!
    var homeLong: Double!
    var homeAddress: String!
    var workLat: Double!
    var workLong: Double!
    var workAddress: String!
    var promoCode: String!
    var code: String!
    var provideName: String!
    var placeId: String!
   
    
    init(json: [String: Any]) {
        if !json.isEmpty {
            id = json["id"] as! String
            m_company_id = json["m_company_id"] as! String
            email = json["email"] as! String
            user_name = json["user_name"] as! String
            gcm_regid = json["gcm_regid"] as! String
            imei = (json["imei"] as! String)
            firstname = (json["first_name"] as! String)
            password = (json["password"] as! String)
            mobile = json["mobile"] as! String
            userType = json["user_type"] as! String
            isOnline = (json["is_online"] as! String)
            introduceCode = (json["introduce_code"] as! String)
            rate = json["rate"] as! String
            lastLoginAddress = json["last_login_address"] as! String
            homeLat = (json["home_latitude"] as! NSString).doubleValue
            homeLong = (json["home_longitude"] as! NSString).doubleValue
            homeAddress = json["home_address"] as! String
            workLat = (json["work_latitude"] as! NSString).doubleValue
            workLong = (json["work_longitude"] as! NSString).doubleValue
            workAddress = (json["work_address"] as! String)
            promoCode = json["promo_code"] as! String
            code = json["code"] as! String
            provideName = json["province_name"] as! String
            placeId = json["place_id"] as! String
            
        }
    }
}
