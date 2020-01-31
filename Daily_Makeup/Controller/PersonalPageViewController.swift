//
//  PersonalPageViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class PersonalPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        personalArtical.delegate = self
        personalArtical.dataSource = self
        personalArtical.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func editProfileButton(_ sender: UIButton) {
        
        guard let profileVC = storyboard?.instantiateViewController(withIdentifier: "editProfile") as? EditProfileViewController else { return }
        
        self.show(profileVC, sender: nil)
        
        
        
    }
    
    @IBOutlet var test: UIView!
    
    @IBOutlet var personalArtical: UICollectionView!
    
    @IBOutlet var profileTopConstraint: NSLayoutConstraint!
    
    
    
}


extension PersonalPageViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PersonalPageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.articalTitle.text = "眼尾加重法"
        cell.littleView.layer.borderWidth = 0.5
        cell.littleView.layer.borderColor = #colorLiteral(red: 0.8821310401, green: 0.6988527775, blue: 0.7068136334, alpha: 1)
        cell.littleView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.8784313725, blue: 0.8666666667, alpha: 1)
        cell.layer.cornerRadius = UIScreen.main.bounds.width / 60
        cell.littleView.layer.cornerRadius = UIScreen.main.bounds.width / 60
        cell.littleView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 36)/2
        let size = CGSize(width: width, height: UIScreen.main.bounds.height / 2.8)
        return size
    }
    
    //中間距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
    
    //最旁邊間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           
           let yPosition = -(160 + scrollView.contentOffset.y)
           
           profileTopConstraint.constant = yPosition
       }

    
 

}
