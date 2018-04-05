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
    @objc dynamic var currencyName : String = ""
    
    var rate : Double{
        return getRateFrom(currencyName: currencyName)
    }
    
    var baseRate : Double{
        return getBaseRate()
    }
    
    var baseAmount : Double{
        return getBaseAmount()
    }
    
    private var currencyFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    var displayAmount : String{
        return currencyFormatter.string(from: NSNumber(value: baseAmount * baseRate / rate)) ?? "$0"
    }
    
    // MARK: - Init
    convenience init(countryName: String, currencyName : String) {
        self.init()
        self.countryName = countryName
        self.currencyName = currencyName
    }
    
    // MARK: - Private Helpers
    private func getRateFrom(currencyName : String)->Double{
        let realm = try! Realm()
        if let latestRates = realm.object(ofType: LatestRatesRealmModel.self, forPrimaryKey: currencyName){
            return latestRates.currencyRate
        }
        return 0
    }
    
    private func getBaseRate()->Double{
        let realm = try! Realm()
        return DisplayBaseCurrencyRealmModel.defaultCurrency(in: realm).rate
    }
    private func getBaseAmount()->Double{
        let realm = try! Realm()
        return DisplayBaseCurrencyRealmModel.defaultCurrency(in: realm).amount
    }
    
    // MARK: -
    override static func primaryKey() -> String? {
        return "countryName"
    }
}

extension DisplayCurrencyRealmModel : IdentifiableType{
    var identity: String {
        return "\(countryName)"
    }
    
}



