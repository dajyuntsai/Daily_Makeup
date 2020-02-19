//
//  CategoryViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/30.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 227.0/255.0, green: 188.0/255.0, blue: 189.0/255.0, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func lipCategoryButton(_ sender: UIButton) {
        guard let ListVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        
        self.show(ListVC, sender: nil)
        
    }
    
    
    @IBAction func paletteCategoryButton(_ sender: Any) {
        guard let ListVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        
        self.show(ListVC, sender: nil)
        
    }
    
    @IBAction func brushCategoryButton(_ sender: Any) {
        guard let ListVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        
        self.show(ListVC, sender: nil)
    }
    
    @IBAction func othersCategoryButton(_ sender: Any) {
        guard let ListVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        
        self.show(ListVC, sender: nil)
    }
    
}


