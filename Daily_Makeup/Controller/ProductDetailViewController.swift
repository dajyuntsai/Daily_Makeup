//
//  ProductDetailViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/31.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProductDetailViewController: UIViewController {
    var db: Firestore!
    
    var productDetailTitle = ""
    var productDetailColor = ""
    var productDetailBrand = ""
    var productdetailOpened = ""
    var productExpirydate = ""
//    var productDocumentID = ""
    
    
    @IBOutlet var productDetailTableView: UITableView!
    
    
    @IBOutlet var productDetailNote: UITextView!
    @IBOutlet var productImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        productDetailTableView.separatorStyle = .none
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
    }
    
    @objc func Cancel() {
        navigationController?.popViewController(animated: true)
        
    }
    @objc func save() {
        navigationController?.popViewController(animated: true)
        
        do {
            let document = db.collection("ProductDetail").document()
            
            let product = Product (
                title: productDetailTitle,
                colortone: productDetailColor,
                brand: productDetailBrand,
                opened: productdetailOpened,
                expirydate: productExpirydate,
                note: productDetailNote.text,
                id:  document.documentID)
            
            try document.setData(from: product)
        } catch {
            print(error)
        }
        
    }
    
    
    
    
    let productDetail = ["Title","Colortone","Brand","Opened","EXP"]
}

extension ProductDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductDetailTableViewCell else { return UITableViewCell()}
        
        cell.ProdectDetailLabel.text = productDetail[indexPath.row]
        productImage.layer.cornerRadius = UIScreen.main.bounds.width / 40
        productImage.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        switch indexPath.row {
        case 0:cell.passText = { [weak self] text in self?.productDetailTitle = text }
        case 1:cell.passText = { [weak self] text in self?.productDetailColor = text }
        case 2:cell.passText = { [weak self] text in self?.productDetailBrand = text }
        case 3:cell.passText = { [weak self] text in self?.productdetailOpened = text }
        case 4:cell.passText = { [weak self] text in self? .productExpirydate = text }
            
        default:
            print(123)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

