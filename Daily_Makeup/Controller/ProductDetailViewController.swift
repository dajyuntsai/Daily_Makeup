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
    var productTextFieldNote = ""
    var productDocumentID = ""
    
    var openDatepicker = UIDatePicker()
    var openTextField: UITextField?
    var showDateFormatter = DateFormatter()
    
    var expTextField:UITextField?
    var expDatePicker = UIDatePicker()
    var date = ""
    var date1 = ""
    
   
    
    
    @IBOutlet var productDetailTableView: UITableView!

    @IBOutlet var productDetailNote: UITextView!
    
    @IBOutlet var productImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        productDetailTableView.separatorStyle = .none
       
        
        productDetailNote.text = productTextFieldNote
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
            
        showDateFormatter.dateFormat = "yyyy-MM-dd"
        openDatepicker.datePickerMode = .date
        openDatepicker.locale = Locale(identifier: "zh_TW")
        expDatePicker.datePickerMode = .date
        expDatePicker.locale = Locale(identifier: "zh_TW")
        
        //picker選擇完後要做的事
        openDatepicker.addTarget(self, action: #selector(selectedOpenDate), for: .valueChanged)
        
        expDatePicker.addTarget(self, action: #selector(selectedExpOpenDate), for: .valueChanged)
        
    }
    //日期picker
    @objc func selectedOpenDate() {
        openTextField?.text = showDateFormatter.string(from: openDatepicker.date)
    }
    
    @objc func selectedExpOpenDate(){
        expTextField?.text = showDateFormatter.string(from: expDatePicker.date)
    }
    
    @objc func Cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    //若沒有Id表示要新增資料，若有Id表示是編輯
    @objc func save() {
        
        if productDocumentID == "" {
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
        } else {
            let document = db.collection("ProductDetail").document(productDocumentID)
            
            let product = Product (
                                     title: productDetailTitle,
                                     colortone: productDetailColor,
                                     brand: productDetailBrand,
                                     opened: productdetailOpened,
                                     expirydate: productExpirydate,
                                     note: productDetailNote.text,
                                     id:  document.documentID)
            
            do {
                try document.setData(from: product, merge: true)
            } catch {
                print(error)
            }
        }
        
        navigationController?.popViewController(animated: true)
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
        case 0:
            
            cell.productDetailTextField.text = productDetailTitle
            cell.passText = { [weak self] text in self?.productDetailTitle = text }
        case 1:
            cell.productDetailTextField.text = productDetailColor
            cell.passText = { [weak self] text in self?.productDetailColor = text
            }
        case 2:
            cell.productDetailTextField.text = productDetailBrand
            cell.passText = { [weak self] text in self?.productDetailBrand = text }
        case 3:
            cell.productDetailTextField.text = productdetailOpened
            cell.passText = { [weak self] text in self?.productdetailOpened = text }
            
            cell.productDetailTextField.inputView = openDatepicker
            self.openTextField = cell.productDetailTextField
            
        case 4:
            cell.productDetailTextField.text = productExpirydate
            cell.passText = { [weak self] text in self? .productExpirydate = text }
            
            cell.productDetailTextField.inputView = expDatePicker
            self.expTextField = cell.productDetailTextField
            
        default:
            print(123)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

