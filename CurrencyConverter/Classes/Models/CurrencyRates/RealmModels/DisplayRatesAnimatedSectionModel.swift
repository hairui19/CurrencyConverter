//
//  DisplayRatesAnimatedSectionModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxDataSources

struct DisplayRatesAnimatedSectionModel{
    var header : String
    var items : [DisplayRatesRealmModel]
}

extension DisplayRatesAnimatedSectionModel : AnimatableSectionModelType{
    typealias Item = DisplayRatesRealmModel
    
    var identity: String {
        return header
    }
    
    init(original: DisplayRatesAnimatedSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
