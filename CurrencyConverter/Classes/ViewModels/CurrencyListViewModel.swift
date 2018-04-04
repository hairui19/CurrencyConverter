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
        
    }
    
    struct Output {
        let currencySymbolSections : Driver<[CurrencySymbolsSectionModel]>
    }
    
    func transform(input: CurrencyListViewModel.Input) -> CurrencyListViewModel.Output {
        
        let currencySymbolsService = FileReaderServiceFactory.createGetSymbolsFileReaderService()
        let fileResult = currencySymbolsService.execute().asDriver(onErrorJustReturn: FileResult.fileError(FileReaderError.unknowError))
        
        let currencySymbols = fileResult.map { (fileResult) -> CurrencySymbolsModel? in
            switch fileResult{
            case .fileData(let data):
                return data as? CurrencySymbolsModel
            default:
                return nil
            }
        }
    
        let currencySymbolsSections = currencySymbols.map { [weak self] (currencySymbolsModel) -> [CurrencySymbolsSectionModel]? in
            guard let currencySymbolsModel = currencySymbolsModel else{
                return []
            }
            return self?.generateCountryListSections(currencySymbolsDic: currencySymbolsModel.symbols)
        }
            .filter{$0 != nil}
            .map{$0!}
        
        
        return Output(currencySymbolSections: currencySymbolsSections)
    }
    
    
    
    private func generateCountryListSections(currencySymbolsDic : [String : String])->[CurrencySymbolsSectionModel]{
        var currencySymbolsSectionDic : [String : [CurrencySymbolModel]] = [:]
        
        ///Create Section Dictionary
        /// e.g key : "A", value : [CurrencySymbolModel]
        for pair in currencySymbolsDic{
            let startingAlphabet = "\(pair.key[pair.key.startIndex])".uppercased()
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
