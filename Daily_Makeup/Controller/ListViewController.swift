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
import Kingfisher

class ListViewController: UIViewController {
    
    var database: Firestore!
    
    var list = ""
    var listImage = ""
    let userDefaults = UserDefaults.standard
    
    var listArray = [Product]() {
        didSet {
            if listArray.isEmpty {
                self.totalNumber.isHidden = true
            } else {
                self.totalNumber.isHidden = false
                self.totalNumber.text = "\(self.listArray.count)"
                self.listTableView.reloadData()
            }
        }
    }
    
    var isFilter = false {
        didSet {
            self.totalNumber.text = "\(self.listArray.count)"
            self.listTableView.reloadData()
        }
    }
    
    var filterArray: [Product] = [] {
        didSet {
            if filterArray.isEmpty {
                self.totalNumber.isHidden = true
            } else {
                self.totalNumber.isHidden = false
                self.totalNumber.text = "\(self.filterArray.count)"
                self.listTableView.reloadData()
            }
        }
    }
    var swtichDisplay = false
    
    @IBOutlet var serchBar: UISearchBar!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var totalNumber: UILabel!
    @IBOutlet var listTableView: UITableView!
    
    @IBAction func backtoTop(_ sender: Any) {
        
        if self.listArray.count == 0 {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.listTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    @IBAction func addImageButton(_ sender: UIButton) {
        
        productList()
        
    }
    
    let search = UISearchController(searchResultsController: nil )
    
    //    func loadData() {
    //        db.collection("ProductDetail").getDocuments() { (querySnapshot, err) in
    //            if let err = err {
    //                print("Error getting documents: \(err)")
    //            } else {
    //                self.listArray = []
    //                for document in querySnapshot!.documents {
    //
    //                    do {
    //                        guard let result = try document.data(as: Product.self, decoder: Firestore.Decoder()) else { return }
    //                        print(result)
    //
    //                        self.listArray.append(result)
    //                    } catch {
    //                        print(error)
    //                    }
    //
    //                }
    //            }
    //        }
    //    }
    
    //拿產品資訊
    func productList() {
        //category跟list一樣的名字就能找到對應的list
        database.collection("ProductDetail").whereField("category", isEqualTo: list)
            .getDocuments { (querySnapshot, err) in if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.listArray = []
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            guard let result = try document.data(as: Product.self, decoder: Firestore.Decoder()) else { return }
                            
                            guard let uid = self.userDefaults.string(forKey: "uid") else {
                                return }
                            
                            if result.uid == uid {
                                self.listArray.append(result)
                                
                            }
                            //
                        } catch {
                            
                            print(error)
                        }
                        
                        print("\(document.documentID) => \(document.data())")
                    }
                    self.listTableView.reloadData()
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.totalNumber.isHidden = true
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
        
        database = Firestore.firestore()
        
        //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        navigationItem.title = "List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.8758758903, green: 0.8143615723, blue: 0.7450860143, alpha: 1)
        navigationItem.searchController = search
        search.searchBar.placeholder = "搜尋品牌..."
        search.searchBar.tintColor = .white
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       productList()
        
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func add() {
        
        if self.userDefaults.string(forKey: "uid") == nil {
            let controller = UIAlertController(title: "溫馨小提示", message: "登入帳號才能新增產品喔！", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            
            controller.view.tintColor = UIColor(red: 208/255, green: 129/255, blue: 129/255, alpha: 1)
            
            controller.addAction(okAction)
            
            present(controller, animated: true, completion: nil)
            
        } else {
            guard let addProductVC = storyboard?.instantiateViewController(withIdentifier: "addProduct") as? ProductDetailViewController else {
                
                return
            }
            self.show(addProductVC, sender: nil)
            
        }
        
    }
    
    func deletDocument(documentID: Int) {
        let id = listArray[documentID].id
        database.collection("ProductDetail").document(id).delete { err in
            if let err  = err {
                print("Error removing document: \(err)")
            } else { print("Document successfully removed!")}
            
        }
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFilter {
            return filterArray.count
        } else {
            return listArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        var container: [Product] = []
        if isFilter {
            container = filterArray
        } else {
            container = listArray
        }
        
        cell.productTitle.text = container [indexPath.row].title
        cell.productColorTone.text = container [indexPath.row].colortone
        cell.productBrand.text = container[indexPath.row].brand
        
        let url = URL(string: listArray[indexPath.row].image[0])
        cell.productImage.kf.setImage(with: url)
        
        return cell
        //        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }
    
    //刪除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletDocument(documentID: indexPath.row)
            listArray.remove(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "addProduct") as? ProductDetailViewController else { return }
        
        productDetailVC.productDocumentID = listArray[indexPath.row].id
        productDetailVC.loadViewIfNeeded()
        
        let url = URL(string: listArray[indexPath.row].image[0])
        
        productDetailVC.productImage.kf.setImage(with: url)
        productDetailVC.productDetailCategory = listArray[indexPath.row].category
        productDetailVC.productDetailTitle = listArray[indexPath.row].title
        productDetailVC.productDetailBrand = listArray[indexPath.row].brand
        productDetailVC.productDetailColor = listArray[indexPath.row].colortone
        productDetailVC.productdetailOpened = listArray[indexPath.row].opened
        productDetailVC.productExpirydate = listArray[indexPath.row].expirydate
        productDetailVC.productTextFieldNote = listArray[indexPath.row].note
        productDetailVC.addProductImage = listArray[indexPath.row].image[0]
        
        self.show(productDetailVC, sender: nil)
        
    }
}

extension ListViewController: UISearchResultsUpdating {
    
    //搜尋欄
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let search = search.searchBar.text  else {
            
            isFilter = false
            return }
        
        if search.isEmpty {
            isFilter = false
            return
        }
        isFilter = true
        
        filterArray =  listArray.filter { product in
            
            let brand = product.brand
            let title = product.title
            
            let brandMatch = brand.localizedCaseInsensitiveContains(search)
            
            let titleMatch = title.localizedCaseInsensitiveContains(search)
            
            if brandMatch || titleMatch {
                
                return true
            } else {
                return false
            }
        }
        listTableView.reloadData()
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFilter = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFilter = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !isFilter {
            isFilter = true
        }
        search.searchBar.resignFirstResponder()
    }
}
