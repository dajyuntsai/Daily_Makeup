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

class EditProfileViewController: UIViewController {
    
    var db: Firestore!
    
    var editProfileName = ""
    var editProfileEmail = ""
    var editProfileBio = ""
    var uid = ""
    var editProfileArray: [Profile] = []
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        //        setUp()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        loadData()
    }
    
    
   
    @objc func save() {
        navigationController?.popViewController(animated: true)
        
        let profile = Profile (
            name: editProfileName,
            email: editProfileEmail,
            bio: editProfileBio,
            uid: uid)
        
        do {
            try db.collection("user").addDocument(from: profile)
        } catch {
            print(error)
        }
        
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
    
    let profile = ["Name","Email","Bio"]
    
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
