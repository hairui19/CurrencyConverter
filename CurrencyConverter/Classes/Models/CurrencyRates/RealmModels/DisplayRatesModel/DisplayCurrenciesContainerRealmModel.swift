//
//  DisplayRatesContainerRealmModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RealmSwift

class DisplayCurrenciesContainerRealmModel : Object{
    
    @objc dynamic var key = "DisplayRatesContainerRealmModel.key"
    let orderedDisplayRateList = List<DisplayCurrencyRealmModel>()
    
    // MARK: -
    override static func primaryKey() -> String? {
        return "key"
    }

    
    // MARK: - Etc
    /// This is to fetch the default container
    /// If the default container is not available when we try to retrieve it
    /// It will be created on the spot
    private static func createDefaultContainer(in realm: Realm) -> DisplayCurrenciesContainerRealmModel{
        let container = DisplayCurrenciesContainerRealmModel()
        try! realm.write {
            realm.add(container)
        }
        return container
    }
    
    @discardableResult
    static func defaultContainer(in realm: Realm) -> DisplayCurrenciesContainerRealmModel {
        return realm.object(ofType: DisplayCurrenciesContainerRealmModel.self, forPrimaryKey: "DisplayRatesContainerRealmModel.key")
            ?? createDefaultContainer(in: realm)
    }
}
