//
//  CurrencyListViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import XCTest
@testable import CurrencyConverter
import RxCocoa
import RealmSwift
import RxSwift

class CurrencyListViewModelTests: XCTestCase {
    
    var currencyListViewModel : CurrencyListViewModel!
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        currencyListViewModel = CurrencyListViewModel()
    }
    
    override func tearDown() {
       
        currencyListViewModel = nil
        super.tearDown()
    }
    
    func testCurrencyListViewModel(){
        let realm = try! Realm()
        let searchDriver = Driver.just("ad")
        let currencySymbolModel = CurrencySymbolModel(countryFullName: "Singapore", currencyName: "SGD")
        let displayBaseCurrencyRealmModel = DisplayBaseCurrencyRealmModel.defaultCurrency(in: realm)
        
        let addDisplayCurrency = Driver.just(currencySymbolModel)
        let configureBaseCurrency = Driver.just((currencySymbolModel, displayBaseCurrencyRealmModel))
        
        let input = CurrencyListViewModel.Input(
            searchText: searchDriver,
            addDisplayCurrency: addDisplayCurrency,
            configureBaseCurrency: configureBaseCurrency)
        
        let output = currencyListViewModel.transform(input: input)
        
        
        output.currencySymbolSections.drive(onNext: { (sections) in
            XCTAssertEqual(sections.count, 4)
            XCTAssertEqual(sections[3].items.count, 1)
            XCTAssertEqual(sections[1].items.count, 1)
            XCTAssertEqual(sections[2].items[0].countryFullName, "Salvadoran Colón")
            XCTAssertEqual(sections[0].items[0].countryFullName, "Bangladeshi Taka")
            
        })
        .disposed(by: bag)
        
    }
    
    func testIndexedSectionsGeneration(){
        let sections = currencyListViewModel.generateCountryListSections(currencySymbolsDic: [
            "AED": "United Arab Emirates Dirham",
            "BAM": "Bosnia-Herzegovina Convertible Mark",
            "CUC": "Cuban Convertible Peso",
            "DZD": "Algerian Dinar",
            "EGP": "Egyptian Pound",
            "GNF": "Guinean Franc",
            "IDR": "Indonesian Rupiah",
            "ZMK": "Zambian Kwacha (pre-2013)",
            ])
        
        XCTAssertEqual(sections[0].items[0].countryFullName, "Algerian Dinar")
        XCTAssertEqual(sections[1].items[0].countryFullName, "Bosnia-Herzegovina Convertible Mark")
    }
    
}
