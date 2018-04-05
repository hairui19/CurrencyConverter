//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxCocoa
import RealmSwift

class MainViewModel : ViewModelType{
    
    
    struct Input {
        let loadAPI : Driver<Bool>
        let displayRates : Driver<[DisplayCurrencyRealmModel]>
    }
    
    struct Output {
        let isLoading : Driver<Bool>
        let displayRatesSection : Driver<[DisplayCurrenciesAnimatedSectionModel]>
    }
    
    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        
        
        /// APIs
        let latestRatesAPIResult = input.loadAPI
            .flatMapLatest { (_) -> Driver<APIResult> in
                let service = APIServiceFactory.createGetLatestRatesService()
                return service.execute().asDriver(onErrorJustReturn: APIResult.apiError(APIError.executeError))
                .startWith(.isLoading)
        }
        
        let currencyRates = latestRatesAPIResult.map { (apiResult) -> CurrencyRatesModel? in
            switch apiResult{
            case .apiData(let data):
                return data as? CurrencyRatesModel
            default:
                return nil
            }
        }
            .filter{$0 != nil}
            .map{$0!}
        
        
        let finishStoringRatesInRealm = currencyRates.map { (currencyModel) -> Bool in
            let rates = currencyModel.rates
            let realm = try! Realm()
            try! realm.write {
                for pair in rates{
                    let currencyName = pair.key
                    let rate = pair.value
                    if let latestRatesModel = realm.object(ofType: LatestRatesRealmModel.self, forPrimaryKey: currencyName){
                        latestRatesModel.currencyRate = rate
                    }else{
                        let latestRatesModel = LatestRatesRealmModel(currencyName: pair.key, currencyRate: pair.value)
                        realm.add(latestRatesModel)
                    }
                }
            }
            return false
        }
        
        let startLoadingAPI = latestRatesAPIResult.map { (apiResult) -> Bool in
            switch apiResult{
            case .isLoading:
                return true
            default:
                return false
            }
        }
            .filter{$0}
        
        let isLoading = Driver.from([
            startLoadingAPI,
            finishStoringRatesInRealm
            ])
        .merge()
        
        
        /// Realm
        let displayRatesSection = input.displayRates.map { (displayRatesModels) -> [DisplayCurrenciesAnimatedSectionModel] in
            return [DisplayCurrenciesAnimatedSectionModel(header: "section", items: displayRatesModels)]
        }
        
        return Output(isLoading: isLoading,
                      displayRatesSection: displayRatesSection)
    }
    
}
