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
import FirebaseStorage
import Kingfisher
import JGProgressHUD

class ProductDetailViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        productTextField?.text = category[row]
    }
    
    var db: Firestore!
    
    var productDetailTitle = ""
    var productDetailColor = ""
    var productDetailBrand = ""
    var productdetailOpened = ""
    var productExpirydate = ""
    var productTextFieldNote = ""
    var productDocumentID = ""
    var productDetailCategory = ""
    var addProductImage = ""
    
    
    
    var openDatepicker = UIDatePicker()
    var openTextField: UITextField?
    var showDateFormatter = DateFormatter()
    
    var expTextField:UITextField?
    var expDatePicker = UIDatePicker()
    
    var productTextField:UITextField?
    var productListPicker = UIPickerView()
    
    
    var date = ""
    var date1 = ""
    var productcategory = ""
    let category = ["口紅","眼影","腮紅","其他"]
    
    var textFieldEditable = true
    
    var imageStore: [UIImage] = []
    //    var preVC: ListViewController?
    @IBOutlet var
    imageOutlet: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBAction func addImageBtn(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        
        
        
        imagePickerController.delegate = self
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var productDetailTableView: UITableView!
    
    @IBOutlet var productDetailNote: UITextView!
    
    @IBOutlet var productImage: UIImageView!
    
    var rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        productDetailTableView.separatorStyle = .none
        productListPicker.delegate = self
        productListPicker.dataSource = self
        productDetailNote.text = productTextFieldNote
       
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Cancel))
        navigationItem.title = "product detail"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(Cancel))
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
        
        
        
        if productDocumentID != "" {
            navigationItem.rightBarButtonItem?.title = "edit"
            navigationItem.leftBarButtonItem?.title = "back"
            
            textFieldEditable = false
            productDetailNote.isEditable = false
            imageOutlet.isEnabled = false
            

        }
        
        guard let url = URL(string: addProductImage) else { return }
        productImage.kf.setImage(with: url)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        super.viewWillAppear(animated)
//
//        imageOutlet.isEnabled = false
//        imageOutlet.isHidden = true
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
//        self.productDetailTableView.es.addPullToRefresh { [unowned self] in
//
//        }
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
                    id:  document.documentID,
                    category: productDetailCategory,
                    image: [addProductImage])
                
                try document.setData(from: product)
            } catch {
                print(error)
            }
            navigationController?.popViewController(animated: true)
        } else {
            
            guard let title = navigationItem.rightBarButtonItem?.title else { return }
            
            if title == "edit" {
                //改成save
                navigationItem.rightBarButtonItem?.title = "save"
                navigationItem.leftBarButtonItem?.title = "cancel"
                imageOutlet.isEnabled = true
                imageOutlet.isHidden = false
                productDetailNote.isEditable = true
                textFieldEditable = true
                productDetailTableView.reloadData()
                
                
            } else {
                //改成edit
                
                navigationItem.rightBarButtonItem?.title = "edit"
                navigationItem.leftBarButtonItem?.title = "back"
                productDetailNote.isEditable = false
                textFieldEditable = false
                imageOutlet.isHidden = true
                productDetailTableView.reloadData()
                let document = db.collection("ProductDetail").document(productDocumentID)
                
                let product = Product (
                    title: productDetailTitle,
                    colortone: productDetailColor,
                    brand: productDetailBrand,
                    opened: productdetailOpened,
                    expirydate: productExpirydate,
                    note: productDetailNote.text,
                    id:  document.documentID,
                    category: productDetailCategory,
                    image: [addProductImage])
                
                do {
                    try document.setData(from: product, merge: true)
                } catch {
                    print(error)
                }
                dismiss(animated: false, completion: nil)
            }
            
            
            
            
        }
        
    }
    
    let productDetail = ["Category","Title","Colortone","Brand","Opened","EXP"]
}

extension ProductDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductDetailTableViewCell else { return UITableViewCell() }
        
        cell.ProdectDetailLabel.text = productDetail[indexPath.row]
//        productImage.layer.cornerRadius = UIScreen.main.bounds.width / 40
//        productImage.layer.maskedCorners = [.layerMinXMaxYCorner]
//
        cell.productDetailTextField.isEnabled = textFieldEditable
        
        
        switch indexPath.row {
        case 1:
            
            cell.productDetailTextField.text = productDetailTitle
            cell.passText = { [weak self] text in self?.productDetailTitle = text }
        case 2:
            cell.productDetailTextField.text = productDetailColor
            cell.passText = { [weak self] text in self?.productDetailColor = text
            }
        case 3:
            cell.productDetailTextField.text = productDetailBrand
            cell.passText = { [weak self] text in self?.productDetailBrand = text }
        case 4:
            cell.productDetailTextField.text = productdetailOpened
            cell.passText = { [weak self] text in self?.productdetailOpened = text }
            
            cell.productDetailTextField.inputView = openDatepicker
            
            self.openTextField = cell.productDetailTextField
            
            
        case 5:
            cell.productDetailTextField.text = productExpirydate
            cell.passText = { [weak self] text in self? .productExpirydate = text }
            
            cell.productDetailTextField.inputView = expDatePicker
            
            self.expTextField = cell.productDetailTextField
            
        case 0:
            cell.productDetailTextField.text = productDetailCategory
            cell.passText = { [weak self] text in self? .productDetailCategory = text }
            
            cell.productDetailTextField.inputView = productListPicker
            
            self.productTextField = cell.productDetailTextField
            
        default:
            print(123)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ProductDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let path = "Image/\(uniqueString).jpeg"
            let imageRef = storageRef.child(path)
            imageView.image = selectedImage
            
            guard let data = selectedImage.jpegData(compressionQuality: 0.5) else { return }
            
            let task = imageRef.putData(data, metadata: nil){
                (metadata, error) in
                imageRef.downloadURL { (url, error) in
                    print(url)
                    
                    guard let imageUrl = url else { return }
                    self.addProductImage = "\(imageUrl)"
                    self.productImage.image = selectedImage
                    self.imageOutlet.isHidden = true
                }
            }
            
            task.resume()
            dismiss(animated: true, completion: nil)
            
        }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Upload Image"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
        imageOutlet.isHidden = true
    }
    
}



