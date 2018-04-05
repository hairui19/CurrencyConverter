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
    
    @objc dynamic var key = "DisplayBaseCurrencyRealmModel.key"
    static var conveniencePrimaryKey = "DisplayBaseCurrencyRealmModel.key"
    let orderedDisplayRateList = List<DisplayCurrencyRealmModel>()
    
    // MARK: -
    override static func primaryKey() -> String? {
        return "key"
    }
    
    
    // MARK: - Etc
    /// This is to fetch the default container
    /// If the default container is not available when we try to retrieve it
    /// It will be created on the spot
    private static func createDefaultBaseCurrency(in realm: Realm) -> DisplayBaseCurrencyRealmModel{
        let baseCurrency = DisplayBaseCurrencyRealmModel()
        try! realm.write {
            realm.add(baseCurrency)
        }
        return baseCurrency
    }
    
    @discardableResult
    static func defaultCurrency(in realm: Realm) -> DisplayBaseCurrencyRealmModel {
        return realm.object(ofType: DisplayBaseCurrencyRealmModel.self, forPrimaryKey: "DisplayBaseCurrencyRealmModel.key")
            ?? createDefaultBaseCurrency(in: realm)
    }
}
