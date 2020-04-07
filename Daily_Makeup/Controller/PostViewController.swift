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
    
    var database: Firestore!
    
    var article: Article?
    
    let userDefaults = UserDefaults.standard
    
    var nameLabel = ""
    
    var commentText = ""
    
    var urlArray: [String] = []
    
    var getPostComment: [Comment] = []
    
    var personalImage = ""
    
    var saveState = false
    
    var likestate = false
    
    var editting = false
    
    @IBOutlet var imageScrollView: UIScrollView!
    
    @IBAction func postPageControl(_ sender: UIPageControl) {
        
        imageScrollView.contentOffset.x = CGFloat(sender.currentPage * urlArray.count)
    }
    
    @IBAction func postButton(_ sender: Any) {
        
        guard let id = article?.id else { return }
        
        guard let commentTextField = addCommentTextField.text else { return }
        
        let document = database.collection("article").document(id).collection("comment").document()
        
        let comment = Comment(
            text: commentTextField
        )
        
        do {
            try document.setData(from: comment)
        } catch {
            print(error)
        }
        
        getComment()
        
        addCommentTextField.text = ""
        
    }
    
    @IBOutlet var addCommentTextField: UITextField!
    
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
            deleteButtonState()
        } else {
            
            likeBtn.setImage(UIImage(named: "heart (2)"), for: .normal)
            addBtuuonState()
        }
        
        likestate = !likestate
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if self.userDefaults.string(forKey: "uid") == nil {
            
            let controller = UIAlertController(title: "溫馨小提示", message: "登入帳號才能收藏喔！", preferredStyle: .alert)
            
            controller.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
            
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            
            controller.addAction(okAction)
            
            present(controller, animated: true, completion: nil)
            
        } else {
            if saveState {
                //disselecet(button)
                saveBtn.setImage(UIImage(named:
                    "bookmark (5)"), for: .normal)
                deleated()
                
            } else {
                //selecet(button)
                saveBtn.setImage(UIImage(named:
                    "bookmark (4)"), for: .normal)
                addData()
            }
            
            saveState = !saveState
            
        }
        
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        database =  Firestore.firestore()
        
        getComment()
        
        imageScrollView.frame.size.width = UIScreen.main.bounds.width
        
        postTableView.delegate = self
        postTableView.dataSource = self
        imageScrollView.delegate = self
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let url = URL(string: personalImage)
        profilePhoto.kf.setImage(with: url, placeholder: UIImage(named: "ECD7C7C3-1B96-45FC-BF8D-BE25BD2A9C9C"))
        
        authorLabel.text = nameLabel
        
        //照片數量
        for number in 0 ..< urlArray.count {
            
            let targetFrame = CGRect(x: UIScreen.main.bounds.width * CGFloat(number), y: 0, width: UIScreen.main.bounds.width, height: 376)
            
            print("---", targetFrame)
            
            let imageView = UIImageView(frame: targetFrame)
            imageView.clipsToBounds = true
            
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
        imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(urlArray.count), height: 376)
        
        imageScrollView.isPagingEnabled = true
        
        if saveState {
            saveBtn.setImage(UIImage(named:
                "bookmark (4)"), for: .normal)
        }
        
        //        if likestate {
        //            likeBtn.setImage(UIImage(named: "heart (2)" ), for: .normal)
        //        }
    }
    
    @objc func done() {
        
        guard let article = article else { return }
        
        let document = database.collection("article").document(article.id)
        
        document.updateData([
            "content": article.content ,
            "title": article.title
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        //
        //        documentTitle.updateData(["title" :FieldValue.arrayUnion([article.title])])
        
        let backhomepage = navigationController?.viewControllers[0] as? HomePageViewController
        backhomepage?.getAllArticle()
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func back() {
        let homepage = navigationController?.viewControllers[0] as? HomePageViewController
        homepage?.getAllArticle()
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet var postTableView: UITableView!
    
    @IBAction func settingsBtn(_ sender: Any) {
        
        if self.userDefaults.string(forKey: "uid") == article?.uid {
            
            let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertcontroller.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
            alertcontroller.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let pickerEdit = UIAlertAction(title: "編輯", style: .default) { (_) in
                self.editting = true
                self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.postTableView.reloadData()
            }
            
            let pickerdelete = UIAlertAction(title: "刪除", style: .default) { (_) in
                
                self.deleatedArticle()
                print(123) }
            
            alertcontroller.addAction(pickerEdit)
            alertcontroller.addAction(pickerdelete)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            cancelAction.setValue(UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1), forKey: "titleTextColor")
            
            alertcontroller.addAction(cancelAction)
            
            present(alertcontroller, animated: true, completion: nil)
        } else { let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertcontroller.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
            alertcontroller.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let pickerEdit = UIAlertAction(title: "檢舉", style: .default) { (_) in
                self.uploadUserUID()
            }
            
            let pickerdelete = UIAlertAction(title: "封鎖", style: .default) { (_) in
                
                self.uploadUserUID()
                print(123) }
            
            alertcontroller.addAction(pickerEdit)
            alertcontroller.addAction(pickerdelete)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            cancelAction.setValue(UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1), forKey: "titleTextColor")
            
            alertcontroller.addAction(cancelAction)
            
            present(alertcontroller, animated: true, completion: nil)
            
        }
    }
    
    func deleatedArticle() {
        
        guard let articleId = article?.id else { return }
        
        database.collection("article").document(articleId).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
                
            } else {
                print("Document successfully removed!")
                let homepage = self.navigationController?.viewControllers[0] as? HomePageViewController
                homepage?.getAllArticle()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func uploadUserUID() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        
        let document = database.collection("user").document(uid)
        
        guard let articleUid = article?.uid else { return }
        document.updateData(["blackList": FieldValue.arrayUnion([articleUid])
        ])
    }
    
    func addBtuuonState() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let document = database.collection("user").document(uid)
        
        guard let articleId = article?.id else { return }
        
        document.updateData(["articleLike": FieldValue.arrayUnion([articleId])
        ])
        
    }
    
    func deleteButtonState() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let document = database.collection("user").document(uid)
        
        guard let articleId = article?.id else { return }
        
        document.updateData(["articleLike": FieldValue.arrayRemove([articleId])
        ])
        
    }
    //加入收藏
    func addData() {
        
        guard let uid = userDefaults.string(forKey: "uid"),
            let article = article else { return }
        
        do {
            let docRef = database.collection("user").document(uid).collection("article").document(article.id)
            try docRef.setData(from: article)
        } catch {
            print(error)
        }
    }
    
    //刪除文章
    func deleated() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        guard let id = article?.id else { return }
        
        database.collection("user").document(uid).collection("article").document(id).delete {
            err in if let err = err { print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
    //get comment from firebase
    func getComment() {
        
        guard let article = article else { return }
            
        self.getPostComment = []
        database.collection("article").document(article.id).collection("comment").getDocuments {
            
            (querySnapshot, err) in if let err = err { print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        guard let result = try document.data(as: Comment.self, decoder: Firestore.Decoder())
                            else { return }
                        self.getPostComment.append(result)
                        print(result)
                    } catch {
                        print(error)
                    }
                }
                self.postTableView.reloadData()
            }
            
        }
    }
}
    
    extension PostViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("============= \(3 + getPostComment.count)=====")
            return 3 + getPostComment.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            print("============= \(3 + indexPath.row)=====")
            
            
            guard let article = article else { return UITableViewCell() }
            
            if indexPath.row == 2 {
                if let timecell = tableView.dequeueReusableCell(withIdentifier: "timecell", for: indexPath) as? PostTimeTableViewCell {
                    
                    timecell.postTimeLabel.textColor = .systemGray
                    let result = self.timeConverter(time: article.time)
                    timecell.postTimeLabel.text = result
                    return timecell
                } else {
                    return UITableViewCell()}
            }
            else if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTitleTableViewCell {
                    cell.articleTitle.text = article.title
                    
                    cell.articleTitle.isEnabled = editting
                    cell.passText = { [weak self] text in
                        self?.article?.title = text
                    }
                    
                    return cell
                } else {
                    return UITableViewCell()}
                
            }
            else if indexPath.row == 1 {
                if let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? PostContentTableViewCell {
                    
                    cell1.articleContent.text = article.content
                    
                    cell1.articleContent.isEditable = editting
                    
                    cell1.articleContent.delegate = self
                    
                    return cell1
                } else {
                    return UITableViewCell()
                }
            }
            
            else if indexPath.row >= 3 {
                if let commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell {
                    
                    commentCell.commentLabel.text = getPostComment[indexPath.row - 3 ].text
                    
                    return commentCell

                } else {
                    return UITableViewCell()
                }
            }
       
            
            return UITableViewCell()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            print(scrollView.frame)
            
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
    
    extension PostViewController: UITextViewDelegate {
        
        func textViewDidEndEditing(_ textView: UITextView) {
            article?.content = textView.text
        }
        
}
