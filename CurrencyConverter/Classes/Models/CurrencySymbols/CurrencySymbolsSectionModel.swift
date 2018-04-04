//
//  CurrencySymbolsAnimatedSectionModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxDataSources

struct CurrencySymbolsAnimatedSectionModel {
    var header : String
    var items : [currencySymbolModel]
}

extension CurrencySymbolsAnimatedSectionModel : AnimatableSectionModelType{
    typealias Item = currencySymbolModel
    
    var identity: String {
        return header
    }
    
    init(original: CurrencySymbolsAnimatedSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
