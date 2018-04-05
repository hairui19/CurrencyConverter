//
//  Colors.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(red :CGFloat, green : CGFloat, blue : CGFloat){
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
}
