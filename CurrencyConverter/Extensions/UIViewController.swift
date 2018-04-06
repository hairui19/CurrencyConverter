//
//  UIViewController.swift
//  CurrencyConverter
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(title : String, message : String, actions : [String]){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions{
            let alertAction = UIAlertAction(title: action, style: .default, handler: nil)
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}
