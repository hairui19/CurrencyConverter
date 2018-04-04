//
//  APIServiceFactory.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import ObjectMapper

struct APIServiceFactory {
    private init() {}
    
    static func createGetLatestRatesService()->APIService{
        let service = APIServiceImp(endPoint: .getLatestRates) { (data) -> Any in
            let rates = try! Mapper<SRVerificationCodeModel>().map(JSONObject: generalAPIModel.data!)
        }
    }
}
