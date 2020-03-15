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
    
    let userDefaults = UserDefaults.standard
    
    var db = Firestore.firestore()
    
    var likeBtnState = false {
        didSet {
            
            if likeBtnState {

//                likeStateBtn?(false)

                likeBtn.setImage(UIImage(named: "bookmark (4)"),for: .normal)
                
//                deleated()
            
            } else {

                likeBtn.setImage(UIImage(named: "bookmark (5)"), for: .normal)

//                likeStateBtn?(true)
//
//                addData()
                

            }
        }
    }
    
//    var btnSelected = false
    
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
    
    @IBAction func articleSaveBtn(_ sender: UIButton) {

        if likeBtnState {

            likeStateBtn?(false)

//            likeBtn.setImage(UIImage(named: "bookmark (5)"),for: .normal)
            
            deleated()
        
        } else {

//            likeBtn.setImage(UIImage(named: "bookmark (4)"), for: .normal)

            likeStateBtn?(true)
            
            addData()
         
        }

        likeBtnState = !likeBtnState
       
    }
    
    func addData() {
        
        guard let uid = userDefaults.string(forKey: "uid"),
            let article = articleManager else { return }
        
        do {
            let docRef = db.collection("user").document(uid).collection("article").document(article.id)
            try docRef.setData(from: article)
        } catch {
            print(error)
        }
    }
    
    func deleated() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        guard let id = articleManager?.id else { return }
        db.collection("user").document(uid).collection("article").document(id).delete() {err in if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
   
}
