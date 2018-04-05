//
//  CurrencyRatesModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

struct CurrencyRatesModel : ImmutableMappable{
    let timestamp : Double
    let base : String
    var rates : [String : Double] = [:]{
        didSet{
            print("never called in here?")
            
        }
    }
    
    init(map: Map) throws {
        self.timestamp = try map.value("timestamp")
        self.base = try map.value("base")
        self.rates = try map.value("rates")
    }
}
