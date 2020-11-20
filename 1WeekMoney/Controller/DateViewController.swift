//
//  DateViewController.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/27.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class DateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var dateLabelText = String()
    var dayLabelText = String()
    
    var contentList = [String]()
    var moneyList = [String]()
    var uuidList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyLabel.layer.cornerRadius = 5
        moneyLabel.clipsToBounds = true
        tableView.layer.cornerRadius = 5
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CustomCell2", bundle: nil), forCellReuseIdentifier: "moneyList")
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.layer.cornerRadius = 5
        
        dateLabel.text = dateLabelText
        dayLabel.text = dayLabelText
        
        addButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        addButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        let gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        gadBannerView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 50)
        gadBannerView.adUnitID = "ca-app-pub-7065554389714042/1081367987"
        gadBannerView.rootViewController = self
        
        let request = GADRequest()
        gadBannerView.load(request)
        
        self.view.addSubview(gadBannerView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentList.removeAll()
        moneyList.removeAll()
        uuidList.removeAll()

        let realm = try! Realm()
        let list = realm.objects(MoneyList.self)

        for listData in list {
            if listData.date == dateLabelText {
                contentList.insert(listData.content, at: 0)
                moneyList.insert(listData.money, at: 0)
                uuidList.insert(listData.uuid, at: 0)
            }
        }
        
        print("配列の数 \(moneyList.count)")
        
        totalMoney()
        
        tableView.reloadData()
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
    

    @IBAction func returnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moneyList", for: indexPath) as! CustomCell2
        
        cell.selectionStyle = .none

        cell.titleLabel.text = contentList[indexPath.row]
        cell.moneyLabel.text = moneyList[indexPath.row] + "円"
        cell.uuid = uuidList[indexPath.row]
        
        return cell
    }
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "addMoney", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMoney" {
            let addVC = segue.destination as! AddMoneyViewController
            addVC.dateLabelText = dateLabelText
            addVC.dayLabelText = dayLabelText
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("delete!\(indexPath.row)番目")
        print("\(contentList[indexPath.row])")
        print("\(moneyList[indexPath.row])")
        print("\(uuidList[indexPath.row])")
        
        let realm = try! Realm()
        let list = realm.objects(MoneyList.self)
        let deletedContent = realm.objects(MoneyList.self).filter("uuid == '\(uuidList[indexPath.row])'")
        try! realm.write {
            realm.delete(deletedContent)
        }
        
        contentList.removeAll()
        moneyList.removeAll()
        uuidList.removeAll()
        
        for listData in list {
            if listData.date == dateLabelText {
                contentList.insert(listData.content, at: 0)
                moneyList.insert(listData.money, at: 0)
                uuidList.insert(listData.uuid, at: 0)
            }
        }
        
        totalMoney()
        
        tableView.reloadData()
    }
    
    func totalMoney() {
        var totalMoney = Int()
        
        moneyList.forEach { (money) in
            totalMoney = totalMoney + Int(money)!
        }
        
        print("総額　\(totalMoney)")
        
        moneyLabel.text = String(totalMoney) + "円"
    }
    
}
