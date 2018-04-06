//
//  HRNumberWithSuperscriptLabel.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

class HRNumberWithSuperscriptLabel : UILabel{
    
    /// This class is specifically for entry only
    /// This means that we discard the usual way of setting text = String
    /// But we takes a single letter at one time
    /// Similar behaviour like TextField
    
    // MARK: - Public APIS
    
    /// If the user has just started typing, we change the text
    /// Else, we append the next digit to the existing text
    /// We set it to be Int, to ensure all the appending characters are Int
    
    public func addNextDigit(with digit : Int){
        if isAtBeginningOfTyping{
            if digit != 0{
                accumulator = ("\(digit)")
                isAtBeginningOfTyping = false
            }
        }else{
            appendNewEntryWith(text: "\(digit)")
        }
    }
    
    /// Delete the last character
    public func delete(){
        if accumulator.count <= 1{
            accumulator = "0"
            return
        }
        
        let newEndIndex = accumulator.index(before: accumulator.endIndex)
        accumulator = "\(accumulator[accumulator.startIndex..<newEndIndex])"
    }
    
    public func clear(){
        accumulator = "0"
    }
    
    
    /// Change to superScriptMode
    public func changeToSuperscriptMode(){
        guard !accumulator.contains(".") else{
            return
        }
        isAtBeginningOfTyping = false
        accumulator.append(".")
    }

    var result : Double{
        guard let lastChar = accumulator.last else{
            /// Accumulator at all times should have at least
            /// one character
            fatalError("No last character error")
        }
        
        // Case where user enters "." but did not proceed with any other entry
        if lastChar == "."{
            delete()
        }
        
        guard let result = Double(accumulator) else{
            print("The Wrong Entry is = \(accumulator)")
            fatalError("Can't Convert to Double")
        }
        return result
    }
    
    
    // MARK: - Private Properties
    /// Self defined attributes, can be made to be public to be configured
    private let normalAttrites = [
        NSAttributedStringKey.foregroundColor : UIColor.black,
        NSAttributedStringKey.font : Fonts.get(.asap_regular, fontSize: 40)
    ]
    
    private let superscriptAttributes : [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.foregroundColor : UIColor.black,
        NSAttributedStringKey.font : Fonts.get(.asap_regular, fontSize: 35),
        NSAttributedStringKey.baselineOffset : 10
    ]
    
    private let superscriptPlaceholderAttributes : [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : Fonts.get(.asap_regular, fontSize: 35),
        NSAttributedStringKey.baselineOffset : 10,
        NSAttributedStringKey.foregroundColor : UIColor.lightGray
    ]
    
    private let minimumFont = Fonts.get(.asap_regular, fontSize: 35)
    
    /// This is the property that accumulates the digits
    /// The starting value of the accumulator is set to "0"
    @objc dynamic var accumulator : String = "0"{
        didSet{
            setAttributedText(text: accumulator)
            if accumulator == "0"{
                isAtBeginningOfTyping = true
            }
        }
    }
    
    /// Currency Formatter
     private var currencyFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    /// A property to check if the user has already started typing
    private var isAtBeginningOfTyping : Bool = true
    
    /// Define the number of placeholders in superscript
    private let numberOfPlaceholderLettersInSuperScript = 2
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Private Helper
    private func setAttributedText(text : String){
        if text.contains("."){
            /// get the numeber of placeholder letters we should place
            let substringArray = accumulator.components(separatedBy: ".")
            let numberOfTrailingZeroes = max(numberOfPlaceholderLettersInSuperScript - substringArray[substringArray.count-1].count, 0)
            
            var trailingString : String = ""
            for _ in 0..<numberOfTrailingZeroes{
                trailingString+="0"
            }
            
            /// Here, we force unwrapp, substringArray[0] has to be able to convert to Int
            let formattedStringFirtPartOfString = getCurrencyFormattedString(text: substringArray[0])
            let firstPartOfString = NSMutableAttributedString(string: formattedStringFirtPartOfString, attributes: normalAttrites)
            let secondPartOfString = NSAttributedString(string: substringArray[1], attributes: superscriptAttributes)
            let placeHolderPartOfString = NSAttributedString(string: trailingString, attributes: superscriptPlaceholderAttributes)
            _ = firstPartOfString.append(secondPartOfString)
            _ = firstPartOfString.append(placeHolderPartOfString)
            attributedText = firstPartOfString
        }else{
            let formattedStringFirtPartOfString = getCurrencyFormattedString(text: text)
            attributedText = NSAttributedString(string: formattedStringFirtPartOfString, attributes: normalAttrites)
        }
    }
    
    private func appendNewEntryWith(text : String){
        let labelWidth = bounds.size.width
        let newEntry = accumulator + text
        let newEntryWidth = (newEntry as NSString).size(withAttributes: [
            NSAttributedStringKey.font : minimumFont
            ]).width
        if labelWidth > newEntryWidth{
            accumulator.append(text)
        }
    }
    
    /// get the formattedString
    private func getCurrencyFormattedString(text : String)->String{
        guard let intValue = Int(text) else{
            fatalError("Letters other than digits entered the label")
        }
        guard let formattedString = currencyFormatter.string(from: NSNumber(value: intValue)) else{
            fatalError("Error with currency formatter")
        }
        return formattedString
    }
    
}

// MARK: - Customisation
extension HRNumberWithSuperscriptLabel{
    
}

