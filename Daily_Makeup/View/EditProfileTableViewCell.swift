//
//  EditProfileTableViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var profileLabel: UILabel!
    
    
    @IBOutlet var nameTextField: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
