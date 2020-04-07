//
//  CommentTableViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/3/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var commentContentLabel: UILabel!
    @IBOutlet var commentImage: UIImageView!
    @IBOutlet var commentNameLabel: UILabel!
}
