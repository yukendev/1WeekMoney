//
//  AddGoalViewController.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/27.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var moneyField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 5
        container.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
    }
    
    @objc func pushButton_Animation(_ sender: UIButton){
           UIView.animate(withDuration: 0.1, animations:{ () -> Void in
               sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
           })
       }
           
           
       @objc func separateButton_Animation(_ sender: UIButton){
           UIView.animate(withDuration: 0.2, animations:{ () -> Void in
               sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
               sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
           })
       }
    
    @IBAction func addGoalAction(_ sender: Any) {
        print("beforeAction")
        if moneyField.text != "" {
            if moneyField.text?.prefix(1) == "0" {
                showAlert(title: "適切な金額を入力してください")
            }else{
                UserDefaults.standard.set(moneyField.text!, forKey: "goalMoney")
                print("notNil")
                dismiss(animated: true, completion: nil)
            }
        }else{
            showAlert(title: "金額を入力してください")
            print("nil")
        }
        print("afterAction")
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
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
