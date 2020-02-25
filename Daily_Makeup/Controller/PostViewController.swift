//
//  PostViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/3.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class PostViewController: UIViewController {
    
    var db: Firestore!
    
    var article: Article?
    
    let userDefaults = UserDefaults.standard
    
    
    
    var nameLabel = ""
    
    var urlArray: [String] = []
    
    var personalImage = ""
    
    var saveState = false
    
    var likestate = false
    
    @IBOutlet var imageScrollView: UIScrollView!
    
    @IBAction func postPageControl(_ sender: UIPageControl) {
        
        imageScrollView.contentOffset.x = CGFloat(sender.currentPage * urlArray.count)
    }
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var profilePhoto: UIImageView!
    
    @IBOutlet var saveBtn: UIButton!
    
    @IBOutlet var likeBtn: UIButton!
    
    //返回上一頁
    @IBAction func backToImages(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func loveBtn(_ sender: Any) {
        
        if likestate {
            
            likeBtn.setImage(UIImage(named: "heart (3)"), for: .normal)
            
        } else {
            
            likeBtn.setImage(UIImage(named: "heart (2)"), for: .normal)
            
        }
        
        likestate = !likestate
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if saveState {
            //disselecet(button)
            saveBtn.setImage(UIImage(named:
                "bookmark (5)"), for: .normal)
            
            
        } else {
            //selecet(button)
            saveBtn.setImage(UIImage(named:
                "bookmark (4)"), for: .normal)
            addData()
        }
        
        saveState = !saveState
        //
        
        
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db =  Firestore.firestore()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        imageScrollView.delegate = self
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        
        let url = URL(string: personalImage)
        profilePhoto.kf.setImage(with: url)
        
        
        authorLabel.text = nameLabel
        
        
        //照片數量
        for number in 0 ..< urlArray.count {
            
            let imageView = UIImageView(frame: CGRect(x: view.frame.width * CGFloat(number), y: 0, width: 414, height: 376))
            
            self.imageScrollView.addSubview(imageView)
            
            imageScrollView.backgroundColor = .white
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            //            let url = urlArray[number]
            let url = URL(string: urlArray[number])
            imageView.kf.setImage(with: url)
            
        }
        
        pageControl.numberOfPages = urlArray.count
        
        print(imageScrollView.contentSize)
        imageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(urlArray.count), height: 376)
        
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet var postTableView: UITableView!
    
    @IBAction func settingsBtn(_ sender: Any) {
        
        let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertcontroller.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
        alertcontroller.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let pickerEdit = UIAlertAction(title: "編輯", style: .default) { (void) in
            print(123) }
        
        let pickerdelete = UIAlertAction(title: "刪除", style: .default) { (void) in
            print(123) }
        
        alertcontroller.addAction(pickerEdit)
        alertcontroller.addAction(pickerdelete)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor(red: 208/255 , green:129/255 , blue: 129/255, alpha: 1),forKey: "titleTextColor")
        
        alertcontroller.addAction(cancelAction)
        
        present(alertcontroller, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    func addData(){
        
        guard let uid = userDefaults.string(forKey: "uid"),
            let article = article else { return }
        
        do {
            let docRef = db.collection("user").document(uid).collection("article").document()
            
            try docRef.setData(from: article)
        } catch {
            print(error)
        }
    }
    
    
}

extension PostViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let article = article else { return UITableViewCell() }
        
        let number = indexPath.row % 3
        
        if indexPath.row == 2 {
            if let timecell = tableView.dequeueReusableCell(withIdentifier: "timecell", for: indexPath) as? PostTimeTableViewCell {
                
                timecell.postTimeLabel.textColor = .systemGray
                let result = self.timeConverter(time: article.time)
                timecell.postTimeLabel.text = result
                return timecell
            } else {
                return UITableViewCell()
            }
        }
            
        else if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTitleTableViewCell {
                
                cell.articleTitle.text = article.title
                return cell
            } else {
                return UITableViewCell()
            }
        }
            
        else if indexPath.row == 1 {
            if let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? PostContentTableViewCell {
                
                cell1.articleContent.text = article.content
                
                return cell1
            } else {
                return UITableViewCell()
            }
        }
        
        
        
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        let frameWidth = Int(imageScrollView.frame.size.width)
        let contentOffsetX = Int(imageScrollView.contentOffset.x) + frameWidth / 3
        let currentPage = contentOffsetX / frameWidth
        pageControl.currentPage = currentPage
        
        
    }
    
    
    func timeConverter(time: Int) -> String {
        let time = Date.init(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let timeConvert = dateFormatter.string(from: time)
        return timeConvert
    }
}
