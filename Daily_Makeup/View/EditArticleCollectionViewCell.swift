//
//  EditArticleCollectionViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/13.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
protocol PassDataDelegate: AnyObject {
    func passData()
}

class EditArticleCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PassDataDelegate?
    
    @IBOutlet var articleImage: UIImageView!
    
    
    @IBOutlet var addImageBtn: UIButton!
    
    
    @IBAction func addImageBtn(_ sender: Any) {
        delegate?.passData()
        
    }
    
    
    
}
