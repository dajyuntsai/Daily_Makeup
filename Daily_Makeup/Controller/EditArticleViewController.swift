//
//  EditArticalViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/13.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import JGProgressHUD


class EditArticleViewController: UIViewController{
    
    var db:Firestore!
    var imageStore: [UIImage] = []
    var uid = ""
    var name = ""
//    var personalImage = ""
    var saveState = false
    var editarticleNumber = 0
    var articleImage: [String] = []
    var number = 0
    let now = NSDate()
    let userDefaults = UserDefaults.standard
    var isGuest = false
    
    @IBOutlet var articleTextview: UITextView!
    @IBOutlet var articleTextField: UITextField!
    @IBOutlet var blankView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db =  Firestore.firestore()
        
        articleTextview.delegate = self
        articleTextview.text = "write a caption"
        articleTextview.textColor = UIColor.lightGray
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"share" , style: .plain, target: self, action:#selector(share) )
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        if isGuest {
            blankView.isHidden = false
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    @objc func share() {
        
        let group = DispatchGroup()
        
        for image in imageStore {
            
            let uniqueString = NSUUID().uuidString
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let path = "Image/\(uniqueString).jpeg"
            let imageRef = storageRef.child(path)
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            
            group.enter()
            let task = imageRef.putData(data, metadata: nil) {
                (metadata, error) in
                
                imageRef.downloadURL { [weak self] (url, error) in
//                    print(url)
                    
                    guard let imageUrl = url else { return }
//                    self.personalImage = "\(imageUrl)"
                    self?.articleImage.append(imageUrl.absoluteString)
                    group.leave()
                    
                }
            }
            task.resume()
            
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            guard let uid = strongSelf.userDefaults.string(forKey: "uid") else {
                return }
            
            guard let name = strongSelf.userDefaults.string(forKey: "name") else {
                return }
            
            let id = UUID().uuidString
            
            let document = strongSelf.db.collection("article").document(id)
            
            let currentTimes = Int(strongSelf.now.timeIntervalSince1970)
            
            guard let articleTextField = strongSelf.articleTextField.text else { return }
            
            let article = Article(
                title: articleTextField,
                content: strongSelf.articleTextview.text,
                uid: uid,
                name: name,
                id: id,
                time: currentTimes,
                image: strongSelf.articleImage,
                likeNumber: strongSelf.editarticleNumber,
                saveState: strongSelf.saveState
                
            )
            
            do {
                try document.setData(from: article)
            } catch {
                print(error)
            }
            
            NotificationCenter.default.post(name:Notification.Name("sharePost"), object: nil)
            strongSelf.dismiss(animated: false, completion: nil)
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading"
            hud.show(in: strongSelf.view)
            hud.dismiss(afterDelay: 3.0)
        }
        
    }
    
    @objc func cancel() {
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet var imageCollectionView: UICollectionView!
    
    
    
}



extension EditArticleViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  articleTextview.textColor == UIColor.lightGray {
            articleTextview.text = nil
            articleTextview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if  articleTextview.text.isEmpty {
            articleTextview.text = "write a caption"
            articleTextview.textColor = UIColor.lightGray
        }
    }
}

extension EditArticleViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStore.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EditArticleCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == imageStore.count{
            cell.addImageBtn.isHidden = false
            cell.articleImage.isHidden = true
//            return cell
        } else {
            cell.articleImage.image = imageStore[indexPath.row]
            cell.addImageBtn.isHidden = true
            cell.articleImage.isHidden = false
        }
        cell.delegate = self
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12  )
    }
    
    
}

extension EditArticleViewController:PassDataDelegate{
    func passData() {
        openPictureLibrary()
    }
    
    func openPictureLibrary() {
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
        
    }
   
}

extension EditArticleViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var selectedImageFromPicker: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        
        if let selectedImage = selectedImageFromPicker {
            
            dismiss(animated: true, completion: {
                
//                guard let vc = showArticleVC.viewControllers.first as? EditArticleViewController else {
//
//                    return
//                }
                
                guard let selectedImageFromPicker = selectedImageFromPicker else { return }
                
                self.imageStore.append(selectedImageFromPicker)
                
                self.imageCollectionView.reloadData()
//                showArticleVC.modalPresentationStyle = .overFullScreen
                
//                self.show(showArticleVC, sender: nil)
            })
            print("\(selectedImage)")
        }
        
        
    }
}
