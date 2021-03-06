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
    
    // MARK: - UIs and IBoulets
    @IBOutlet weak var displayLabel: HRNumberWithSuperscriptLabel!
    private var closeBarButtonItem : UIBarButtonItem!
    private var convertBarButtonItem : UIBarButtonItem!
    
    // MARK: - Navigations
    var closeDismiss : (()->Void)!
    
    // MARK: - ViewModel
    private var viewModel : AmountEntryViewModel!
    private let operation = Variable<String?>(nil)
    
    // MARK: - Ect
    private let bag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModelBinding()
        UIBinding()
    }
    
    // MARK: - IBActions
    @IBAction func touchDigit(_ sender: UIButton) {
        let digitTouched = sender.currentTitle!
        let theInt = Int(digitTouched)!
        displayLabel.addNextDigit(with: theInt)
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        operation.value = sender.currentTitle
    }
}

// MARK: - UIs
extension AmountEntryViewController{
    private func setupUI(){
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 235)
        title = "Enter Your Amount"
        setupNavBar()
    }
    
    private func setupNavBar(){
        /// Add a left closeBarButton
        closeBarButtonItem = UIBarButtonItem(image: Images.general_close_icon.image, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
        
        /// Add a right ConvertBarButton
        convertBarButtonItem = UIBarButtonItem(withTitle: "Convert", font: Fonts.get(.asap_medium, fontSize: 15))
        navigationItem.rightBarButtonItem = convertBarButtonItem
    }
}

// MARK: - UI Binding
extension AmountEntryViewController{
    private func UIBinding(){
        (closeBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.closeDismiss()
            })
            .disposed(by: bag)
    }
}


// MARK: - ViewModel Binding
extension AmountEntryViewController{
    private func viewModelBinding(){
        viewModel = AmountEntryViewModel()
        let accumulator = displayLabel.rx.observe(String.self, "accumulator")
            .filter{$0 != nil}
            .map{$0!}
            .asDriver(onErrorJustReturn: "")
            .filter{$0.count > 0}

        let input = AmountEntryViewModel.Input(
            accumulator: accumulator,
            convertButton: convertBarButtonItem.rx.tap.asDriver(),
            operand: operation.asDriver().filter{$0 != nil}.map{$0!})
        let output = viewModel.transform(input: input)

        output.enableConvertButton.drive(convertBarButtonItem.rx.isEnabled).disposed(by: bag)
        output.convert.drive(onNext: { [weak self] (success) in
            self?.closeDismiss()
        })
        .disposed(by: bag)
        output.isFastOperation.drive(onNext: { [weak self] (_) in
            self?.closeDismiss()
        })
        .disposed(by: bag)
        output.uiOperation.drive(onNext: { [weak self] (operation) in
            switch operation{
            case .clear:
                self?.displayLabel.clear()
            case .delete:
                self?.displayLabel.delete()
            case .decimal:
                self?.displayLabel.changeToSuperscriptMode()
            default:
                break
            }
        })
        .disposed(by: bag)
    }
}

