//
//  SavePageViewController.swift
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
import Kingfisher

class SavePageViewController: ViewController {
    
    let userDefaults = UserDefaults.standard
    
    var db: Firestore!
    
    var profilePhoto = ""
    
    var imageStore: [String] = []
    
    var userData: [Article] = []{
        didSet{
            self.articleSave.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        articleSave.delegate = self
        articleSave.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadArticleData()
    }
    
    @IBOutlet var articleSave: UICollectionView!
    
    func loadArticleData() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        
        self.imageStore = []
        
        self.userData = []
        db.collection("user").document(uid).collection("article").getDocuments() {
            
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.userData = []
                for document in querySnapshot!.documents {
                    do {
                        guard let result = try document.data(as: Article.self, decoder: Firestore.Decoder())
                            else { return }
                        
                        print(result)
                        self.db.collection("user").whereField("uid", isEqualTo: result.uid).getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                guard let querySnapshot = querySnapshot else { return }
                                do {
                                    guard let userResult = try querySnapshot.documents[0].data(as: Profile.self, decoder: Firestore.Decoder())
                                        else { return }
                                        
                                    self.userData.append(result)
                                    
                                    self.imageStore.append(userResult.image)
                                    
                                    print(result)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
    
    
}

extension SavePageViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as?  SavePageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let url = URL(string: imageStore[indexPath.row]) else { return UICollectionViewCell() }
        cell.personalImage.kf.setImage(with: url)
        cell.articleTitle.text = userData[indexPath.row].title
        cell.personalAccount.text = userData[indexPath.row].name
        cell.likeNumber.text = String(userData[indexPath.row].likeNumber)
        cell.articleImage.kf.setImage(with: URL(string: userData[indexPath.row].image[0]))
        
        cell.saveLittleView.layer.borderWidth = 0.5
        
        cell.saveLittleView.layer.borderColor = #colorLiteral(red: 0.8375313282, green: 0.6639861465, blue: 0.667365849, alpha: 1)
        cell.saveLittleView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9137254902, blue: 0.8941176471, alpha: 1)
        cell.layer.cornerRadius = UIScreen.main.bounds.width / 60
        
        //底下的view右下跟左下角的框框改成圓弧
        cell.saveLittleView.layer.cornerRadius = UIScreen.main.bounds.width / 60
        cell.saveLittleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 36)/2
        //佔螢幕高度的1/2.8
        let size = CGSize(width: width, height: UIScreen.main.bounds.height / 2.8)
        return size
        
        
    }
    
    //中間距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
    
    //最旁邊間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let postVC = storyboard?.instantiateViewController(withIdentifier: "postVC") as? PostViewController else { return }
        
        postVC.nameLabel = userData[indexPath.row].name
        postVC.article = userData[indexPath.row]
        postVC.urlArray = userData[indexPath.row].image
        postVC.personalImage = imageStore[indexPath.row]
        
        //        postVC.saveBtn = userData[indexPath.row].saveState
        self.show(postVC, sender: nil)
        
        let article = userData[indexPath.row]
        
        for post in userData {
            if article.id == post.id {
                postVC.saveState = true
            }
        }
        
    }
    
    
}
