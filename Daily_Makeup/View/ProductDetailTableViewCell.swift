//
//  ProductDetailTableViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/31.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class ProductDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var ProdectDetailLabel: UILabel!
    
    
    @IBOutlet var productDetailTextField: UITextField!
    
    
    
        
    var passText: ((String) -> Void)?
    
    
       @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
           guard let text = sender.text else { return }
           passText?(text)
       }
       
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
