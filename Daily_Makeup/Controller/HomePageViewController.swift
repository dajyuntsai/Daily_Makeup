//
//  HomePageViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/29.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        article.delegate = self
        article.dataSource = self
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var article: UICollectionView!
    
}

extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell()
    }
        cell1.articleTitle.text = "眼尾加重法"
        cell1.personalAccount.text = "QAQ77777"
        cell1.likeNumber.text = "1200"
        cell1.littleView.layer.borderWidth = 0.5
        cell1.littleView.layer.borderColor = #colorLiteral(red: 0.7867800593, green: 0.6210635304, blue: 0.620044291, alpha: 1)
        cell1.littleView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.8784313725, blue: 0.862745098, alpha: 1)
        cell1.layer.cornerRadius = UIScreen.main.bounds.width / 60
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
        return CGFloat(12)
    }
    
    //最旁邊間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

}
