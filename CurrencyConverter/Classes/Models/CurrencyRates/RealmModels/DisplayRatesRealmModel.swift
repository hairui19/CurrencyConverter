//
//  RatesDisplayRealmModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RealmSwift

class DisplayRatesRealmModel : Object{

    // MARK: - Properties
    @objc dynamic var countryName : String = ""
    @objc dynamic var ownRate : Double = 0
    @objc dynamic var ownAmount : Double = 0
    @objc dynamic var comparingRate : Double = 0
    @objc dynamic var comparingAmount : Double = 0
    @objc dynamic var index : Int = 0 
    
    var amount : String{
        return "\(ownRate)"
    }
    
    // MARK: - Init
    convenience init(countryName: String, ownRate : Double) {
        self.init()
        self.countryName = countryName
        self.ownRate = ownRate
    }

}
