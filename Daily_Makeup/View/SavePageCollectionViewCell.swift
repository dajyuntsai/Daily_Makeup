//
//  SavePageCollectionViewCell.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift



class SavePageCollectionViewCell: UICollectionViewCell {
    
    var btnState = false {
        didSet {
            if btnState {
                likeNumberBtn.setImage(UIImage(named: "bookmark (4)"), for: .normal)
            } else {
                likeNumberBtn.setImage(UIImage(named: "bookmark (5)"), for: .normal)
            }
        }
    }
    
    let userDefaults = UserDefaults.standard
    
    var article: Article?
    
    var db = Firestore.firestore()
    
    var saveBtnState:((Bool) -> Void)?
    
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
            
            saveBtnState?(false)
            
           deleated()
            
//            likeNumberBtn.setImage(UIImage(named: "bookmark (5)"), for: .normal)
            
//            likeNumber.text = String(Int(likeNumber.text!)! - 1)
            
        } else {
//            likeNumberBtn.setImage(UIImage(named: "bookmark (4)"), for: .normal)
         saveBtnState?(true)
         addData()
            
//            likeNumber.text = String(Int(likeNumber.text!)! + 1)
        }
        
        btnState = !btnState
    }
    
    func addData() {
        
        guard let uid = userDefaults.string(forKey: "uid"),
            let article = article else { return }
        
        do {
            let docRef = db.collection("user").document(uid).collection("article").document(article.id)
            try docRef.setData(from: article)
        } catch {
            print(error)
        }
    }
    
    func deleated() {
        
        guard let uid = userDefaults.string(forKey:"uid") else { return }
        guard let id = article?.id else { return }
        
        db.collection("user").document(uid).collection("article").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
}
