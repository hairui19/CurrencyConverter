//
//  DisplayRatesContainerRealmModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RealmSwift

class DisplayRatesContainerRealmModel : Object{
    
    @objc dynamic var key = "DisplayRatesContainerRealmModel.key"
    let orderedDisplayRateList = List<DisplayRatesRealmModel>()
    
    // MARK: -
    override static func primaryKey() -> String? {
        return "key"
    }

    
    // MARK: - Etc
    /// This is to fetch the default container
    /// If the default container is not available when we try to retrieve it
    /// It will be created on the spot
    private static func createDefaultContainer(in realm: Realm) -> DisplayRatesContainerRealmModel{
        let container = DisplayRatesContainerRealmModel()
        try! realm.write {
            realm.add(container)
        }
        return container
    }
    
    @discardableResult
    static func defaultContainer(in realm: Realm) -> DisplayRatesContainerRealmModel {
        return realm.object(ofType: DisplayRatesContainerRealmModel.self, forPrimaryKey: "DisplayRatesContainerRealmModel.key")
            ?? createDefaultContainer(in: realm)
    }
}
