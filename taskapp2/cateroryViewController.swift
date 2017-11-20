//
//  cateroryViewController.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/10/02.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift

class cateroryViewController: UIViewController {
    
    @IBOutlet weak var categoryText: UITextField!
    
    var category = Category()
    let realm = try! Realm()
    
    @IBAction func addButton(_ sender: Any) {
        
        try! realm.write {
            self.category.classCategory = self.categoryText.text!
            if categoryArray.count != 0 {
                self.category.categoryId = categoryArray.max(ofProperty: "categoryId")! + 1
            }
            self.realm.add(self.category, update: true)
        }
    }
    
    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "classCategory", ascending: false)
    
    var x:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
