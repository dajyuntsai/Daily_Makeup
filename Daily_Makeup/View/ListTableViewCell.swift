//
//  ListTableViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/1.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var productImage: UIImageView!
    
    
    @IBOutlet var productBrand: UILabel!
    
    @IBOutlet var productTitle: UILabel!
    
    @IBOutlet var productColorTone: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

