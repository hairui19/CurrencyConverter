//
//  RatesDisplayRealmModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class DisplayCurrencyRealmModel : Object, DisplayCurrencyType{

    // MARK: - Properties
    @objc dynamic var countryName : String = ""
    @objc dynamic var rate : Double = 0
    @objc dynamic var amount : Double = 0
    @objc dynamic var comparingRate : Double = 0
    @objc dynamic var comparingAmount : Double = 0
    
    var displayAmount : String{
        return "\(rate)"
    }
    
    // MARK: - Init
    convenience init(countryName: String, rate : Double) {
        self.init()
        self.countryName = countryName
        self.rate = rate
    }
    
    // MARK: - Functions
    override static func primaryKey() -> String? {
        return "countryName"
    }
}

extension DisplayCurrencyRealmModel : IdentifiableType{
    var identity: String {
        return "\(countryName)"
    }
    
}



