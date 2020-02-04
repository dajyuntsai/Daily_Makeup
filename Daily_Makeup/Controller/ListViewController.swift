//
//  ListViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/1.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
        

    }
    
    //切換至新增商品細節
    @IBAction func addProductButton(_ sender: Any) {
        
        guard let listVC = storyboard?.instantiateViewController(identifier: "addProduct") as? ProductDetailViewController else {
            return }
        
        self.show(listVC, sender: nil)
        
    }
    
    @IBOutlet var listTableView: UITableView!
}

extension ListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell else{ return UITableViewCell()}
        
        
        cell.productBrand.text = "Dior"
        cell.productColorTone.text = "red"
        cell.productTitle.text = "Brike"
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }
    
    
}



