//
//  Category.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/28.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    // 管理用　ID プライマリーキー
    dynamic var cateId = 0
    
    // カテゴリ
    dynamic var cateCategory = ""
    
    //cateID をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "cateId"
    }
}
