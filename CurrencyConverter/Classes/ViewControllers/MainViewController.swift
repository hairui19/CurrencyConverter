//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RealmSwift

class MainViewController : UIViewController{

    // MARK: - IBOulets and UIs
    private var plusBarButtonItem : UIBarButtonItem!
    @IBOutlet weak var dummyButton: UIButton!
    
    // MARK: - Navigations
    var presentCurrencyList : (()->Void)!
    var presentAmountEntry : (()->Void)!
    
    // MARK: - ViewModel
    private var viewModel : MainViewModel!
    let loadAPI = Variable<Bool>(true)
    
    // MARK: - Ect
    private let bag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModelBinding()
        UIBinding()
       print("the apth to realm\(Realm.Configuration.defaultConfiguration.description)")
    }
}

// MARK: - UIs
extension MainViewController{
    private func setupUI(){
        setupNavigationBarUI()
    }
    
    private func setupNavigationBarUI(){
        plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = plusBarButtonItem
        
        (plusBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.presentCurrencyList()
            })
        .disposed(by: bag)
    }
}

// MARK: - UI Binding
extension MainViewController{
    private func UIBinding(){
        (dummyButton.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.presentAmountEntry()
            })
        .disposed(by: bag)
    }
}


// MARK: - ViewModel Binding
extension MainViewController{
    private func viewModelBinding(){
        viewModel = MainViewModel()
        let input = MainViewModel.Input(loadAPI: loadAPI.asDriver())
        let output = viewModel.transform(input: input)
        output.isLoading.debug("let' see the loading").drive().disposed(by: bag)
    }
}
