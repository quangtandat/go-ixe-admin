//
//  GoogleMapHelper.swift
//  GXRider
//
//  Created by Phong Nguyen on 2/27/17.
//  Copyright © 2017 Phong Nguyen. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import Alamofire

var gms = GMSPath()
var animationPolyline = GMSPolyline()
var animationPath = GMSMutablePath()
var arrayAnimationPolyline = Array<GMSPolyline>()
var i: UInt = 0
var isCancelTimer: Bool = false

class GoogleMapHelper {
    
    var cachedMap: GMSMapView!
    
    //Main
    var timerMainPolyline: Timer!
    
    var timerPolyline: Timer!
    var timerPause: Timer!
    var multipleMarker: [GMSMarker] = [GMSMarker]()
    
    //On-Ride Status
    var timerOnRidePolyline: Timer!
    var timerPauseOnRide: Timer!
    //
    var timerDistractPolyline: Timer!
    
    init() {
        
    }
    
    
    
    // MARK: - Search Address
    public static func searchPlace(location : CLLocationCoordinate2D!, region: String , type: String,query: String, success: @escaping ([String : Any]) -> ())  {
        let parameters: Parameters = ["location" : (String(location.latitude) + "," + String(location.longitude)),
                                      "region" : region ,
                                      "query" : query,
                                      "radius" : "50000",
                                      "type" : type,
                                      "key" : "AIzaSyAbwZX27pHfu1hViq-sttjx0f8e-LEW3-E"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/textsearch/json",method : .get, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    guard let json = response.result.value as? [String: Any] else { return }
                    success(json)
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
    
    
    
}
