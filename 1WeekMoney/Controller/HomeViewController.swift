//
//  HomeViewController.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/27.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    
    @IBOutlet weak var goalMoneyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstDay: UILabel!
    @IBOutlet weak var finalDay: UILabel!
    @IBOutlet weak var outMoneyLabel: UILabel!
    @IBOutlet weak var restMoneyLabel: UILabel!
    @IBOutlet weak var aveMoneyLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleStack: UIStackView!
    
    
    
    let dayArray: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var dateArray: [String] = ["initial"]
//    var dateArray = [String]()
    var allMoneyArray = [String]()
    var selectedDate = String()
    var selectedDay = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalMoneyButton.layer.cornerRadius = 5
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 5
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "date")
        headView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*96/896)
        
        goalMoneyButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        goalMoneyButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        
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
        setDateArray()
        setAllMoneyArray()
        setMoneyLabel()
        tableView.reloadData()
        
        firstDay.text = dateArray[0]
        finalDay.text = dateArray[6]
        
        if UserDefaults.standard.object(forKey: "goalMoney") != nil {
            goalMoneyButton.setTitle((UserDefaults.standard.object(forKey: "goalMoney") as? String)! + "円", for: .normal)
            label1.isHidden = false
            label2.isHidden = false
        }else{
            goalMoneyButton.setTitle("金額を設定", for: .normal)
            label1.isHidden = true
            label2.isHidden = true
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
    
    @IBAction func goalMoneyAction(_ sender: Any) {
        performSegue(withIdentifier: "addGoalMoney", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! CustomCell
        
        cell.selectionStyle = .none
        if getDay() == dayArray[indexPath.row] {
            cell.cellContainer.backgroundColor = UIColor.orange
        }else{
            cell.cellContainer.backgroundColor = UIColor.systemYellow
        }
        cell.dayLabel.text = dayArray[indexPath.row]
        cell.moneyLabel.text = allMoneyArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        selectedDate = dateArray[indexPath.row]
        selectedDay = dayArray[indexPath.row]
        performSegue(withIdentifier: "date", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "date" {
            let dateVC = segue.destination as! DateViewController
            dateVC.dateLabelText = selectedDate
            dateVC.dayLabelText = selectedDay
        }
    }
    
    func getToday() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "MM/dd"
        
        let date = dateFormatter.string(from: Date())
        let today = dateFormatter.date(from: date)!
        
        print("today: \(date)")
        
        return today
    }

    func startOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "MM/dd"
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEE", options: 0, locale: Locale.current)
        let day = formatter.string(from: Date())
        
        if day == "Sun" {
            let stringDate = dateFormatter.string(from: Date())
            let today = dateFormatter.date(from: stringDate)!
            let startDate = Calendar.current.date(byAdding: .day, value: -6, to: today)!
            let date = dateFormatter.string(from: startDate)
            print("startOfWeek: \(date)")
            return date
        }else{
            let comp = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())
            let sunday = Calendar.current.date(from: comp)!
            let startDate = Calendar.current.date(byAdding: .day, value: 1, to: sunday)!
            let date = dateFormatter.string(from: startDate)
            print("startOfWeek: \(date)")
            return date
        }
    }
    
    func setDateArray() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "MM/dd"
        let startDate = dateFormatter.date(from: startOfWeek())!
        let stringStartDate = dateFormatter.string(from: startDate)
        if UserDefaults.standard.object(forKey: "startDate") != nil {
            let userDefaults = UserDefaults.standard.object(forKey: "startDate") as! String
            if userDefaults != stringStartDate {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
            }
        }
        UserDefaults.standard.set(stringStartDate, forKey: "startDate")
        dateArray.removeAll()
        for count in 0...6 {
            let date = Calendar.current.date(byAdding: .day, value: count, to: startDate)!
            let dateString = dateFormatter.string(from: date)
            dateArray.append(dateString)
        }
        
        print(dateArray)
    }
    
    func getDay()-> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ja_JP")
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "EE"
        
        let today = dateFormatter.string(from: Date())
        
        return today
    }
    
    func setAllMoneyArray() {
        allMoneyArray.removeAll()
        dateArray.forEach { (date) in
            let realm = try! Realm()
            let list = realm.objects(MoneyList.self)
            var allMoney: Int = 0
            
            if list.count != 0 {
                for listData in list {
                    if listData.date == date {
                        allMoney = allMoney + Int(listData.money)!
                    }
                }
            }
            
            allMoneyArray.append(String(allMoney))
        }
    }
    
    func setMoneyLabel() {
        if UserDefaults.standard.object(forKey: "goalMoney") != nil {
            let goalMoney = UserDefaults.standard.object(forKey: "goalMoney") as! String
            var totalMoney: Int = 0
            allMoneyArray.forEach { (money) in
                totalMoney = totalMoney + Int(money)!
            }
            
            outMoneyLabel.text = String(totalMoney) + "円"
            let restMoney: Int = Int(goalMoney)! - totalMoney
            if restMoney < 0 {
                restMoneyLabel.text = "0円"
                aveMoneyLabel.text = "0円"
            }else{
                restMoneyLabel.text = String(restMoney) + "円"
                aveMoneyLabel.text = String(aveMoney(totalMoney: restMoney)) + "円"
            }
            
        }else{
            outMoneyLabel.text = ""
            restMoneyLabel.text = ""
            aveMoneyLabel.text = ""
        }
    }
    
    func aveMoney(totalMoney: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEE", options: 0, locale: Locale.current)
        let day = formatter.string(from: Date())
        
        var aveMoney = Int()
        
        switch day {
        case "Mon":
            print("Mon")
            aveMoney = totalMoney/7
        case "Tue":
            print("Tue")
            aveMoney = totalMoney/6
        case "Wed":
            print("Wed")
            aveMoney = totalMoney/5
        case "Thu":
            print("Thu")
            aveMoney = totalMoney/4
        case "Fri":
            print("Fri")
            aveMoney = totalMoney/3
        case "Sat":
            print("Sat")
            aveMoney = totalMoney/2
        case "Sun":
            print("Sun")
            aveMoney = totalMoney
        default:
            print("error")
        }
        
        return aveMoney
    }

  
    
}
