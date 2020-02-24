//
//  PostViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/3.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Kingfisher


class PostViewController: UIViewController {
    
    var article = [Article]()
    
    var nameLabel = ""
    
    var urlArray: [String] = []

    
    @IBOutlet var imageScrollView: UIScrollView!
    
    @IBAction func postPageControl(_ sender: UIPageControl) {
        
        imageScrollView.contentOffset.x = CGFloat(sender.currentPage * urlArray.count)
    }
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var authorLabel: UILabel!
    
    
    
    //返回上一頁
    @IBAction func backToImages(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func loveBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        
        
        
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        imageScrollView.delegate = self
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        
        
        
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
               
        let pickerEdit = UIAlertAction(title: "編輯", style: .default) { (void) in
                  print(123) }
        
        let pickerdelete = UIAlertAction(title: "刪除", style: .default) { (void) in
        print(123) }
        
        
        
        
        alertcontroller.addAction(pickerEdit)
        alertcontroller.addAction(pickerdelete)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertcontroller.addAction(cancelAction)
        
        present(alertcontroller, animated: true, completion: nil)
        
        
        
        
        
        
    }
        
        
 
}

extension PostViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return article.count * 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let number = indexPath.row % 3
        
        if indexPath.row == 2 {
            if let timecell = tableView.dequeueReusableCell(withIdentifier: "timecell", for: indexPath) as? PostTimeTableViewCell {
                
                timecell.postTimeLabel.textColor = .systemGray
                let result = self.timeConverter(time: article[number - 2].time)
                timecell.postTimeLabel.text = result
                return timecell
            } else {
                return UITableViewCell()
            }
        }
            
        else if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTitleTableViewCell {
                
                cell.articleTitle.text = article[number].title
                return cell
            } else {
                return UITableViewCell()
            }
        }
            
        else if indexPath.row == 1 {
            if let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? PostContentTableViewCell {
                
                cell1.articleContent.text = article[number - 1].content
                
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
