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

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func lipCategoryButton(_ sender: UIButton) {
        guard let categoryVC = storyboard?.instantiateViewController(withIdentifier: "litspage") as?  ListViewController else { return }
        
        self.show(categoryVC, sender: nil)
        
    }
    
    
    @IBAction func paletteCategoryButton(_ sender: Any) {
    }
    
    @IBAction func brushCategoryButton(_ sender: Any) {
    }
    
    @IBAction func othersCategoryButton(_ sender: Any) {
    }
    
}


