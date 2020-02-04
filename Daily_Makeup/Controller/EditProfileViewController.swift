//
//  EditProfileViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    }
    

    
    @objc func save() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func back() {
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
        
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
