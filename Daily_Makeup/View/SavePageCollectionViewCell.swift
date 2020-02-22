//
//  SavePageCollectionViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class SavePageCollectionViewCell: UICollectionViewCell {
    
    var btnState = false
    
    var btnSelected = false
    
    @IBOutlet var articleImage: UIImageView!
    
    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var personalImage: UIImageView!
    @IBOutlet var personalAccount: UILabel!
    
    @IBOutlet var likeNumber: UILabel!
    @IBOutlet var saveLittleView: UIView!
    
    
    @IBOutlet var likeNumberBtn: UIButton!
    
    @IBAction func articleLike(_ sender: Any) {
        
        if btnState {
            
            likeNumberBtn.setImage(UIImage(named: "heart (3)"), for: .normal)
            
            likeNumber.text = String(Int(likeNumber.text!)! - 1)
            
            
        } else {
            likeNumberBtn.setImage(UIImage(named: "heart (2)"), for: .normal)
            
            likeNumber.text = String(Int(likeNumber.text!)! + 1)
        }
        
        btnState = !btnState
    }
    
}
