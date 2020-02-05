//
//  ListViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/1.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class ListViewController: UIViewController {
    
    var db: Firestore!
    var listArray : [Product] = []
    
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
        
        db = Firestore.firestore()
        
//        loadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //切換至新增商品細節
    @IBAction func addProductButton(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(identifier: "addProduct") as? ProductDetailViewController else {
            return }
        
        self.show(listVC, sender: nil)
        
    }
    
}

extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func loadData() {
        db.collection("ProductDetail").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listArray = []
                for document in querySnapshot!.documents {
                   
                    do {
                        guard let result = try document.data(as: Product.self, decoder: Firestore.Decoder()) else { return }
                        print(result)
                        
                        self.listArray.append(result)
                    } catch {
                        print(error)
                    }
                    
                }
                self.listTableView.reloadData()
            }
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell else { return UITableViewCell()}
        
        
        cell.productTitle.text = listArray[indexPath.row].title
        cell.productColorTone.text = listArray[indexPath.row].colortone
        cell.productBrand.text = listArray[indexPath.row].brand
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }
    
    
}
