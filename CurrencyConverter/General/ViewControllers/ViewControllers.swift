//
//  ViewControllers.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllers : String{
    
    case main_storyboard_main = "MainViewController"
    case countriesList_storyboard_main = "CurrencyListViewController"
    case amountEntry_storyboard_main = "AmountEntryViewController"
    
    
    var get : UIViewController{
        switch self{
        case .main_storyboard_main,
             .countriesList_storyboard_main,
             .amountEntry_storyboard_main
            :
            return storyboard_main.instantiateViewController(withIdentifier: self.rawValue)
        }
    }
    
}



