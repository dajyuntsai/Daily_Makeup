//
//  HomePageCollectionViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/29.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift



class HomePageCollectionViewCell: UICollectionViewCell {
    
    
    var db = Firestore.firestore()
    
    var likeBtnState = false
    
    var btnSelected = false
    
    var articleManager: Article?
    
    var articleId: String = ""
    
    @IBOutlet var articleImage: UIImageView!

    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var personalImage: UIImageView!
    
    @IBOutlet var personalAccount: UILabel!
    
    @IBOutlet var littleView: UIView!
    
    @IBOutlet var likeNumber: UILabel!
    
    @IBOutlet var likeBtn: UIButton!
    
    var likeStateBtn:((Bool) -> Void)?
    
    
    
    
    @IBAction func articleLikeBtn(_ sender: UIButton) {
        
        guard let articleManager = articleManager else { return}
        
        if likeBtnState {
            
            likeStateBtn?(false)
            
            likeBtn.setImage(UIImage(named: "heart (3)"),for: .normal)
            
//            likeNumber.text =  String(Int(likeNumber.text!)! - 1)
            
            

            db.collection("article").document(articleManager.id).updateData(["likeNumber": articleManager.likeNumber - 1])
            
        
        } else {
            
            likeBtn.setImage(UIImage(named: "heart (2)"), for: .normal)
            
            likeStateBtn?(true)
            
            likeNumber.text =  String(Int(likeNumber.text!)! + 1)
            
            db.collection("article").document(articleManager.id).updateData(["likeNumber": articleManager.likeNumber + 1])
            
        }
        
        likeBtnState = !likeBtnState
     
    }
    
}
