//
//  CurrencyListTableViewCell.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

class CurrencyListTableViewCell: UITableViewCell {

    
    class func reuseIdentifier() -> String { return "CurrencyListTableViewCell"}
    
    // MARK: - UIs & IBOulets
    @IBOutlet weak private var countryNameLabel: UILabel!
    @IBOutlet weak private var currencyNameLabel: UILabel!
    
    // MARK: - Observing Model
    var currencySymbolModel : CurrencySymbolModel?{
        didSet{
            guard let currencySymbolModel = currencySymbolModel else{
                return
            }
            countryNameLabel.text = currencySymbolModel.countryFullName
            currencyNameLabel.text = currencySymbolModel.currencyName
            
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
        currencyNameLabel.text = nil
    }
    
}
