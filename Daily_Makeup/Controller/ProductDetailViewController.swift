//
//  ProductDetailViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/31.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    //跳回List頁
//    @IBAction func backToList(_ sender: UIBarButtonItem) {
//        navigationController?.popViewController(animated: true)
//    }
    

    @IBOutlet var productDetailTableView: UITableView!
    
    @IBOutlet var productImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        productDetailTableView.separatorStyle = .none
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.537254902, blue: 0.4980392157, alpha: 1)
        
    }
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    @objc func save() {
        navigationController?.popViewController(animated: true)
    }

    
    let productDetail = ["Title","Color","Brand","Opened","EXP",]
}

extension ProductDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductDetailTableViewCell else { return UITableViewCell()}
        
        cell.ProdectDetailLabel.text = productDetail[indexPath.row]
        productImage.layer.cornerRadius = UIScreen.main.bounds.width / 40
        productImage.layer.maskedCorners = [.layerMinXMaxYCorner]

        return cell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

