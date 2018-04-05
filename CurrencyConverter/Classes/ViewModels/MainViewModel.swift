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
    }
    
    struct Output {
        let isLoading : Driver<Bool>
    }
    
    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        
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
            let oldRatesObjects = realm.objects(LatestRatesRealmModel.self)
            var newRatesObjects : [LatestRatesRealmModel] = []
            for pair in rates{
                let latestRatesModel = LatestRatesRealmModel(currencyName: pair.key, currencyRate: pair.value)
                newRatesObjects.append(latestRatesModel)
            }
            
            try! realm.write {
                realm.delete(oldRatesObjects)
                realm.add(newRatesObjects)
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
        
        return Output(isLoading: isLoading)
    }
    
}
