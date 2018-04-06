//
//  AmountEntryViewModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class AmountEntryViewModel : ViewModelType{
    
    struct Input {
        let accumulator : Driver<String>
        let convertButton : Driver<()>
    }
    
    struct Output{
        let enableConvertButton : Driver<Bool>
        let convert : Driver<Bool>
    }
    

    func transform(input: AmountEntryViewModel.Input) -> AmountEntryViewModel.Output {
        
        let result = input.accumulator
            .map { (text) -> Double in
                var accumulator = text
                guard let lastChar = accumulator.last else{
                    return 0
                }
                if lastChar == "."{
                    accumulator.removeLast()
                    
                }
                guard let doubleValue = Double(accumulator) else{
                    fatalError("Should be able to conver to doubleValue")
                }
                return doubleValue
            }
        
        let enableConvertButton = result.map { (value) -> Bool in
            return value > 0
        }
        .startWith(false)
        
        let convert = input.convertButton
        .withLatestFrom(result)
            .map { (value) -> Bool in
                let realm = try! Realm()
                let baseCurrecy = DisplayBaseCurrencyRealmModel.defaultCurrency(in: realm)
                try! realm.write {
                    baseCurrecy.amount = value
                }
                return true
        }
        
        return Output(enableConvertButton: enableConvertButton,
                      convert: convert)
    }
    
}
