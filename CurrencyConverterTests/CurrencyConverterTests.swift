//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import XCTest
import RealmSwift
import RxCocoa
import RxSwift
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    var viewModel : AmountEntryViewModel!
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
       viewModel = AmountEntryViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    func testAmountEntryViewModelCaseOne(){
        let accumulator = Driver.just("11.")
        let convertButton = Driver.just(())
        let operand = Driver.just("500")
        let input = AmountEntryViewModel.Input(
            accumulator: accumulator,
            convertButton: convertButton,
            operand: operand)
    
        let output = viewModel.transform(input: input)
        output.isFastOperation.drive(onNext: { (isFastOperation) in
             XCTAssertEqual(isFastOperation, true)
        })
        .disposed(by: bag)
        
        output.enableConvertButton.skip(1).drive(onNext: { (enable) in
            XCTAssertEqual(enable, true)
        })
        .disposed(by: bag)
        
    }
    
    func testAmountEntryViewModelCaseTwo(){
        let accumulator = Driver.just("0")
        let convertButton = Driver.just(())
        let operand = Driver.just("C")
        let input = AmountEntryViewModel.Input(
            accumulator: accumulator,
            convertButton: convertButton,
            operand: operand)
        
        let output = viewModel.transform(input: input)
        
        output.isFastOperation.drive(onNext: { (isFastOperation) in
            XCTAssertEqual(isFastOperation, false)
        })
            .disposed(by: bag)
        
        output.uiOperation.drive(onNext: { (operation) in
            switch operation{
            case .clear:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        })
        .disposed(by: bag)
        
        output.enableConvertButton.skip(1).drive(onNext: { (enable) in
            XCTAssertEqual(enable, false)
        })
            .disposed(by: bag)
    }
    
}
