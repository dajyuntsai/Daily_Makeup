//
//  PersonalPageViewController.swift
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

class PersonalPageViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var test: UIView!
    var db: Firestore!
    var profileArray : [Profile] = []
    var articleArray: [Article] = []
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        userDefaults.value(forKey: "name")
//        userDefaults.value(forKey: "email")
//        userDefaults.value(forKey: "uid")
        
        nameLabel.text = userDefaults.value(forKey: "name") as? String
        
        articalCollectionView.delegate = self
        articalCollectionView.dataSource = self
        articalCollectionView.contentInset = UIEdgeInsets(top: test.frame.size.height, left: 0, bottom: 0, right: 0)
        
        db = Firestore.firestore()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    
    @IBAction func editProfileBtn(_ sender: Any) {
        
        guard let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "editProfile") as? EditProfileViewController else { return }
        //        editProfileVC.editProfile = profileArray
        
        self.show(editProfileVC, sender: nil)
    }
    
    
    @IBOutlet var articalCollectionView: UICollectionView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    
    func loadData() {
        
        guard let uid =  userDefaults.string(forKey: "uid") else { return }
        
        let docRef = db.collection("user").document(uid)
        
        docRef.getDocument { (document, error) in
            let result = Result {
                try document.flatMap {
                    try $0.data(as: Profile.self)
                }
            }
            switch result {
            case .success(let profile):
                if let profile = profile {
                   print("Profile: \(profile)")
                    self.bioLabel.text = profile.bio
                    self.nameLabel.text = profile.name
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
            }
        }
        
        
    }
    
    func getArticleData(){
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        
        db.collection("article").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }

        
        
        
    }



}

extension PersonalPageViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PersonalPageCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.articalTitle.text = "眼尾加重法"
            cell.littleView.layer.borderWidth = 0.5
            cell.littleView.layer.borderColor = #colorLiteral(red: 0.8821310401, green: 0.6988527775, blue: 0.7068136334, alpha: 1)
            cell.littleView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.8784313725, blue: 0.8666666667, alpha: 1)
            cell.layer.cornerRadius = UIScreen.main.bounds.width / 60
            cell.littleView.layer.cornerRadius = UIScreen.main.bounds.width / 60
            cell.littleView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (UIScreen.main.bounds.width - 36)/2
            let size = CGSize(width: width, height: UIScreen.main.bounds.height / 2.8)
            return size
        }
        
        //中間距離
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return CGFloat(8)
        }
        
        //最旁邊間距
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let postVC = storyboard?.instantiateViewController(identifier: "postVC") as? PostViewController else { return }
        
        self.show(postVC, sender: nil)
    }
        
        //
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            let yPosition = -(test.frame.size.height + scrollView.contentOffset.y)
            
            topConstraint.constant = yPosition
        }

}

