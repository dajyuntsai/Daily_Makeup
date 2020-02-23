//
//  EditProfileViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Kingfisher

class EditProfileViewController: UIViewController {
    
    var db: Firestore!
    
    var editProfileName = ""
    var editProfileEmail = ""
    var editProfileBio = ""
    var uid = ""
    var editImage = ""
    var editProfileArray: [Profile] = []
    
    let userDefaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        //        setUp()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        navigationItem.title = "edit profile"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        loadData()
        
        guard let url = URL(string: editImage) else { return }
        profileImage.kf.setImage(with: url)
    }
    
    @IBOutlet var addImageOutlet: UIButton!
    
    
    @IBAction func cPPButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        
        
        imagePickerController.delegate = self
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (void) in
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
        
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
        
    }
    @IBAction func addImageBtn(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
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
        
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
        
        
    }
    
    @objc func save() {
        
        //        let uniqueString = NSUUID().uuidString
        //        let storageReference = Storage.storage().reference()
        //        let fileReference = storageReference.child(uniqueString)
        //
        //        if let uploadData =
        
        
        
//        guard let uid = userDefaults.string(forKey: "uid") else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        let document = db.collection("user").document(uid)
        
        let profile = Profile (
            name: editProfileName,
            email: editProfileEmail,
            bio: editProfileBio,
            uid: uid,
            image: editImage)
        
        do {
            try document.setData(from: profile, merge: true)
            
            
        } catch {
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        
        guard let uid = userDefaults.string(forKey: "uid") else { return }
        
        
        
        let docRef = db.collection("user").document(uid)
        
        docRef.getDocument { (document, error) in
            let result = Result {
                try document.flatMap {
                    try $0.data(as: Profile.self)
                }
            }
            switch result {
            case .success(let editProfile):
                if let editProfile = editProfile {
                    print("User: \(editProfile)")
                    self.editProfileName = editProfile.name
                    self.editProfileEmail = editProfile.email
                    self.editProfileBio = editProfile.bio ?? ""
                    self.editImage = editProfile.image
                    
                    self.profileTableView.reloadData()
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
            }
        }
    }
    
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var profileImage: UIImageView!
    
    let profile = ["name","email","bio"]
    
}


extension EditProfileViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditProfileTableViewCell else { return UITableViewCell() }
        
        cell.profileLabel.text = profile[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.nameTextField.text = editProfileName
            cell.profileText = { [weak self] text in self?.editProfileName = text }
        case 1:
            cell.nameTextField.text = editProfileEmail
            cell.profileText = { [weak self] text in self?.editProfileEmail = text }
        case 2:
            cell.nameTextField.text =  editProfileBio
            cell.profileText = { [weak self] text in self?.editProfileBio = text }
        default:
            print(123)
        }
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
        
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let path = "Image/\(uniqueString).jpeg"
            let imageRef = storageRef.child(path)
            
            guard let data = selectedImage.jpegData(compressionQuality: 0.5) else { return }
            
            let task = imageRef.putData(data, metadata: nil) { (metadata, error) in
                imageRef.downloadURL { (url, error) in
                    print(url)
                    
                    guard let imageUrl = url else { return }
                    self.editImage = "\(imageUrl)"
                    self.profileImage.image = selectedImage
                }
            }
            
            task.resume()
            
            

            dismiss(animated: true, completion: nil)
        
        }

    }
}


