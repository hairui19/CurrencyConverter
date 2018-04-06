//
//  CountriesListViewModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxCocoa
import RealmSwift

class CurrencyListViewModel : ViewModelType{
    
    
    struct Input {
        let searchText : Driver<String>
        let addDisplayCurrency : Driver<CurrencySymbolModel>
        let configureBaseCurrency : Driver<(CurrencySymbolModel,DisplayBaseCurrencyRealmModel)>
    }
    
    struct Output {
        let currencySymbolSections : Driver<[CurrencySymbolsSectionModel]>
        let toDismissModule : Driver<Bool>
    }
    
    func transform(input: CurrencyListViewModel.Input) -> CurrencyListViewModel.Output {
        
        let currencySymbolsService = FileReaderServiceFactory.createGetSymbolsFileReaderService()
        let fileResult = currencySymbolsService.execute().asDriver(onErrorJustReturn: FileResult.fileError(FileReaderError.executeError))
        
        let currencySymbols = fileResult.map { (fileResult) -> CurrencySymbolsModel? in
            switch fileResult{
            case .fileData(let data):
                return data as? CurrencySymbolsModel
            default:
                return nil
            }
        }
        
        let currencySymbolsSections = Driver.combineLatest(
            currencySymbols,
            input.searchText)
        { [weak self] (currencySymbolsModel, searchText) -> [CurrencySymbolsSectionModel]? in
            guard let currencySymbolsModel = currencySymbolsModel else{
                return []
            }
            var filteredDictionary : [String : String]
            if searchText.count == 0{
                filteredDictionary = currencySymbolsModel.symbols
            }else{
                filteredDictionary = currencySymbolsModel.symbols.filter({ (arg) -> Bool in
                    return arg.value.range(of: searchText) != nil
                })
            }
            
            return self?.generateCountryListSections(currencySymbolsDic: filteredDictionary)
        }
            .filter{$0 != nil}
            .map{$0!}
        
        
        ///
        /// For Realm, we can add realm errors, to better monitor the process
        /// But due to time constraint, i will assume that realm will always be executed successfully
        /// thus, we always get a "true" value returned
        let completedStoringInRealm = input.addDisplayCurrency.map { (model) -> Bool in
            let realm = try! Realm()
            if let _ = realm.object(ofType: DisplayCurrencyRealmModel.self, forPrimaryKey: model.countryFullName){
                /// the item has already existed
                return true
            }
            let displayRatesModel = DisplayCurrencyRealmModel(countryName: model.countryFullName, currencyName: model.currencyName)
            try! realm.write {
                DisplayCurrenciesContainerRealmModel.defaultContainer(in: realm).orderedDisplayRateList.append(displayRatesModel)
            }
            return true
        }
        
        let completedConfiguringBaseCurrency = input.configureBaseCurrency.map { (arg) -> Bool in
            let currencyModel = arg.0
            let baseCurrency = arg.1
            let realm = try! Realm()
            try! realm.write {
                baseCurrency.countryName = currencyModel.countryFullName
                baseCurrency.currencyName = currencyModel.currencyName
                if !(baseCurrency.amount > 0) {
                    baseCurrency.amount = 1
                }
                
            }
            return true
        }
        
        let toDismissModule = Driver.from([
                completedStoringInRealm,
                completedConfiguringBaseCurrency
            ])
        .merge()
        
        return Output(
            currencySymbolSections: currencySymbolsSections,
            toDismissModule: toDismissModule)
    }
    
    
    
    private func generateCountryListSections(currencySymbolsDic : [String : String])->[CurrencySymbolsSectionModel]{
        var currencySymbolsSectionDic : [String : [CurrencySymbolModel]] = [:]
        
        ///Create Section Dictionary
        /// e.g key : "A", value : [CurrencySymbolModel]
        /// sort the original dictionary first, so that items in section will
        /// already in order when doing anothe sort later
        let sortedCurrencySymbolsDic = currencySymbolsDic.sorted { (arg1, arg2) -> Bool in
            arg1.value < arg2.value
        }
        for pair in sortedCurrencySymbolsDic{
            let startingAlphabet = "\(pair.value[pair.value.startIndex])".uppercased()
            let currencySymbolModel = CurrencySymbolModel(countryFullName:pair.value ,currencyName: pair.key)
            if let _ = currencySymbolsSectionDic[startingAlphabet]{
                currencySymbolsSectionDic[startingAlphabet]?.append(currencySymbolModel)
            }else{
                currencySymbolsSectionDic[startingAlphabet] = [currencySymbolModel]
            }
        }
        
        /// Arrange the dictionary in alphabetical order
        let sortedCurrencySymbolsSectionDic = currencySymbolsSectionDic.sorted { (arg1, arg2) -> Bool in
            return arg1.key < arg2.key
        }
        
        /// Create the sections
        var currencySymbolsSections : [CurrencySymbolsSectionModel] = []
        for pair in sortedCurrencySymbolsSectionDic{
            let currencySymbolsSection = CurrencySymbolsSectionModel(header: pair.key, items: pair.value)
            currencySymbolsSections.append(currencySymbolsSection)
        }
        
        return currencySymbolsSections
    }
    
}
