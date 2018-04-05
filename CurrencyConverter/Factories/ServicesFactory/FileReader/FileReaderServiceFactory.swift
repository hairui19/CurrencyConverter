//
//  FileReaderServiceFactory.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import ObjectMapper

struct FileReaderServiceFactory {
    private init() {}
    
    static func createGetSymbolsFileReaderService()->FileReaderService{
        let service = FileReaderServiceImp(fileEndPoint: .currencySymbols) { (data) -> Any in
            let currencySymbols = try! Mapper<CurrencySymbolsModel>().map(JSONObject: data)
            return currencySymbols
        }
        return service
    }
}
