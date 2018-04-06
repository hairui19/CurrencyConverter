//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxGesture
import RxRealm
import RxDataSources

class MainViewController : UIViewController{
    
    // MARK: - Properties
    var baseCurrency : DisplayBaseCurrencyRealmModel!
    
    // MARK: - IBOulets and UIs
    private var plusBarButtonItem : UIBarButtonItem!
    private var editBarButtonItem : UIBarButtonItem!
    private var refreshBarButtonItem : UIBarButtonItem!
    @IBOutlet weak var mainCurrencyDisplayView: MainCurrencyDisplayView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Navigations
    var presentCurrencyList : (()->Void)!
    var presentCurrencyListForBaseCurrency : ((DisplayBaseCurrencyRealmModel)->Void)!
    var presentAmountEntry : (()->Void)!
    
    // MARK: - ViewModel
    private var viewModel : MainViewModel!
    let loadAPI = Variable<Bool>(true)
    
    // MARK: - Display Data
    var displayRates : List<DisplayCurrencyRealmModel>!
    var displayRatesSection = Variable<[DisplayCurrenciesAnimatedSectionModel]>([])
    
    // MARK: - Ect
    private let bag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModelBinding()
        UIBinding()
        setupTableView()
    }
}

// MARK: - UIs
extension MainViewController{
    private func setupUI(){
        title = "HR CC-"
        setupNavigationBarUI()
    }
    
    private func setupNavigationBarUI(){
        refreshBarButtonItem = UIBarButtonItem(image: Images.general_refresh_icon.image, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = refreshBarButtonItem
        plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        editBarButtonItem = UIBarButtonItem(withTitle: "Edit", font: Fonts.get(.asap_medium, fontSize: 15))
        navigationItem.rightBarButtonItems = [plusBarButtonItem, editBarButtonItem]
    }
}

// MARK: - UI Binding
extension MainViewController{
    private func UIBinding(){
        (refreshBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.loadAPI.value = true
            })
        .disposed(by: bag)
        
        (plusBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.presentCurrencyList()
            })
            .disposed(by: bag)
        
        (editBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                if let strongSelf = self{
                    strongSelf.tableView.isEditing = !strongSelf.tableView.isEditing
                    if strongSelf.tableView.isEditing{
                        strongSelf.editBarButtonItem.title = "Done"
                    }else{
                        strongSelf.editBarButtonItem.title = "Edit"
                    }
                }
            })
            .disposed(by: bag)
        
        (mainCurrencyDisplayView.countryButton.rx.tap)
            .subscribe(onNext: { [unowned self] () in
                self.presentCurrencyListForBaseCurrency(self.baseCurrency!)
            })
        .disposed(by: mainCurrencyDisplayView.bag)
        
        (mainCurrencyDisplayView.amountButton.rx.tap)
            .subscribe(onNext: { [unowned self] () in
                self.presentAmountEntry()
            })
            .disposed(by: mainCurrencyDisplayView.bag)
        
        mainCurrencyDisplayView.rx.tapGesture()
        .when(.recognized)
            .subscribe(onNext: { [unowned self] (_) in
                self.presentCurrencyListForBaseCurrency(self.baseCurrency!)
            })
        .disposed(by: bag)
        
    }
}


// MARK: - ViewModel Binding
extension MainViewController{
    private func viewModelBinding(){
        let realm = try! Realm()
        displayRates = DisplayCurrenciesContainerRealmModel.defaultContainer(in: realm).orderedDisplayRateList
        let displayRatesObservable = Observable.array(from: displayRates).asDriver(onErrorJustReturn: [])
        
        baseCurrency = DisplayBaseCurrencyRealmModel.defaultCurrency(in: realm)
        let baseCurrencyDriver = Observable.from(object: baseCurrency).asDriver(onErrorJustReturn: DisplayBaseCurrencyRealmModel())
        
        viewModel = MainViewModel()
        let input = MainViewModel.Input(loadAPI: loadAPI.asDriver().debug(),
                                        displayRates: displayRatesObservable,
                                        baseCurrency: baseCurrencyDriver)
        let output = viewModel.transform(input: input)
        output.isLoading.drive(onNext: { (isLoading) in
            if isLoading{
                WireFrame.showLoadingView()
            }else{
                WireFrame.hideLoadingView()
            }
        })
        .disposed(by: bag)
        
        output.displayRatesSection.drive(displayRatesSection).disposed(by: bag)
        output.shouldDisplayBaseCurrency.drive(onNext: { [weak self] (_) in
            self?.mainCurrencyDisplayView.cover.isHidden = true
        })
        .disposed(by: bag)
        output.baseCurrency.drive(onNext: { [weak self] (baseCurrency) in
            self?.mainCurrencyDisplayView.baseCurrency = baseCurrency
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        .disposed(by: bag)
        
        output.hasError.drive(onNext: { [weak self] (_) in
            self?.showAlert(title: "Network Error", message: "You may not have the latest rates.", actions: ["Ok"])
        })
        .disposed(by: bag)
    }
}


// MARK: - Setup TableView
extension MainViewController{
    private func setupTableView(){
        /// register cells
        tableView.registerCellWith(cellName: CurrencyDisplayTableViewCell.reuseIdentifier())
        
        /// some customisation
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        /// set delegate
        tableView.delegate = self
        
        displayRatesSection.asObservable()
        .observeOn(MainScheduler.instance)
        .bind(to: tableView.rx.items(dataSource: dataSource()))
        .disposed(by: bag)
        
        /// delete item
        tableView.rx.itemDeleted.subscribe(onNext: { [unowned self](indexPath) in
            let realm = try! Realm()
            try! realm.write {
                self.displayRates.remove(at: indexPath.row)
            }
        })
        .disposed(by: bag)
        
        /// Move Items
        tableView.rx.itemMoved.subscribe(onNext: { (sourceIndexPath, destinationIndexPath) in
            let realm = try! Realm()
            try! realm.write {
                self.displayRates.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
            }
        })
        .disposed(by: bag)
        
    }
    
    private func dataSource()->RxTableViewSectionedAnimatedDataSource<DisplayCurrenciesAnimatedSectionModel>{
        return RxTableViewSectionedAnimatedDataSource<DisplayCurrenciesAnimatedSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                           reloadAnimation: .fade),
            configureCell: {dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyDisplayTableViewCell.reuseIdentifier(), for: indexPath) as! CurrencyDisplayTableViewCell
                cell.ratesModel = item
                return cell
            },
            canEditRowAtIndexPath: {  _, _ in
                return true
        },
            canMoveRowAtIndexPath: { tesst, tesst1 in
                return true
        }
        )
    }
}

// MARK: - TableView Delegate
extension MainViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}



