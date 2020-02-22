//
//  SavePageViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class SavePageViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleSave.delegate = self
        articleSave.dataSource = self
       
    }
    
    @IBOutlet var articleSave: UICollectionView!
    
   
}

extension SavePageViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as?  SavePageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.articleTitle.text = "眼尾加重法"
        cell.personalAccount.text = "ddd234"
        cell.likeNumber.text = "3000"
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
        
        self.show(postVC, sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let postVc = storyboard?.instantiateViewController(withIdentifier: "postVC") as? PostViewController else { return }
    }
    
}
