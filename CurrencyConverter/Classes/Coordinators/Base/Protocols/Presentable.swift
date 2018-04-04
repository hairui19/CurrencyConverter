//
//  Presentable.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

protocol Presentable{
    func toPresent() -> UIViewController?
}

extension UIViewController : Presentable{
    func toPresent() -> UIViewController?{
        return self
    }
}
