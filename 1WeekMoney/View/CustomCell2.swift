//
//  CustomCell2.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/29.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class CustomCell2: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    var uuid: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
