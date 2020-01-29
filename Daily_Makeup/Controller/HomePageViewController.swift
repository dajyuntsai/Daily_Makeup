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

        // Do any additional setup after loading the view.
    }
    
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
//        cell1.contentView.layer.borderWidth = 1
//        cell1.contentView.layer.borderColor = UIColor.gray.cgColor
        return cell1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40)/2
        let size = CGSize(width: width, height: UIScreen.main.bounds.height / 2.5)
        return size
        
        
    }
    
    //中間距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(16)
    }
    
    //最旁邊間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

}
