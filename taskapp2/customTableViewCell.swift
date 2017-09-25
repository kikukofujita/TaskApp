//
//  customTableViewCell.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/25.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    @IBOutlet weak var celCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
