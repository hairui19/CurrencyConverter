//
//  DisplayRatesBaseRealmModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RealmSwift

class DisplayBaseCurrencyRealmModel : Object, DisplayCurrencyType{
    
    // MARK: - Properties
    @objc dynamic var countryName : String = ""
    @objc dynamic var rate : Double = 0
    @objc dynamic var amount : Double = 0
    
    private var currencyFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var displayAmount : String{
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
}
