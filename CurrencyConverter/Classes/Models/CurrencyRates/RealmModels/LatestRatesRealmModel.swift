//
//  LatestRatesModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class LatestRatesRealmModel : Object{
    
    // MARK: - Properties
    @objc dynamic var currencyName : String = ""
    @objc dynamic var currencyRate : Double = 0
    
    
    // MARK: - Init
    convenience required init(currencyName : String, currencyRate : Double){
        self.init()
        self.currencyName = currencyName
        self.currencyRate = currencyRate
    }
    
    // MARK: - Functions
    override static func primaryKey() -> String? {
        return "currencyName"
    }
    
}
