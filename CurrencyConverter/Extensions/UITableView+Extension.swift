//
//  UITableView+Extension.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

extension UITableView{
    
    // cells registration
    func registerCellWith(cellName : String){
        self.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
    }
}
