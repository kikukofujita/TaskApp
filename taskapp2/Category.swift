//
//  Category.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/30.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    // ID
    dynamic var categoryId = 0
    
    // カテゴリ
    dynamic var classCategory = ""
    
    override static func primaryKey() -> String? {
        return "categoryId"
    }
}
