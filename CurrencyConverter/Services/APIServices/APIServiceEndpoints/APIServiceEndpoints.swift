//
//  APIServiceEndpoints.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import Moya

enum APIServiceEndpoints{
    case getSymbols
}

extension APIServiceEndpoints : TargetType{
    
    var path: String {
        switch self {
        case .getSymbols:
            return "symbols"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
