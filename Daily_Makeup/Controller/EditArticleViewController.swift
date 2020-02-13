//
//  EditArticalViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/13.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class EditArticleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        articalTextView.delegate = self
        articalTextView.text = "write a caption"
        articalTextView.textColor = UIColor.lightGray
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    
      
    }
    
    var imageStore: [UIImage] = []
    
   
    @IBOutlet var imageCollectionView: UICollectionView!
    
    @IBOutlet var articalTextView: UITextView!
}

extension EditArticleViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            if  articalTextView.textColor == UIColor.lightGray {
                articalTextView.text = nil
                articalTextView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if  articalTextView.text.isEmpty {
                articalTextView.text = "write a caption"
                articalTextView.textColor = UIColor.lightGray
            }
        }
}

extension EditArticleViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStore.count + 1
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EditArticleCollectionViewCell else { return UICollectionViewCell() }
    
    return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12  )
    }
}
