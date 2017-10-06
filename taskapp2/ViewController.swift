//
//  ViewController.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/23.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 20171001<

    @IBOutlet weak var searchText: UITextField!
    
    
//    let list = ["", "001", "002", "003"]
    // >1001
    let category = Category()

    var task: Task!
    @IBAction func reset(_ sender: Any) {
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
        searchText.text = ""
        searchText.endEditing(true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
//        print(taskArray)
        searchText.endEditing(true)
    }

    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    // DB内のタスクが格納されるリスト
    // 日付近い順\順でソート：　降順
    // 以降内容とアップデートするとリスト内は自動的に更新される
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    
    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "classCategory", ascending: false)
    
    func dataList() -> [String] {
        var list = [String]()
        
        categoryArray.forEach { (category: Category) in
            list.append(category.classCategory)
        }
        return list
    }

    
 // カテゴリを選択時の呼び出しメソッド
    func selectCategory() {
        let searchText: String = self.searchText!.text!
        var categoryIndex = 0
        
        if searchText != "" {
            if let pickerView = self.searchText.inputView as? UIPickerView {
                categoryIndex = pickerView.selectedRow(inComponent: 0)
            }
            let category = categoryArray[categoryIndex]
            let predicate = NSPredicate(format: "category.categoryId = %ld", category.categoryId)
            taskArray = realm.objects(Task.self).filter(predicate)
            tableView.reloadData()
            }
        self.searchText.endEditing(true)
        }
    
    // pickerViewで選択されているcategoryをtask.categoryに設定する
    
    
/*
    // キャンセルボタンを押された時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.delegate = self
        tableView.dataSource = self
        // 20171001<
        let pickerView = UIPickerView()

        pickerView.dataSource = self
        pickerView.delegate = self
        searchText.inputView = pickerView
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancel))
        toolbar.setItems([cancelItem, doneItem],animated: true)
        
/*
        // 何も入力されていなくてもReturnキーを押せるようにするtestSearchBar.enablesReturnKeyAutomatically = false
*/
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList().count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataList()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.searchText.text = dataList()[row]
        selectCategory()
//        searchText.endEditing(true)
    }
    
    func cancel() {
        self.searchText.text = ""
        self.searchText.endEditing(true)
    }
    
    func done() {
        self.searchText.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count

    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なcell　を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customTableViewCell
        
        
        // Cellに値を設定する
        let task = taskArray[indexPath.row]
        cell.cellTitle.text = task.title
        cell.celCategory.text = task.category?.classCategory
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date as Date)
        cell.cellSubtitle.text = dateString
        
        return cell
    }
    
    // MARK: UITableViewDelegate プロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)

    }
    
    // セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            // 削除されたタスクを取得する
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for reqest in requests {
                    print("/-------------------")
                    print(reqest)
                    print("/-------------------")
                }
            }
        }
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = NSDate()
            
            if taskArray.count != 0 {
                task.id = taskArray.max(ofProperty: "id")! + 1
            }

            inputViewController.task = task
        }
    }
    
    // 入力画面から戻ってきた時に　TableView を更新される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskArray = try!Realm().objects(Task.self).sorted(byKeyPath: "date",ascending: false)
        tableView.reloadData()
    }
}

