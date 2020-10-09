//
//  AddMoneyViewController.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/27.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import RealmSwift

class AddMoneyViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var listField: UITextField!
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    
    var dateLabelText = String()
    var dayLabelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 5
        container.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateLabel.text = dateLabelText
        dayLabel.text = dayLabelText
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        if listField.text == "" || moneyField.text == "" {
            showAlert(title: "すべて入力してください")
        }else{
            if moneyField.text?.prefix(1) == "0"{
                showAlert(title: "適切な金額を入力してください")
            }else{
//                realmに保存
                let list = MoneyList()
                list.date = dateLabelText
                list.content = listField.text!
                list.money = moneyField.text!
                list.uuid = NSUUID().uuidString
                
                let realm = try! Realm()
                print("これが俺の忍道だ！！")
                print(Realm.Configuration.defaultConfiguration.fileURL!)

                try! realm.write {
                    realm.add(list)
                }
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func pushButton_Animation(_ sender: UIButton){
           UIView.animate(withDuration: 0.1, animations:{ () -> Void in
               sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
           })
       }
           
           
       @objc func separateButton_Animation(_ sender: UIButton){
           UIView.animate(withDuration: 0.2, animations:{ () -> Void in
               sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
               sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
           })
       }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    


}
