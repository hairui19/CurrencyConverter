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
    
    // MARK: - Proproties
    private let accumulator = Variable<String>("")
    private var isAtTheBeginningOfTypng : Bool = true
    
    struct Input {
        let digit : Driver<Int>
    }
    
    struct Output{
        
    }
    

    func transform(input: AmountEntryViewModel.Input) -> AmountEntryViewModel.Output {
        return Output()
    }
    
}
