//
//  WireFrame.swift
//  CurrencyConverter
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

struct WireFrame {
    static func showLoadingView(){
        if let keyWindow = UIApplication.shared.keyWindow{
            if let loadingView = keyWindow.viewWithTag(981231234){
                loadingView.isHidden = false
                loadingView.alpha = 1
                return
            }
            
            let loadingView = LoadingView()
            loadingView.tag = 981231234
            keyWindow.addSubview(loadingView)
            loadingView.fillSuperview()
        }
    }
    
    static func hideLoadingView(){
        
        if let keyWindow = UIApplication.shared.keyWindow{
            if let loadingView = keyWindow.viewWithTag(981231234){
                UIView.animate(withDuration: 0.2, animations: {
                    loadingView.alpha = 0
                }, completion: { (success) in
                    loadingView.isHidden = true
                })
            }
        }
    }
}
