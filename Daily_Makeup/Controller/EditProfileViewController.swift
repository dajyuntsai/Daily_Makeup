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
    var editProfileUserName = ""
    var editProfileEmail = ""
    var editProfilePhone = ""
    var editProfileBio = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
    }
    

    
    @objc func save() {
        navigationController?.popViewController(animated: true)
        
        let profile = Profile (
            name: editProfileName,
            username: editProfileUserName,
            email: editProfileEmail,
            phone: editProfilePhone,
            bio: editProfileBio)
        
        do {
            try db.collection("editProfile").addDocument(from: profile)
        } catch {
            print(error)
        }
    }
    
    @objc func cancel() {
           navigationController?.popViewController(animated: true)
       }
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var profileImage: UIImageView!
    
    let profile = ["Name","Uesrname","Email","Phone","Bio"]
    
   
    
}


extension EditProfileViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditProfileTableViewCell else { return UITableViewCell() }
        
        cell.profileLabel.text = profile[indexPath.row]
        switch indexPath.row {
        case 0:cell.profileText = { [weak self] text in self?.editProfileName = text }
        case 1:cell.profileText = { [weak self] text in self?.editProfileUserName = text }
        case 2:cell.profileText = { [weak self] text in self?.editProfileEmail = text }
        case 3:cell.profileText = { [weak self] text in self?.editProfilePhone = text }
        case 4:
            cell.profileText = { [weak self] text in self?.editProfileBio = text }
        default:
            print(123)
        }
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
