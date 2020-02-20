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
    
    var list = ""
   
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
    
    var isFilter = false {
        didSet{
            self.totalNumber.text = "\(self.listArray.count)"
            self.listTableView.reloadData()
        }
    }
    
    
    var filterArray: [Product] = [] {
        didSet{
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.737254902, blue: 0.7411764706, alpha: 1)
        navigationItem.searchController = search
        search.searchBar.placeholder = "搜尋品牌..."
        search.searchBar.tintColor = .white
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func add() {
        guard let addProductVC = storyboard?.instantiateViewController(withIdentifier: "addProduct") as? ProductDetailViewController else {
            
            return
        }
        self.show(addProductVC, sender: nil)
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
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9559974074, green: 0.9367571473, blue: 0.9282063842, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9019607843, blue: 0.8901960784, alpha: 1)
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
