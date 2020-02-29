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
import Kingfisher
import ESPullToRefresh
import JGProgressHUD

class HomePageViewController: UIViewController {
    
    
    @IBAction func hotBtn(_ sender: Any) {
    }
    
    
    @IBAction func newestBtn(_ sender: Any) {
        
    }
    
    var db: Firestore!
    
    let userDefaults = UserDefaults.standard
    var imageStore: [String] = []
    var profileDeta: Profile?
    var saveArticle: [Article] = []
    //    var likeState: [Bool] = []
    
    var articleArray: [Article] = []{
        didSet{
            
            // self.article.reloadData()
            self.article.es.stopPullToRefresh()
        }
        
    }
    
    var filterArray : [Article] = []{
        didSet{
            
            self.article.reloadData()
            self.article.es.stopPullToRefresh()
        }
    }
    
    var isFilter = false {
        
        didSet {
            self.article.reloadData()
            self.article.es.stopPullToRefresh()
        }
    }
    
    let search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        article.delegate = self
        article.dataSource = self
        loadData()
        
        //        refreshControl = UIRefreshControl()
        //        article.addSubview(refreshControl)
        //        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        navigationItem.title = "Makeup"
        navigationItem.searchController = search
        navigationItem.largeTitleDisplayMode = .never
        search.searchBar.placeholder = "搜尋品牌..."
        search.searchBar.tintColor = .white
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        
        //        search.searchResultsUpdater = self
        //        search.searchBar.delegate = self
        //        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name("sharePost"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        likeState = []
//        loadData()
        loadPersonalData()
        loadArticleData()
        self.article.es.addPullToRefresh {
            [unowned self] in

            self.loadData()
        }
    }
    
    @objc func reload() {
        loadData()
    }
    
    @IBOutlet var article: UICollectionView!
    
    
    @objc func loadData(){
        
        self.articleArray = []
        
        self.imageStore = []
        //全部人的文章
        //        let group = DispatchGroup()
        //        group.enter()
        
        db.collection("article").order(by: "time", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.articleArray = []
                //                group.leave()
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        guard let result = try document.data(as: Article.self, decoder: Firestore.Decoder()) else { return }
                        print(result)
                        self.articleArray.append(result)
                        
                        //用uid去firebase的user拿網址
                        // CRUD( READ )
                        
                    } catch {
                        print("123")
                        print(error)
                    }
                }
                self.loadPersonalImage()
            }
            
            let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "loading"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 3.0)
                
        }
       
        
    }
    
    
    
    func loadPersonalImage() {
        
        imageStore = [String](repeating: "", count: articleArray.count)
        
        for count in 0 ..< articleArray.count {
            print(articleArray[count].uid)
            
            self.db.collection("user").whereField("uid", isEqualTo: articleArray[count].uid).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    //文章擁有者的個人資料
                    
                    guard let querySnapshot = querySnapshot else { return }
                    querySnapshot.documents.forEach({ document in
                        
                        do {
                            guard let userResult = try document.data(as: Profile.self, decoder: Firestore.Decoder())
                                else { return }
                            
                            
                            self.imageStore[count] = userResult.image
                            if count == self.articleArray.count - 1 {
                                self.article.reloadData()
                            }
                            
                            
                        } catch {
                            (print(error))
                        }
                    })
                }
                
            }
            
        }
    }
    
    //收藏文章
    func loadArticleData() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        
        db.collection("user").document(uid).collection("article").getDocuments() {
            
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.saveArticle = []
                for document in querySnapshot!.documents {
                    do {
                        guard let result = try document.data(as: Article.self, decoder: Firestore.Decoder())
                            else { return }
                        self.saveArticle.append(result)
                        print(result)
                    } catch {
                        print(error)
                    }
                }
            }
            
        }
        
    }
    
    //拿個人資料
    func loadPersonalData() {
        
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
                    self.profileDeta = profile
                    
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding profile: \(error)")
            }
            
        }
        
        
    }
    
    
    
}



extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFilter {
            return filterArray.count
        } else {
            return articleArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell()
        }
        
        var container : [Article] = []
        if isFilter {
            container = filterArray
        } else {
            container = articleArray
        }
        
        guard let url = URL(string: imageStore[indexPath.row])
            //              let user = profileDeta
            else { return UICollectionViewCell() }
        
        cell1.personalImage.kf.setImage(with: url)
        cell1.articleTitle.text = container[indexPath.row].title
        cell1.personalAccount.text = container[indexPath.row].name
        cell1.articleImage.kf.setImage(with: URL(string: articleArray[indexPath.row].image[0]))
        cell1.articleManager = articleArray[indexPath.row]
        
        //        for count in 0 ..< user.articleLike.count {
        //            if articleArray[indexPath.row].id == user.articleLike[count] {
        //                print("true")
        //                cell1.likeBtnState = true
        //                cell1.likeBtn.setImage(UIImage(named: "heart (2)"),for: .normal)
        //            } else {
        //                print("fasle")
        //                cell1.likeBtnState = false
        //                cell1.likeBtn.setImage(UIImage(named: "heart (3)"),for: .normal)
        //            }
        //        }
        
        
        cell1.likeNumber.text = String(articleArray[indexPath.row].likeNumber)
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
        
        let article = articleArray[indexPath.item]
        
        postVC.nameLabel = articleArray[indexPath.row].name
        postVC.article = articleArray[indexPath.row]
        postVC.urlArray = articleArray[indexPath.row].image
        postVC.personalImage = imageStore[indexPath.row]
        
        self.show(postVC, sender: nil)
        
        
        //書籤狀態
        for post in saveArticle {
            if article.id == post.id {
                postVC.saveState = true
            }
        }
        
        //愛心狀態
        
        guard let articleLike = profileDeta?.articleLike else {
            return}
        for likeState in articleLike {
            if article.id == likeState {
                postVC.likestate = true
            }
        }
        
        //可以拿到postVC的nameLabel
        
    }
    
}

extension HomePageViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let search = search.searchBar.text else {
            
            isFilter = false
            return }
        
        if search.isEmpty {
            isFilter = false
            return
        }
        
        isFilter = true
        
        filterArray = articleArray.filter { article in
            
            let title = article.title
            let name = article.name
            
            let titleMatch = title.localizedCaseInsensitiveContains(search)
            
            let nameMatch = name.localizedCaseInsensitiveContains(search)
            
            if titleMatch || nameMatch {
                print(article)
                return true
            } else {
                return false
            }
        }
        
        article.reloadData()
    }
    
}

extension HomePageViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFilter = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFilter = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !isFilter {
            isFilter = true
        }
        search.searchBar.resignFirstResponder()
        
    }
    
    
}
