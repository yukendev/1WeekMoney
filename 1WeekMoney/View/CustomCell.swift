//
//  CustomCell.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/27.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainer.layer.cornerRadius = 5
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
