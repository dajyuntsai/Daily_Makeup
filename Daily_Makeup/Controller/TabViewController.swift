//
//  TabViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/13.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
            
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let vcs = viewControllers else { return false }
        
        for (index, vcs) in vcs.enumerated() {
            
            if vcs == viewController && index == 2 {
                
                if self.userDefaults.string(forKey: "uid") == nil {
                    
                    guard let navVC = vcs as? UINavigationController, let editArticleVC = navVC.viewControllers[0] as? EditArticleViewController else { return true }
                    //
                    editArticleVC.isGuest = true
                    
                } else {
                    openPictureLibrary()
                    
                    return false
                    
                }
                
            }
        }
        
        return true
    }
    
    func openPictureLibrary() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        imagePickerAlertController.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
        
        imagePickerAlertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        cancelAction.setValue(UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1),         forKey: "titleTextColor")
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(cancelAction)
        
        imagePickerAlertController.addAction(imageFromCameraAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
        
    }
    
}

extension TabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            dismiss(animated: true, completion: {
                
                guard let showArticleVC = self.storyboard?.instantiateViewController(withIdentifier: "showArticle") as? UINavigationController, let vcs = showArticleVC.viewControllers.first as? EditArticleViewController else {
                    
                    return
                }
                
                guard let selectedImageFromPicker = selectedImageFromPicker else { return }
                vcs.imageStore.append(selectedImageFromPicker)
                showArticleVC.modalPresentationStyle = .overFullScreen
                
                self.show(showArticleVC, sender: nil)
            })
            
            print("\(selectedImage)")
        }
        
    }
}
