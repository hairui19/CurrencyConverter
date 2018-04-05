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

    @IBOutlet weak private var countryNameLabel: UILabel!
    @IBOutlet weak private var amountLabel: UILabel!
    
    // MARK: - Observing Model
    var ratesModel : DisplayCurrencyRealmModel?{
        didSet{
            guard let ratesModel = ratesModel else{
                return
            }
            
            countryNameLabel.text = ratesModel.countryName
            amountLabel.text = ratesModel.displayAmount
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countryNameLabel.text = nil
        amountLabel.text = nil
    }
    
}
