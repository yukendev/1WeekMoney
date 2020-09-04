//
//  MoneyList.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/09/02.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import Foundation
import RealmSwift

class MoneyList: Object {
    @objc dynamic var date = ""
    @objc dynamic var content = ""
    @objc dynamic var money = ""
    @objc dynamic var uuid = ""
}
