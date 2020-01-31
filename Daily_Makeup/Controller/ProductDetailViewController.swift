//
//  ProductDetailViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/31.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    
    @IBOutlet var productDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        productDetailTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
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
        
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

