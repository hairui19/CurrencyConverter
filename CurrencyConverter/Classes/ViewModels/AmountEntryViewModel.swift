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

class AmountEntryViewModel : ViewModelType{
    
    struct Input {
        let currencyName : String
        let accumulator : Driver<String>
        let convertButton : Driver<()>
    }
    
    struct Output{
        let enableConvertButton : Driver<Bool>
    }
    

    func transform(input: AmountEntryViewModel.Input) -> AmountEntryViewModel.Output {
        
        let result = input.accumulator
            .map { (text) -> Double in
                let newText = text.replacingOccurrences(of: ".", with: "")
                guard let doubleValue = Double(newText) else{
                    fatalError("Should be able to conver to doubleValue")
                }
                return doubleValue
            }
        
        let enableConvertButton = result.map { (value) -> Bool in
            return value > 0
        }
        
        input.convertButton.map { (_) -> Void in
            
        }
        
        return Output(enableConvertButton: enableConvertButton)
    }
    
}
