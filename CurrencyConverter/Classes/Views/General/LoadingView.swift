//
//  LoadingView.swift
//  CurrencyConverter
//
//  Created by Hairui on 6/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView{
    
    private var indicatorView : UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    private var backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240, green: 240, blue: 245)
        view.alpha = 0.5
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customsation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoadingView {
    private func customsation(){
        // setting the background to clear color
        backgroundColor = .clear
        addSubViews()
        setupContraints()
        
    }
    
    private func addSubViews(){
        addSubview(backgroundView)
        addSubview(indicatorView)
    }
    
    private func setupContraints(){
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        backgroundView.fillSuperview()
    }
}
