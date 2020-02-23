//
//  article.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/15.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import Foundation
import Firebase

struct  Article: Codable {
    
    let title : String
    
    let content : String
    
    let uid: String
    
    let name: String
    
    let id: String
    
    let time: Int
    
    let image: String
    
    let likeNumber: Int

}
