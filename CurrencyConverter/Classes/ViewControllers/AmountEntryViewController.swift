//
//  AmountEntryViewController.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AmountEntryViewController : UIViewController{
    
    // MARK: - Properties
    
    // MARK: - ViewModels
    
    // MARK: - UIs and IBoulets
    @IBOutlet weak var displayLabel: HRNumberWithSuperscriptLabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 235)
    }
    
    // MARK: - IBActions
    @IBAction func touchDigit(_ sender: UIButton) {
        let digitTouched = sender.currentTitle!
        let theInt = Int(digitTouched)!
        displayLabel.addNextDigit(with: theInt)
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        let operand = sender.currentTitle!
        switch operand {
        case "C":
            displayLabel.clear()
        case "⬅︎":
            displayLabel.delete()
        case ".":
            displayLabel.changeToSuperscriptMode()
        case "1,000",
             "500",
             "100",
             "10",
             "1"
             :
            print("operand is = \(operand)")
        default:
            fatalError("Someone unknown operand pressed")
        }
    }
}

