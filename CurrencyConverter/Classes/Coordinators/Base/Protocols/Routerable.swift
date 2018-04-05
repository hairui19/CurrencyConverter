//
//  RouterType.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation

import UIKit

protocol Routerable {
    
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func present(_ module: Presentable, animated : Bool, hideNavBar : Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func setRootModule(_ module: Presentable)

}
