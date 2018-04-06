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
        let operand : Driver<String>
    }
    
    struct Output{
        let enableConvertButton : Driver<Bool>
        let convert : Driver<Bool>
        let isFastOperation : Driver<Bool>
        let uiOperation : Driver<Operations>
    }
    
    enum Operations{
        case clear
        case delete
        case decimal
        case fastOperation(Double)
    }
    
    
    func transform(input: AmountEntryViewModel.Input) -> AmountEntryViewModel.Output {
        
        let operation = input.operand.map { (operand) -> Operations in
            switch operand {
            case "C":
                return Operations.clear
            case "⬅︎":
                return Operations.delete
            case ".":
                return Operations.decimal
            case "1,000":
                return Operations.fastOperation(1000)
            case "500",
                 "100",
                 "10",
                 "1"
                :
                return Operations.fastOperation(Double(operand)!)
            default:
                fatalError("Someone unknown operand pressed")
            }
        }
        
        let isFastOperation = operation.map { (operation) -> Bool in
            switch operation{
            case .fastOperation(let amount):
                let realm = try! Realm()
                let baseCurrecy = DisplayBaseCurrencyRealmModel.defaultCurrency(in: realm)
                try! realm.write {
                    baseCurrecy.amount = amount
                }
                return true
            default:
                return false
            }
        }
            .filter{$0}
        
        let uiOperation = operation.map { (operation) -> Operations? in
            switch operation{
            case .fastOperation:
                return nil
            default:
                return operation
            }
        }
            .filter{$0 != nil}
            .map{$0!}
        
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
                      convert: convert,
                      isFastOperation: isFastOperation,
                      uiOperation: uiOperation)
    }
    
}
