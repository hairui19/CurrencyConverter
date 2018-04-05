//
//  CurrencySymbolsAnimatedSectionModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxDataSources

struct CurrencySymbolsSectionModel {
    var header : String
    var items : [CurrencySymbolModel]
}

extension CurrencySymbolsSectionModel : SectionModelType{
    typealias Item = CurrencySymbolModel
    
    init(original: CurrencySymbolsSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
