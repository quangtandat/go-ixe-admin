//
//  ProductModel.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/23/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class ProductModel {
    var m_product_province_id:String?
    var name_en:String?
    var m_province_code:String?
    init(json:[String:Any]) {
        if !json.isEmpty {
            m_product_province_id = json["m_product_province_id"] as? String
            
            name_en = json["name_en"] as? String
            m_province_code = json["m_province_code"] as? String
}
}
}
