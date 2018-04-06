//
//  MainViewModel.swift
//  CurrencyConverterTests
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import CurrencyConverter

class MainViewModelTests: XCTestCase {

    var viewModel : MainViewModel!
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        viewModel = MainViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testMainViewModel(){
        
        let loadAPI = Driver.just(true)
        let firstDisplayCurrency = DisplayCurrencyRealmModel(countryName: "Singapore Dollar", currencyName: "SGD")
        let secondDisplayCurrency = DisplayCurrencyRealmModel(countryName: "Chinese Yuan", currencyName: "CNY")
        let displayRates = Driver.just([firstDisplayCurrency, secondDisplayCurrency])
        let baseCurrency = Driver.just(DisplayBaseCurrencyRealmModel(countryName: "Singapore Dollar", currencyName: "Dollar"))
        let input = MainViewModel.Input(
            loadAPI: loadAPI,
            displayRates: displayRates,
            baseCurrency: baseCurrency)
        
        let output = viewModel.transform(input: input)
        
        output.displayRatesSection.drive(onNext: { (sections) in
            XCTAssertEqual(sections.count, 1)
            XCTAssertEqual(sections[0].items.count, 2)
            XCTAssertEqual(sections[0].items[0].countryName, "Singapore Dollar")
            XCTAssertEqual(sections[0].items[1].countryName, "Chinese Yuan")
            
        })
        .disposed(by: bag)
        
        
        output.shouldDisplayBaseCurrency.drive(onNext: { (shouldDisplay) in
            XCTAssertEqual(shouldDisplay, true)
        })
        .disposed(by: bag)
        
    }
    
    
    
}
