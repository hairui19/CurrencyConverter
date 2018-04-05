//
//  UIBarButtonItem+Extension.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(withTitle title : String, font : UIFont){
        self.init(title: title, style: .plain, target: nil, action: nil)
        let attributes = [NSAttributedStringKey.font : font ,
                          NSAttributedStringKey.foregroundColor : UIColor.black]
        let diableAttributeds = [NSAttributedStringKey.font : font ,
                                 NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        setTitleTextAttributes(attributes, for: .normal)
        setTitleTextAttributes(attributes, for: .selected)
        setTitleTextAttributes(diableAttributeds, for: .disabled)
    }
    
    
}
