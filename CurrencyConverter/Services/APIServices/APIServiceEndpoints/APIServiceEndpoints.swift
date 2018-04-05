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
    case getLatestRates
}

// MARK: - Description
extension APIServiceEndpoints : CustomStringConvertible{
    var description: String{
        switch self {
        case .getLatestRates:
            return "Get-Latest-Rates"
        }
    }
}

extension APIServiceEndpoints : TargetType{
 
    var method: Moya.Method {
        return .post
    }

    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
