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
    // 20170930 UIPickerViewDataSource, UIPickerViewDelegate追加　⬆︎
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    // 20170930
    @IBOutlet weak var dataPicker: UIPickerView!
    var dataList = ["001","002","003","004"]
    var pickerView: UIPickerView = UIPickerView()
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseidentifier: "Cell")
        return cell
    }
    func tableView(tabaleView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // up
*/

    var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // <20170930
        dataPicker.dataSource = self
        dataPicker.delegate = self
        // はじめに表示する項目
        dataPicker.selectedRow(inComponent: 0)
        
        pickerView.showsSelectionIndicator = true
        self.categoryTextField.inputView = pickerView
        // 20170930>
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:
            self, action: #selector(disimissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        categoryTextField.text = task.category
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = dataList[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.category = self.categoryTextField.text!
            self.task.date = self.datePicker.date as NSDate
            self.realm.add(self.task, update: true)
        }

        
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
