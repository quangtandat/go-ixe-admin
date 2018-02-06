//
//  GxApiClient.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/3/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import Alamofire
class GxApiClient: NSObject {
    let baseURL = "http://go-ixe.com/GXServer/api/"
    var reachability:DXReachabilitySwift? = DXReachabilitySwift.networkReachabilityForInternetConnection()
    var user = UserLoginModel.init(username: "", accesstoken: "", userType: "")
    let savedUserKey = "savedUser"
/**
    header()


    - Todo: Create static header

    - Author: Quang Tan Dat

    - Returns: HTTPHeaders
**/
    
    func header() -> HTTPHeaders{
        // load data from nsuserdefault
        if let decodedNSDataBlob = UserDefaults.standard.object(forKey: savedUserKey) as? NSData {
            if let savedUser = NSKeyedUnarchiver.unarchiveObject(with: decodedNSDataBlob as Data) as? UserLoginModel {
                user = savedUser
            }
        }
        // static header
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authentication" : user.accesstoken
        ]
        return headers
        
    }
/**
    apiAuthen

    - Parameter user_name: username
    - Parameter password: password
    - Parameter user_type: type of user
    - Parameter success: callback when success
    - Parameter [String: callback when fail

    - Todo: api for authen

    - Author: Quang Tan Dat
**/
    
    public func apiAuthen(user_name: String, password: String, user_type: String,success: @escaping ([String:Any]) -> Void,
                                 failure: @escaping () -> Void) {
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "oauth"
        let parameters: Parameters = ["user_name": user_name,
                                      "password": password,
                                      "user_type": user_type,
                                      "gcm_regid":"jk",
                                      "imei":"km"
                                      ]

        Alamofire.request(baseURL + apiName, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let json = response.result.value as? [String:Any]
                    success(json!)
                    }
                else{
                    failure()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
/**
    api login

    - Parameter username: username
    - Parameter password: password
    - Parameter success: call back when success
     - Parameter failure: call back when fail

    - Todo: api Login will send back userType for api authen to use

    - Author: Quang Tan Dat
**/
    
    public func apiLogin(username: String, password: String,success: @escaping ([String:Any]) -> Void,
                          failure: @escaping () -> Void) {
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "permissions/getUserByUserAndPassword?user_name="+username+"&password="+password

        
        Alamofire.request(baseURL + apiName, method: .get,encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let json = response.result.value as? [String:Any]
                    if json != nil{
                    success(json!)
                    }
                    else{
                        failure()
                    }
                }
                else{
                    failure()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
/**
    apiGetUserInfo

    - Parameter userType: user type
    - Parameter success: call back when success
    - Parameter failure: call back when fail

    - Todo: get user info for another api to use

    - Author: Quang Tan Dat
**/
    
    public func apiGetUserInfo(userType:String,success: @escaping ([String:Any]) -> Void,
                         failure: @escaping () -> Void) {
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "me"
        let parameters:Parameters = ["user_type":userType]
        
        Alamofire.request(baseURL + apiName,method : .post,
                          parameters: parameters,
                          encoding : URLEncoding.default,
                          headers: header()).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let json = response.result.value as? [String:Any]
                    if json != nil{
                        success(json!)
                    }
                    else{
                        failure()
                    }
                }
                else{
                    failure()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
/**
    apiGetDriverList

    - Parameter m_company_id: company ID
    - Parameter userType: user type
    - Parameter product: type of product
    - Parameter search: N/a
    - Parameter status: status of driver
    - Parameter page: page will display
    - Parameter rowperPage: number of item in page
    - Parameter success: call back when suceess
    - Parameter failure: call back when fail

    - Todo: get list driver

    - Author: Quang Tan Dat
**/
    
    public func apiGetDriverList(m_company_id:String,userType:String,product:String,search:String, status: String ,page:String,rowperPage:String,success: @escaping ([String:Any]) -> Void,
                               failure: @escaping () -> Void) {
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "admin/getDriversOfCompanywithPagination"
        

        let parameters:Parameters = ["m_company_id":m_company_id,
                                     "user_type":userType,
                                     "rowperPage":rowperPage,
                                     "page":page,
                                     "product":product,
                                     "search": search,
                                     "status": status
                                   
                                                        ]
        
        Alamofire.request(baseURL + apiName,method : .get,
                          parameters: parameters,
                          encoding : URLEncoding.default,
                          headers: header()).responseJSON { (response) in
                            switch response.result {
                            case .success:
                                if response.result.value != nil {
                                    let json = response.result.value as? [String:Any]
                                    if json != nil{
                                        success(json!)
                                    }
                                    else{
                                        failure()
                                    }
                                }
                                else{
                                    failure()
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
    
    
/**
    apiUpdateUserInfo

    - Parameter firstName: first name
    - Parameter mobile: mobile
    - Parameter workAddress: work address
    - Parameter workLat: work latitude
    - Parameter workLong: work longtitude
    - Parameter password: password has been encrypt
    - Parameter homLat: home latitude
    - Parameter homeLong: home longtitude
    - Parameter homeAddress: home address
    - Parameter success: callback when success
    - Parameter fail: callback when fail

    - Todo: update user info -> Setting Screen

    - Author: Quang Tan Dat
**/
    
    
    public func apiUpdateUserInfo(firstName:String,mobile:String,workAddress:String,workLat:Double,workLong:Double,password:String,homLat:Double,homeLong:Double,homeAddress:String,success: @escaping ([String:Any]) -> Void,
                               failure: @escaping () -> Void) {
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "me/updateProfile"
        let parameters:Parameters = ["first_name":firstName,
                                     "mobile":mobile,
                                     "password":password,
                                     "home_latitude":homLat,
                                     "home_longitude":homeLong,
                                    "home_address":homeAddress,
                                    "work_latitude":workLat,
                                    "work_longitude":workLong,
                                    "work_address":workAddress
        
        ]
        
        Alamofire.request(baseURL + apiName,method : .post,
                          parameters: parameters,
                          encoding : URLEncoding.default,
                          headers: header()).responseJSON { (response) in
                            switch response.result {
                            case .success:
                                if response.result.value != nil {
                                    let json = response.result.value as? [String:Any]
                                    if json != nil{
                                        success(json!)
                                    }
                                    else{
                                        failure()
                                    }
                                }
                                else{
                                    failure()
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
/**
    getTripList

    - Parameter m_province_code: province code
    - Parameter product_group_code: product ID
    - Parameter rowperPage: number of item per page
    - Parameter page:  page to display
    - Parameter success: callback when success
    - Parameter failure: callback when fail

    - Todo: get trip list -> Trip Management Sreen

    - Author: Quang Tan Dat
**/
    
    public func getTripList(m_province_code:String,product_group_code:String,rowperPage:String,page:String,success: @escaping ([String:Any]) -> Void,
                            failure: @escaping () -> Void){
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "Requests/getListRequest"
        let parameters:Parameters = ["m_province_code":m_province_code,
             "product_group_code":product_group_code,
             "rowperPage":rowperPage,
             "page":page,

        ]

        Alamofire.request(baseURL + apiName,method : .post,
                          parameters: parameters,
                          encoding : URLEncoding.httpBody,
                          headers: header()).responseJSON { (response) in
                            switch response.result {
                            case .success:
                                if response.result.value != nil {
                                    let json = response.result.value as? [String:Any]
                                    if json != nil{
                                        success(json!)
                                    }
                                    else{
                                        failure()
                                    }
                                }
                                else{
                                    failure()
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
/**
    assignTrip

    - Parameter m_driver_id: driver ID
    - Parameter request_id: request ID
    - Parameter status: status of driver
    - Parameter success: callback when success
    - Parameter failure: callback when fail

    - Todo: assign trip for driver by admin -> Send driver screen

    - Author: Quang Tan Dat
**/
    
    public func assignTrip(m_driver_id:String,request_id:String,status:String,success: @escaping ([String:Any]) -> Void,
                            failure: @escaping () -> Void){
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "requests/assignTripToDriverByAdmin"
        let parameters:Parameters = ["m_driver_id":m_driver_id,
                                     "request_id":request_id,
                                     "status":status,
                                     ]
        
        Alamofire.request(baseURL + apiName,method : .get,
                          parameters: parameters,
                          encoding : URLEncoding.default,
                          headers: header()).responseJSON { (response) in
                            switch response.result {
                            case .success:
                                if response.result.value != nil {
                                    let json = response.result.value as? [String:Any]
                                    if json != nil{
                                        success(json!)
                                    }
                                    else{
                                        failure()
                                    }
                                }
                                else{
                                    failure()
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
/**
    getProduct

    - Parameter provineName: provine name
    - Parameter success: callback when success
    - Parameter failure: callback when fail

    - Todo: get product List in province

    - Author: Quang Tan Dat
**/
    
    public func getProduct(provineName:String,success: @escaping ([[String:Any]]) -> Void,
                           failure: @escaping () -> Void){
        if (!(reachability?.isReachable)!) {
            return
        }
        let apiName = "products/productProvincesByProvinceNameNew"
        let parameters:Parameters = ["province_name":provineName,
                                     ]
        
        Alamofire.request(baseURL + apiName,method : .get,
                          parameters: parameters,
                          encoding : URLEncoding.default,
                          headers: header()).responseJSON { (response) in
                            switch response.result {
                            case .success:
                                if response.result.value != nil {
                                    let json = response.result.value as? [[String:Any]]
                                    if json != nil{
                                        success(json!)
                                    }
                                    else{
                                        failure()
                                    }
                                }
                                else{
                                    failure()
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
}
