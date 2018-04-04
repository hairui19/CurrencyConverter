//
//  CurrencySymbolModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import ObjectMapper

struct CurrencySymbolsModel : ImmutableMappable {
    
    
    let symbols : [String : String]
    
    init(map: Map) throws {
        self.symbols = try map.value("symbols")
    }
}
