//
//  DisplayRatesAnimatedSectionModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxDataSources

struct DisplayCurrenciesAnimatedSectionModel{
    var header : String
    var items : [DisplayCurrencyRealmModel]
}

extension DisplayCurrenciesAnimatedSectionModel : AnimatableSectionModelType{
    typealias Item = DisplayCurrencyRealmModel
    
    var identity: String {
        return header
    }
    
    init(original: DisplayCurrenciesAnimatedSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
