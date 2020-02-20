//
//  CategoryViewController.swift
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
import FBSDKLoginKit

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 227.0/255.0, green: 188.0/255.0, blue: 189.0/255.0, alpha: 1.0)
   
    }
    
    var db:Firestore!
    
    func productList() {
        
        
        
//        db.collection("article").whereField("id", isEqualTo: : id)
    }
    
    @IBAction func lipsBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "lips"
        self.show(listVC, sender: nil)
    }
    
    @IBAction func paletteBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "palette"
        self.show(listVC, sender: nil)
    }
    
    
    @IBAction func blusherBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "blusher"
        self.show(listVC, sender: nil)
    }
    
    
    @IBAction func othersBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "others"
        self.show(listVC, sender: nil)
    }
    


    
    
    
    
    
}


