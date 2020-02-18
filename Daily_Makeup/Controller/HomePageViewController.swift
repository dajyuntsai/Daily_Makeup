//
//  HomePageViewController.swift
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
import ESPullToRefresh

class HomePageViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var db: Firestore!
    var articleArray: [Article] = []{
        didSet{
            
            self.article.reloadData()
        }
            
    }
    
 
    
    let search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
       
        
        article.delegate = self
        article.dataSource = self
        
        navigationItem.title = "Makeup"
        navigationItem.searchController = search
        navigationItem.largeTitleDisplayMode = .never
        search.searchBar.placeholder = "搜尋品牌..."
        search.searchBar.tintColor = .white
        
        //        search.searchResultsUpdater = self
        //        search.searchBar.delegate = self
        //        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("sharePost"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @objc func reload() {
        loadData()
    }
    
    
    
    @IBOutlet var article: UICollectionView!
    
    
    
    func loadData(){
        
    
        db.collection("article").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.articleArray = []
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        guard let result = try document.data(as: Article.self, decoder: Firestore.Decoder()) else { return }
                        print(result)
                        
                        self.articleArray.append(result)
                        
                        self.article.reloadData()
                        
                        
                    } catch {
                        print(error)
                    }
                    
                }
            }
        }
        
        
    }
    
}



extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell()
        }
        
        cell1.articleTitle.text = articleArray[indexPath.row].title
        cell1.personalAccount.text = articleArray[indexPath.row].name
    
        cell1.likeNumber.text = "1200"
        cell1.littleView.layer.borderWidth = 0.5
        cell1.littleView.layer.borderColor = #colorLiteral(red: 0.7867800593, green: 0.6210635304, blue: 0.620044291, alpha: 1)
        cell1.littleView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9137254902, blue: 0.8941176471, alpha: 1)
        cell1.layer.cornerRadius = 10
        cell1.articleImage.layer.cornerRadius = UIScreen.main.bounds.width / 60
        cell1.articleImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //底下的view右下跟左下角的框框改成圓弧
        cell1.littleView.layer.cornerRadius = UIScreen.main.bounds.width / 60
        cell1.littleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        return cell1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 36)/2
        //佔螢幕高度的1/2.8
        let size = CGSize(width: width, height: UIScreen.main.bounds.height / 2.8)
        return size
        
        
    }
    
    //中間距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8)
    }
    
    //最旁邊間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let postVC = storyboard?.instantiateViewController(withIdentifier: "postVC") as? PostViewController else { return }
        
        
        
        
        //可以拿到postVC的nameLabel
        postVC.nameLabel = articleArray[indexPath.row].name
        postVC.article = [articleArray[indexPath.row]]
        self.show(postVC, sender: nil)
        
        
    }
    
    
}
