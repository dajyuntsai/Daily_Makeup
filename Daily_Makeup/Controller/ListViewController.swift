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
    var listArray = [Product]() {
        didSet{
            if listArray.isEmpty {
                self.totalNumber.isHidden = true
            } else {
                self.totalNumber.isHidden = false
                self.totalNumber.text = "\(self.listArray.count)"
                self.listTableView.reloadData()
            }
        }
    }
    
    var newArray: [Product] = []
    var swtichDisplay = false
    //搜尋功能
//    @IBAction func serchButton(_ sender: UIButton) {
//        for product in listArray {
//            print(product.brand)
//            if searchTextField.text == product.brand {
//                print(product.brand)
//                newArray.append(product)
//                swtichDisplay = true
//            }
//            if searchTextField.text == "" {
//            }
//        }
//        listTableView.reloadData()
//    }

    @IBOutlet var serchBar: UISearchBar!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var totalNumber: UILabel!
    @IBOutlet var listTableView: UITableView!
    
    @IBAction func backtoTop(_ sender: Any) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.listTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    
    @IBAction func addImageButton(_ sender: UIButton) {
        
    }
    
    let search = UISearchController(searchResultsController: nil )
    
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
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadData()
        self.totalNumber.isHidden = true
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
        
        db = Firestore.firestore()
        
        //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.963026464, green: 0.9243792892, blue: 0.9118029475, alpha: 1)
        navigationItem.searchController = search
        search.searchBar.placeholder = "搜尋品牌..."
        search.searchBar.tintColor = .white



    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func add() {
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "addProduct") as? ProductDetailViewController else {
            
            return
        }
        
        self.show(listVC, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func deletDocument(a:Int) {
        let id = listArray[a].id
        db.collection("ProductDetail").document(id).delete() { err in
            if let err  = err {
                print("Error removing document: \(err)")
            }  else {
                print("Document successfully removed!")
            }
            
        }
    }
    
}

extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return listArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()

        }


            cell.productTitle.text = listArray[indexPath.row].title
            cell.productColorTone.text = listArray[indexPath.row].colortone
            cell.productBrand.text = listArray[indexPath.row].brand


        
        return cell
//        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }
    
    //刪除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletDocument(a: indexPath.row)
            listArray.remove(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "addProduct") as? ProductDetailViewController else   { return }
        productDetailVC.productDetailTitle = listArray[indexPath.row].title
        productDetailVC.productDetailBrand = listArray[indexPath.row].brand
        productDetailVC.productDetailColor = listArray[indexPath.row].colortone
        productDetailVC.productdetailOpened = listArray[indexPath.row].opened
        productDetailVC.productExpirydate = listArray[indexPath.row].expirydate
        
        productDetailVC.productTextFieldNote = listArray[indexPath.row].note
        
        productDetailVC.productDocumentID = listArray[indexPath.row].id
        
        
        
        self.show(productDetailVC, sender: nil)
    
    }
    
    
    
    
    
    
}
