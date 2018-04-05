//
//  CountriesListViewModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxCocoa

class CurrencyListViewModel : ViewModelType{
    
    
    struct Input {
        let searchText : Driver<String>
    }
    
    struct Output {
        let currencySymbolSections : Driver<[CurrencySymbolsSectionModel]>
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
        
        
        return Output(currencySymbolSections: currencySymbolsSections)
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
