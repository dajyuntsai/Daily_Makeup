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
    var personalImage = ""
    var editarticleNumber = 0
    var articleImage: [String] = []
    var number = 0
    let now = NSDate()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"share" , style: .plain, target: self, action:#selector(share) )
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
    }
    
    
    @objc func share() {
        
        
        let uniqueString = NSUUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let path = "Image/\(uniqueString).jpeg"
        let imageRef = storageRef.child(path)
        
        guard let data = imageStore[0].jpegData(compressionQuality: 0.5) else { return }
        
        for i in imageStore {
            let task = imageRef.putData(data, metadata: nil) {
                (metadata, error) in
                
                imageRef.downloadURL { (url, error) in
                    print(url)
                    
                    guard let imageUrl = url else { return }
                    self.personalImage = "\(imageUrl)"
            
                    
                    guard let uid = self.userDefaults.string(forKey: "uid") else {
                        return }
                    
                    guard let name = self.userDefaults.string(forKey: "name") else {
                        return }
                    
                    let id = UUID().uuidString
                    
                    let document = self.db.collection("article").document(id)
                    
                    let currentTimes = Int(self.now.timeIntervalSince1970)
                    
                    guard let articleTextField = self.articleTextField.text else { return }
                    
                    let article = Article(
                        title: articleTextField,
                        content: self.articleTextview.text,
                        uid: uid,
                        name: name,
                        id: id,
                        time: currentTimes,
                        image: self.personalImage,
                        likeNumber: self.editarticleNumber
                        
                    )
                    
                    do {
                        try document.setData(from: article)
                    } catch {
                        print(error)
                    }
                    
                    NotificationCenter.default.post(name:Notification.Name("sharePost"), object: nil)
                    self.dismiss(animated: false, completion: nil)
                    
                }
            }
            
        }
        
    }
    
    func apple() {
        
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
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12  )
    }
    
    
}
