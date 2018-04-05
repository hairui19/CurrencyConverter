//
//  MainCurrencyDisplayView.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

class MainCurrencyDisplayView : UIView{
    
    
    // MARK: - UIs (Elements)
    private var countryLabel : UILabel = {
        let label = UILabel()
        label.font = Fonts.get(.asap_regular, fontSize: 15)
        return label
    }()
    
    private var valueLabel : UILabel = {
        let label = UILabel()
        label.font = Fonts.get(.asap_regular, fontSize: 15)
        return label
    }()
    
    private var divider : UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 240, green: 240, blue: 245)
        return divider
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        customisation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customisation()
    }

}

// MARK: - UI
extension MainCurrencyDisplayView{
    private func customisation(){
        // add subViews first
        addSubViews()
        setContraints()
    }
    
    private func addSubViews(){
        addSubview(countryLabel)
        addSubview(valueLabel)
        addSubview(divider)
    }
    
    private func setContraints(){
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        countryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        countryLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -15).isActive = true
        
        /// ValueLabel Constraints
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -15).isActive = true
        
        /// Divider Constraints
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
