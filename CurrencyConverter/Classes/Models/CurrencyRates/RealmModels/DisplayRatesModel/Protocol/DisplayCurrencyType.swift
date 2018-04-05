//
//  DisplayRatesType.swift
//  CurrencyConverter
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation

protocol DisplayCurrencyType{
    var countryName : String {get set}
    var amount : Double {get set}
    var rate : Double {get set}
}
