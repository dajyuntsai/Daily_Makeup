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
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8758758903, green: 0.8143615723, blue: 0.7450860143, alpha: 1)
    }
    
    var db:Firestore!
    var productArray: [Product] = []
    
    
    
    @IBAction func lipsBtn(_ sender: UIButton) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "口紅"
        self.show(listVC, sender: nil)
    }
    
    @IBAction func paletteBtn(_ sender: UIButton) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "眼影"
        self.show(listVC, sender: nil)
    }
    
    
    @IBAction func blusherBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "腮紅"
        self.show(listVC, sender: nil)
    }
    
    
    @IBAction func othersBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "其他"
        self.show(listVC, sender: nil)
    }
    
    
    
    
    
    
    
    
}


