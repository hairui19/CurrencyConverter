//
//  UIScrollView+Rx.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base : UIScrollView{
    var keyboardNotification : Binder<Notification>{
        return Binder(base){ scrollView, notification in
            
            guard let userInfo = notification.userInfo,
                let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size  else{
                    return
            }
            
            if notification.name == Notification.Name.UIKeyboardDidShow{
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
            }else if notification.name == Notification.Name.UIKeyboardWillHide{
                let contentInset = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
            }
        }
    }
}
