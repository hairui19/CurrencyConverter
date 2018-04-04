//
//  APIServiceEndpoints+BaseURL.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import Moya

extension TargetType{
    var baseURL: URL {
        return URL(string: "http://data.fixer.io/api/")!
    }
}
