//
//  CellReuseIdentifiable.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

public protocol CellReuseIdentifiable: AnyObject {
    static func reuseIdentifier() -> String
}

