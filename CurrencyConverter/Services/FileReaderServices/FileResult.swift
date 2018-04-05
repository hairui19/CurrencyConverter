//
//  FileResult.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation

enum FileResult{
    case fileError(FileReaderError)
    case fileData(Any)
    case isLoading
}


enum FileReaderError : Error{
    case invalidFileName
    case invalidData
    case executeError
}
