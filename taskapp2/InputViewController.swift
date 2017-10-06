//
//  InputViewController.swift
//  taskapp2
//
//  Created by 藤田貴久子 on 2017/09/23.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UserNotifications
import UIKit
import RealmSwift

class InputViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!


    // 20170930

//    var dataList = ["999","001","002","003","004"]
    var task: Task!

    let category = Category()
    
    let realm = try! Realm()
    
    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "classCategory", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // <20170930
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        categoryTextField.inputView = pickerView
        pickerView.showsSelectionIndicator = true
        
        // カテゴリのindexを求めて、pickerに反映する
        var categoryIndex = 0
        if let category = task.category {
            categoryIndex = categoryArray.index(of: category) ?? 0
            
            
        }
        pickerView.selectRow(categoryIndex, inComponent: 0, animated: false)
        
        
        _ = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:
            self, action: #selector(disimissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        categoryTextField.text = task.category?.classCategory
        
    }
    
    func dataList() -> [String] {
        var list = [String]()
        
        categoryArray.forEach { (category: Category) in
            list.append(category.classCategory)
        }
        return list
    }
    
    
/*    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueから遷移先のcategoryViewControllerを取得
        let cateroryViewController: cateroryViewController = segue.destination as! cateroryViewController
        
        // 遷移先のCategoryViewControllerで宣言しているxに値を代入して渡す
        cateroryViewController.x = "a"
    }   */

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
        self.categoryTextField.text = dataList()[row]
        categoryTextField.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
    // 20170930 Pickerviewの列を１とする
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ namePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    // 表示する文字列を指定
    // Pickeriewに表示する配列の要素数を設定
    func picherView(namePickerview: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return dataList[row]
    }
    // ラベル表示
    func pickerView(namePickerview: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = dataList[row]
    }
    // 20170930 up
*/
    override func viewWillDisappear(_ animated: Bool) {
        
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            
            // pickerViewで選択されているcategoryをtask.categoryに設定する
            if let pickerView = categoryTextField.inputView as! UIPickerView! {
                if categoryArray.count > 0 {
                    let categoryIndex = pickerView.selectedRow(inComponent: 0)
                    self.task.category = categoryArray[categoryIndex]
                }
            }
            self.realm.add(self.task, update: true)
            
        }
        
        // Categoryをself.task.category
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents     //bodyが空だと音しか出ない
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtrigger (日付マッチ）を作成
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が　nil ならローカル通知登録成功を表示。error が存在すればerrorを表示
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/----------------")
                print(request)
                print("/----------------")
            }
        }
    }
    
    func disimissKeyboard() {
        view.endEditing(true)   // キーボードを閉じる
    }
    
    func CGRectMake(_ X: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: X, y: y, width: width, height: height)
    }
    
    // -------------------------------------------
    // 各セルを選択した時に実行されるメソッド

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
