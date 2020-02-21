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
    var productArray: [Product] = []
    
//    func productList() {
//        
//        db.collection("ProductDetail").whereField("category", isEqualTo: )
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        
//                        do{
//                            
//                            
//                            guard let result = try document.data(as: Product.self, decoder: Firestore.Decoder()) else { return }
//                            
//                            self.productArray.append(result)
//                            
//                        } catch {
//                            
//                            print(error)
//                        }
//                        
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                    
//                }
//        }
//        
//        
//        
//        
//    }
    
    @IBAction func lipsBtn(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        listVC.list = "口紅"
        self.show(listVC, sender: nil)
    }
    
    @IBAction func paletteBtn(_ sender: Any) {
        
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


