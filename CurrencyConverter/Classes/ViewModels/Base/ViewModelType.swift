//
//  ViewModelType.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation


protocol ViewModelType{
    associatedtype Input
    associatedtype Output
    func transform(input : Input) -> Output
}
