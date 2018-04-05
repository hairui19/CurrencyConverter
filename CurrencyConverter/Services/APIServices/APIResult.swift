//
//  APIResult.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation

enum APIResult{
    case apiError(APIError)
    case apiData(Any)
    case isLoading
}

enum APIError{
    case generalError(title:String, message : String)
    case statusCodeInvalid
    case mappingError
    case executeError
}
