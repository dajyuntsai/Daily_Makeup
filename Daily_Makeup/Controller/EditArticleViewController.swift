//
//  EditArticalViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/13.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class EditArticleViewController: UIViewController{
    
    var db:Firestore!
    var imageStore: [UIImage] = []
    var uid = ""
    var name = ""
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var articleTextview: UITextView!
    @IBOutlet var articleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db =  Firestore.firestore()
        
        articleTextview.delegate = self
        articleTextview.text = "write a caption"
        articleTextview.textColor = UIColor.lightGray
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"share" , style: .plain, target: self
            , action:#selector(share) )
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        

      
    }
    
    
    @objc func share() {
        
        guard let uid = userDefaults.string(forKey: "uid") else {
            return }
        
        guard let name = userDefaults.string(forKey: "name") else {
            return }
        
        let document = db.collection("article").document()
        
        guard let articleTextField = articleTextField.text else { return }
        
            let article = Article(
                title: articleTextField,
                content: articleTextview.text,
                uid: uid,
                name: name)
        
        do {
            try document.setData(from: article)
        } catch {
            print(error)
        }
        
        dismiss(animated: false, completion: nil)
        
    }
    
    @objc func cancel() {
        
        dismiss(animated: false, completion: nil)
    }
    
   

    @IBOutlet var imageCollectionView: UICollectionView!

  

}



extension EditArticleViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            if  articleTextview.textColor == UIColor.lightGray {
                articleTextview.text = nil
                articleTextview.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if  articleTextview.text.isEmpty {
                articleTextview.text = "write a caption"
                articleTextview.textColor = UIColor.lightGray
            }
        }
}

extension EditArticleViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStore.count + 1
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EditArticleCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == imageStore.count{
            return cell
        } else {
             cell.articleImage.image = imageStore[indexPath.row]
        }
        
        
//
       
    return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12  )
    }
}
