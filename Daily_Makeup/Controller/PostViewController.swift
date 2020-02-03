//
//  PostViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/3.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = .none
        
        var imageView = UIImageView(frame:CGRect(x: view.frame.width * 3 , y: 0, width: 414, height: 376))
        self.imageScrollView.addSubview(imageView)
        imageView.backgroundColor = .orange
        
        
    }
    
    
    @IBOutlet var imageScrollView: UIScrollView!
    @IBOutlet var postTableView: UITableView!
}

extension PostViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTitleTableViewCell {
                cell.articalTitle.text = "眼尾加重法"
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
        else if indexPath.row == 1 {
            if let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? PostContentTableViewCell {
                cell1.articalContentLabel.text = "眼尾加重法想要明顯拉長與放大雙眼，那就一定要試試眼尾加首先一樣先用淺啞光色打底，然後在位於雙眼皮折線處小範圍放上珠光色，最後再用深色眼影眼尾三角區域，以及下眼尾處，也可以在用一些珠光色提亮眼頭就完成了。眼尾加重法想要明顯拉長與放大雙眼，那就一定要試試眼尾加首先一樣先用淺啞光色打底，然後在位於雙眼皮折線處小範圍放上珠光色，最後再用深色眼影眼尾三角區域，以及下眼尾處，也可以在用一些珠光色提亮眼頭就完成了。眼尾加重法想要明顯拉長與放大雙眼，那就一定要試試眼尾加首先一樣先用淺啞光色打底，然後在位於雙眼皮折線處小範圍放上珠光色，最後再用深色眼影眼尾三角區域，以及下眼尾處，也可以在用一些珠光色提亮眼頭就完成了。眼尾加重法想要明顯拉長與放大雙眼，那就一定要試試眼尾加首先一樣先用淺啞光色打底，然後在位於雙眼皮折線處小範圍放上珠光色，最後再用深色眼影眼尾三角區域，以及下眼尾處，也可以在用一些珠光色提亮眼頭就完成了。眼尾加重法想要明顯拉長與放大雙眼，那就一定要試試眼尾加首先一樣先用淺啞光色打底，然後在位於雙眼皮折線處小範圍放上珠光色，最後再用深色眼影眼尾三角區域，以及下眼尾處，也可以在用一些珠光色提亮眼頭就完成了。"
                return cell1
            } else {
                return UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
   
    
}
