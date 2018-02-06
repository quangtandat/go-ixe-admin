//
//  choseDriverTableViewCell.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/10/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit

class choseDriverTableViewCell: UITableViewCell {

   
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var isOnline: UILabel!
    @IBOutlet weak var imageAvartar: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
