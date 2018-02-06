//
//  TripModel.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/7/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class TripModel {
    public static let status = ["COMPLETED_SUBMIT_BY_RIDER" : "Complete",
                                "COMPLETED_WAIT_TO_CONFIRM_DEAL_FARE_BY_RIDER":"Complete",
                                "COMPLETED_ACCEPT_DEAL_FARE_BY_RIDER":"Complete",
                                "COMPLETED_DENY_DEAL_FARE_BY_RIDER":"Complete",
                                "COMPLETED" : "Complete",
                                "BOOKING" : "Booking",
                                "ON_RIDE": "On driving",
                            "WAIT_TO_ACCEPT_BY_DRIVER":"Waiting",
                                "WAIT_TO_ACCEPT_BY_DRIVER_TIME_OUT": "Waiting",
                                "CANCEL_DRIVER_ARRIVING_BY_RIDER" : "Cancel",
                                "CANCEL_DRIVER_ARRIVING_BY_DRIVER" : "Cancel",
                                "CANCEL_WAIT_TO_ACCEPT_BY_RIDER" : "Cancel",
                             
                                "CANCEL_WAIT_TO_ACCEPT_BY_ADMIN":"Cancel",
                                "CANCEL_WAIT_TO_ACCEPT_BY_DRIVER":"Cancel",
                                "huỷ":"None",
                                "DRIVER_ARRIVING_ASSIGN_BY_ADMIN":"On driving",
        "DRIVER_ARRIVING":"On driving"
    ]
    var request_id:String?
    var m_driver_id:String?
    var m_rider_id:String?
    var start_latitude:Double?
    var start_longitude:Double?
    var start_address:String?
    var end_latitude:Double?
    var end_longitude:Double?
    var end_address:String?
    var driver_candidates:String?
    var request_type:String?
    var pick_up_time:String?
    var promo_code:String?
    var promo_cost:Double?
    var estimate_fare:Double?
    var estimate_time:String?
    var estimate_distance:String?
    var estimate_commission_ratio:String?
    var estimate_commission_money:String?
    var payment_type:String?
    var status:String?
    var m_product_province_id:String?
    var note:String?
    var request_time:String?
    var rate_for_driver:String?
    var rate_for_rider:String?
    var leave_comment:String?
    var distance:String?
    var total_charged:String?
    var duration:String?
    var rider_mobile:String?
    var rider_name:String?
    var driver_mobile:String?
    var driver_name:String?
    init(json:[String:Any]) {
        if !json.isEmpty {
            request_id = json["request_id"] as? String
            pick_up_time = json["pick_up_time"] as? String
            m_driver_id = json["m_driver_id"] as? String
            start_latitude = (json["start_latitude"] as? NSString)?.doubleValue
            start_longitude = (json["start_longitude"] as? NSString)?.doubleValue
            start_address = (json["start_address"] as? String)
            end_latitude = (json["end_latitude"] as? NSString)?.doubleValue
            end_longitude = (json["end_longitude"] as? NSString)?.doubleValue
            end_address = json["end_address"] as? String
            driver_candidates = json["driver_candidates"] as? String
            request_type = (json["request_type"] as? String)
            promo_code = (json["promo_code"] as? String)
            promo_cost = (json["promo_cost"] as? NSString)?.doubleValue
            estimate_fare = (json["estimate_fare"] as? NSString)?.doubleValue
            
            estimate_time = json["estimate_time"] as? String
            estimate_distance = json["estimate_distance"] as? String
            estimate_commission_ratio = json["estimate_commission_ratio"] as? String
            
            estimate_commission_money = json["estimate_commission_money"] as? String
            payment_type = json["payment_type"] as? String
            status = json["status"] as? String
            m_product_province_id = json["m_product_province_id"] as? String
            note = json["note"] as? String
            request_time = json["request_time"] as? String
            estimate_commission_money = json["estimate_commission_money"] as? String
            payment_type = json["payment_type"] as? String
            rate_for_driver = json["rate_for_driver"] as? String
            rate_for_rider = json["rate_for_rider"] as? String
            leave_comment = json["leave_comment"] as? String
            distance = json["distance"] as? String
            total_charged = json["total_charged"] as? String
            duration = json["duration"] as? String
            rider_mobile = json["rider_mobile"] as? String
            rider_name = json["rider_name"] as? String
            driver_mobile = json["driver_mobile"] as? String
            driver_name = json["driver_name"] as? String
        }
    }
}
