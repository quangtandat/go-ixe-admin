//
//  TripCollectionViewCell.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/5/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var viewDistance: UIView!
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var viewDate: UIView!
    
    @IBOutlet weak var viewPrice: UIView!
    
    @IBOutlet weak var viewDiscount: UIView!
    
    @IBOutlet weak var labelDistance: UILabel!
    
    @IBOutlet weak var lblFare: UILabel!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewInfomation: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtStart: UILabel!
    @IBOutlet weak var txtDes: UILabel!
    
    @IBOutlet weak var txtTime: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.viewDistance.layer.borderWidth = 0.5
        self.viewDistance.layer.borderColor = UIColor.black.cgColor
        self.viewPrice.layer.borderWidth = 0.5
        self.viewPrice.layer.borderColor = UIColor.black.cgColor
        self.viewDiscount.layer.borderWidth = 0.5
        self.viewDiscount.layer.borderColor = UIColor.black.cgColor
        self.viewDate.layer.borderWidth = 0.5
        self.viewDate.layer.borderColor = UIColor.black.cgColor
        self.viewInfomation.layer.borderWidth = 1
        self.viewInfomation.layer.borderColor = UIColor.black.cgColor
        self.frame.size.height = 200
    }

}

