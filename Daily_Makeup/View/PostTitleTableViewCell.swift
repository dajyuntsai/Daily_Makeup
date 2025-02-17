//
//  PostTitleTableViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/3.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class PostTitleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var articleTitle: UITextField!
    
    var passText: ((String) -> Void)?
    
    @IBAction func articleTextfield(_ sender: UITextField) {
        guard let text = sender.text else { return }
        passText?(text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
