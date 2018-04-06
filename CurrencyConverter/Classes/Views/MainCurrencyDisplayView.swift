//
//  MainCurrencyDisplayView.swift
//  CurrencyConverter
//
//  Created by Hairui on 5/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit
import RxSwift

class MainCurrencyDisplayView : UIView{
    
    
    // MARK: - UIs (Elements)
    var countryButton : UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = Fonts.get(.asap_bold, fontSize: 35)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var amountButton : UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = Fonts.get(.asap_bold, fontSize: 30)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var cover : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 250, green: 250, blue: 252)
        return view
    }()
    
    private var coverLabel : UILabel = {
        let label = UILabel()
        label.font = Fonts.get(.asap_bold, fontSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Tap To \nAdd Base Currency"
        return label
    }()
    
    private var divider : UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 240, green: 240, blue: 245)
        return divider
    }()
    
    
    // MARK: - Observing Model
    var baseCurrency : DisplayBaseCurrencyRealmModel?{
        didSet{
            guard let baseCurrency = baseCurrency else{
                return
            }
            print("the country name is = \(baseCurrency.countryName)")
            countryButton.setTitle(baseCurrency.countryName, for: .normal)
            amountButton.setTitle(baseCurrency.displayAmount, for: .normal)
        }
    }
    
    // MARK: - Ect
    var bag = DisposeBag()
    
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
        addSubview(countryButton)
        addSubview(amountButton)
        addSubview(cover)
        cover.addSubview(coverLabel)
        addSubview(divider)
    }
    
    private func setContraints(){
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        countryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        countryButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        
        
        /// ValueLabel Constraints
        amountButton.translatesAutoresizingMaskIntoConstraints = false
        amountButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        amountButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        amountButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30).isActive = true
        
        /// Divider Constraints
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        /// cover constraints
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cover.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cover.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cover.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // coverlabel constraints
        coverLabel.translatesAutoresizingMaskIntoConstraints = false
        coverLabel.leadingAnchor.constraint(equalTo: cover.leadingAnchor, constant: 15).isActive = true
        coverLabel.trailingAnchor.constraint(equalTo: cover.trailingAnchor, constant: -15).isActive = true
        coverLabel.centerYAnchor.constraint(equalTo: cover.centerYAnchor).isActive = true
    }
}
