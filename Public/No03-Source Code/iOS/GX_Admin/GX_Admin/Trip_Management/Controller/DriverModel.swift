//
//  DriverModel.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/5/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class DriverModel  {
    var id: String?//
    var code: String?//
    var user_name:String?//
    var email: String?//
    var gcm_regid: String?//
    var first_name: String?//
    var mobile: String?//
    var rate: String?//
    var latitude: Double?//
    var longitude: Double?//
    var user_type: String?//
    var is_online: String?//
    var created: String?//
    var total_money: String?//
    var status: String?//
    var expired: String?//
    var m_product_province_id: String?
    var name_en: String?
    var name_lo: String?
    
    init(json: [String: Any]) {
        if !json.isEmpty {
            id = json["id"] as? String
          
            email = json["email"] as? String
            user_name = json["user_name"] as? String
            gcm_regid = json["gcm_regid"] as? String
            created = (json["created"] as? String)
            first_name = (json["first_name"] as? String)
            total_money = (json["total_money"] as? String)
            mobile = json["mobile"] as? String
            user_type = json["user_type"] as? String
            is_online = (json["is_online"] as? String)
            status = (json["status"] as? String)
            rate = json["rate"] as? String
            expired = json["expired"] as? String
          
            m_product_province_id = json["m_product_province_id"] as? String
            latitude = (json["latitude"] as? NSString)?.doubleValue
            longitude = (json["longitude"] as? NSString)?.doubleValue
          
            code = json["code"] as? String
            name_en = json["name_en"] as? String
            name_lo = json["name_lo"] as? String
            
        }
    }
}
