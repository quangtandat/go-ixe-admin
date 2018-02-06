//
//  Model.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/2/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class UserLoginModel: NSObject,NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(accesstoken, forKey: "accesstoken")
        aCoder.encode(userType, forKey: "userType")
    }
    
    var username: String 
    var accesstoken: String
    var userType: String
    
    init(username:String, accesstoken:String,userType:String) {
        self.username = username
        self.accesstoken = accesstoken
        self.userType = userType
    }
    required init(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: "username") as! String
        accesstoken = aDecoder.decodeObject(forKey: "accesstoken") as! String
        userType = aDecoder.decodeObject(forKey: "userType") as! String
    }
    
  
}
struct Address {
    var street: String!
    var subStreet: String!
    var type: String!
    var latitude: Double!
    var longtitude: Double!
    
    init(street: String, subStreet: String, type: String, lat: Double, long: Double) {
        self.street = street
        self.subStreet = subStreet
        self.type = type
        self.latitude = lat
        self.longtitude = long
    }
}
