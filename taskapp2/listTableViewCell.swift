//
//  listTableViewCell.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/29.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit

class listTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listCategory: UILabel!
    
    @IBOutlet weak var list: UILabel!
    
//    let realm = try! Realm()
    
//    var list = try! Realm().objects(List.self)
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
