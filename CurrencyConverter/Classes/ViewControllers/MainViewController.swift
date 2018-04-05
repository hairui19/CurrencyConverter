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
import RxGesture
import RxRealm

class MainViewController : UIViewController{
    
    // MARK: - IBOulets and UIs
    private var plusBarButtonItem : UIBarButtonItem!
    @IBOutlet weak var mainCurrencyDisplayView: MainCurrencyDisplayView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Navigations
    var presentCurrencyList : (()->Void)!
    var presentAmountEntry : (()->Void)!
    
    // MARK: - ViewModel
    private var viewModel : MainViewModel!
    let loadAPI = Variable<Bool>(true)
    
    // MARK: - Display Data
    var displayRates: Results<DisplayRatesRealmModel>!
    
    // MARK: - Ect
    private let bag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModelBinding()
        UIBinding()
        setupTableView()
        
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
    }
}

// MARK: - UI Binding
extension MainViewController{
    private func UIBinding(){
        (plusBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.presentCurrencyList()
            })
            .disposed(by: bag)
        
        mainCurrencyDisplayView.rx.tapGesture()
            .when(.recognized)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self!.tableView.isEditing = !self!.tableView.isEditing
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


// MARK: - Setup TableView
extension MainViewController{
    private func setupTableView(){
        /// register cells
        tableView.registerCellWith(cellName: CurrencyDisplayTableViewCell.reuseIdentifier())
        
        /// some customisation
        tableView.separatorStyle = .none
        
        /// set delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        ///
        let realm = try! Realm()
        displayRates = realm.objects(DisplayRatesRealmModel.self).sorted(byKeyPath: "index", ascending: true)
//        //        displayRates =  DisplayRatesContainerRealmModel.defaultContainer(in: realm).orderedDisplayRateList
        
        Observable.collection(from: displayRates)
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            })
        .disposed(by: bag)

    }
}

// MARK: - TableView Delegate
extension MainViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayRate = displayRates[indexPath.row]
        print("the countryname = \(displayRate.countryName)")
    }
}

// MARK: - TableView Datasource
extension MainViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyDisplayTableViewCell.reuseIdentifier(), for: indexPath) as! CurrencyDisplayTableViewCell
        cell.ratesModel = displayRates[indexPath.row]
        return cell
    }
    
    
    /// Move tableView
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = displayRates[sourceIndexPath.row]
        let destinationItem = displayRates[destinationIndexPath.row]
        let realm = try! Realm()
        try! realm.write {
            sourceItem.index = destinationIndexPath.row
            destinationItem.index = sourceIndexPath.row
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Observable.from([displayRates[indexPath.row]])
                .subscribe(Realm.rx.delete())
                .disposed(by: bag)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
