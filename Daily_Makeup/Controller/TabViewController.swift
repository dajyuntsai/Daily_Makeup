//
//  TabViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/13.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let vcs = viewControllers else { return false }
        
        for (index, vc) in vcs.enumerated() {
            
            if vc == viewController && index == 2 {
                
                let imagePickerController = UIImagePickerController()
                
                imagePickerController.delegate = self
                
                let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
                
                imagePickerAlertController.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
                
                imagePickerAlertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
                let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        imagePickerController.sourceType = .photoLibrary
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                }
                let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
                    
                    
                           
                    imagePickerAlertController.dismiss(animated: true, completion: nil)
                }
                       
                cancelAction.setValue(UIColor(red: 208/255 , green:129/255 , blue: 129/255, alpha: 1),forKey: "titleTextColor")
                imagePickerAlertController.addAction(imageFromLibAction)
                imagePickerAlertController.addAction(cancelAction)
                
                imagePickerAlertController.addAction(imageFromCameraAction)
                
                present(imagePickerAlertController, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
    
}


extension TabViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
//        let uniqueString = NSUUID().uuidString

        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            //            profileImage.image = selectedImage
            dismiss(animated: true, completion: {
                
                guard let showArticleVC = self.storyboard?.instantiateViewController(withIdentifier: "showArticle") as? UINavigationController, let vc = showArticleVC.viewControllers.first as? EditArticleViewController else {
                    
                    return
                }
            
                
                guard let selectedImageFromPicker = selectedImageFromPicker else { return }
                vc.imageStore.append(selectedImageFromPicker)
                showArticleVC.modalPresentationStyle = .overFullScreen

                self.show(showArticleVC, sender: nil)
            })
            
            
            print("\(selectedImage)")
        }
        
        
    }
}

