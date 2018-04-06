//
//  Images.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

enum Images : String {
    
    case general_close_icon = "general_close_icon"
    case general_refresh_icon = "general_refresh_icon"
    
    var image : UIImage{
        return UIImage(named: rawValue)!
    }
    
}
