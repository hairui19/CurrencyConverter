//
//  Fonts.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

enum FontNames : String{
    // fontNames
    case asap_regular = "Asap-Regular"
    case asap_medium = "Asap-Medium"
    case asap_boldItalic = "Asap-BoldItalic"
    case asap_bold = "Asap-Bold"
    case asap_italic = "Asap-Italic"
    case asap_mediumItalic = "Asap-MediumItalic"
}


struct Fonts {
    static func get(_ fontName : FontNames, fontSize : CGFloat)->UIFont{
        guard let font = UIFont(name: fontName.rawValue, size: fontSize) else{
            fatalError("The Font Does not exist")
        }
        
       return font
    }
}
