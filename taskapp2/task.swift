//
//  task.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/23.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    // 管理用　ID プライマリーキー
    dynamic var id = 0
    
    // タイトル
    dynamic var title = ""
    
    // カテゴリ
    dynamic var category: Category?
    
    // 内容
    dynamic var contents = ""
    
    // 日時
    dynamic var date = NSDate()

    /**
    id　をプライマリーキーとして設定
    */
 
    override static func primaryKey() -> String? {
        return "id"
    }
}





