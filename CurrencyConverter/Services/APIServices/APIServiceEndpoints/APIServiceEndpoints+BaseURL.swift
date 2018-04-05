//
//  APIServiceEndpoints+BaseURL.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import Moya

extension APIServiceEndpoints{
    
    var accessKey : String{
        return "?access_key=0766c02818103bbfb5e2acbbd0494631"
    }
    
    /// Usually we set the path here, but Fixer only seems to allow a full URL call
    /// so path returns an empty string, while baseUrl returns the respectively URL that is demanded
    var path: String {
        return ""
    }
    
    var baseURL: URL {
        switch self {
        case .getLatestRates:
            return URL(string: "http://data.fixer.io/api/latest\(accessKey)")!
        }
    }
}
