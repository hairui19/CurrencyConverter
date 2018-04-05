//
//  CurrencyDisplayTableViewCell.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

class CurrencyDisplayTableViewCell: UITableViewCell,CellReuseIdentifiable {
    class func reuseIdentifier() -> String { return "CurrencyDisplayTableViewCell" }

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
