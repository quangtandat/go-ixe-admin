//
//  DriverCollectionCellCollectionViewCell.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/5/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class DriverCollectionCellCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var lblTypeDriver: UILabel!
    @IBOutlet weak var lblCreateDate: UILabel!
    
    @IBOutlet weak var lblID: UILabel!
   
    @IBOutlet weak var txtName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
