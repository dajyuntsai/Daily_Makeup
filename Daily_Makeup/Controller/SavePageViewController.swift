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
    
    var database: Firestore!
    
    var profilePhoto = ""
    
    var imageStore: [String] = [] {
        didSet {
            if self.imageStore.count == 0 {
                self.notyetSaveLabel.isHidden = false
            } else {
                self.notyetSaveLabel.isHidden = true
            }
            
        }
    }
    
    var userData: [Article] = [] {
        didSet {
            self.articleSave.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
        articleSave.delegate = self
        articleSave.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadArticleData()
        
    }
    
    @IBOutlet var notyetSaveLabel: UILabel!
    @IBOutlet var articleSave: UICollectionView!
    
    func loadArticleData() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        
        self.imageStore = []
        
        self.userData = []
        database.collection("user").document(uid).collection("article").getDocuments {
            
            (querySnapshot, err) in if let err = err { print("Error getting documents: \(err)")
            } else {
                self.userData = []
                for document in querySnapshot!.documents {
                    do {
                        guard let result = try document.data(as: Article.self, decoder: Firestore.Decoder())
                            else { return }
                        
                        print(result)
                        self.database.collection("user").whereField("uid", isEqualTo: result.uid).getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                guard let querySnapshot = querySnapshot else { return }
                                do {
                                    guard let userResult = try querySnapshot.documents[0].data(as: Profile.self, decoder: Firestore.Decoder())
                                        else { return }
                                    
                                    self.userData.append(result)
                                    if let userImage = userResult.image {
                                        self.imageStore.append(userImage)
                                    } else {                                         self.imageStore.append("https://firebasestorage.googleapis.com/v0/b/dailymakeup-8ac8c.appspot.com/o/placeholder%2FECD7C7C3-1B96-45FC-BF8D-BE25BD2A9C9C.png?alt=media&token=eec4c021-4677-4707-a52b-b86aabd477ac")
                                    }
//                                    self.imageStore.append(userImage)
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

extension SavePageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        let article = userData[indexPath.row]
        cell.article = article
        
        cell.saveBtnState = { isSave in
            
            if isSave {
                self.userData.append(self.userData[indexPath.row])
            } else {
                self.userData.remove(at: indexPath.row)
            }
            self.articleSave.reloadData()
            
        }
        
        cell.btnState = false
        for post in userData {
            let article = userData[indexPath.row]
            if article.id == post.id {
                cell.btnState = true
            }
            
        }
        
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
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let postVC = storyboard?.instantiateViewController(withIdentifier: "postVC") as? PostViewController else { return }
        
        let article = userData[indexPath.row]
        
        postVC.nameLabel = userData[indexPath.row].name
        postVC.article = userData[indexPath.row]
        postVC.urlArray = userData[indexPath.row].image
        postVC.personalImage = imageStore[indexPath.row]
        postVC.article = article
        
        //        postVC.saveBtn = userData[indexPath.row].saveState
        self.show(postVC, sender: nil)
        for post in userData where article.id == post.id {
            postVC.saveState = true
        }
        
    }
    
}
