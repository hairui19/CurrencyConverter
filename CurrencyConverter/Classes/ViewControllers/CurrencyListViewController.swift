//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxGesture

class CurrencyListViewController : UIViewController{
    
    // MARK: - IBOulets
    @IBOutlet weak var tableView: UITableView!
    private var closeBarButtonItem : UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - ViewModel
    private var viewModel : CurrencyListViewModel!
    private let sections = Variable<[CurrencySymbolsSectionModel]>([])
    private let addDisplayRates = Variable<CurrencySymbolModel?>(nil)
    
    // MARK: - Navigations
    var closeDismiss : (()->Void)!
    
    // MARK: - Ect
    private let bag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        UIBinding()
        viewModelBinding()
        setupTableView()
        addGestures()
        addNotifications()
    }
    
}

// MARK: - UI
extension CurrencyListViewController{
    private func setupUI(){
        setupNavBarUI()
    }
    
    private func setupNavBarUI(){
        closeBarButtonItem = UIBarButtonItem(image: Images.general_close_icon.image, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
    }
}

// MARK: - UIBinding
extension CurrencyListViewController{
    private func UIBinding(){
        (closeBarButtonItem.rx.tap)
            .subscribe(onNext: { [weak self] (_) in
                self?.closeDismiss()
            })
            .disposed(by: bag)
    }
}

// MARK: - Setup TableView
extension CurrencyListViewController{
    
    private func setupTableView(){
    
        // register cells
        tableView.registerCellWith(cellName: CurrencyListTableViewCell.reuseIdentifier())
        
        /// Simple Customisation
        tableView.separatorStyle = .none
        
        // Set TableView Delegate
        tableView.delegate = self
        
        /// Data Binding
        sections.asObservable()
        .observeOn(MainScheduler.instance)
        .bind(to: tableView.rx.items(dataSource: dataSource()))
        .disposed(by: bag)
    
    }
    
    
    private func dataSource()-> RxTableViewSectionedReloadDataSource<CurrencySymbolsSectionModel>{
        return RxTableViewSectionedReloadDataSource<CurrencySymbolsSectionModel>(
            configureCell: { datasource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.reuseIdentifier(), for: indexPath) as! CurrencyListTableViewCell
                cell.currencySymbolModel = item
                return cell
        },
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        },
            sectionIndexTitles: { ds in
                return ds.sectionModels.map({ (sectionModel) -> String in
                    return sectionModel.header
                })
        }
        )
    }
}

// MARK: - TableView Delegate
extension CurrencyListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = sections.value[indexPath.section].items[indexPath.row]
        addDisplayRates.value = selectedItem
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


// MARK: - ViewModel Binding
extension CurrencyListViewController{
    private func viewModelBinding(){
        let searchText = searchBar.rx.text.orEmpty.asDriver().map{$0.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)}
        .distinctUntilChanged()
        viewModel = CurrencyListViewModel()
        let input = CurrencyListViewModel.Input(searchText: searchText, addDisplayRates: addDisplayRates.asDriver().filter{$0 != nil}.map{$0!})
        let output = viewModel.transform(input: input)
        output.currencySymbolSections.drive(sections).disposed(by: bag)
        output.completedStoryingInRealm.drive(onNext: { [weak self] (_) in
            self?.closeDismiss()
        })
        .disposed(by: bag)
    }
}


// MARK: - Add Gestures
extension CurrencyListViewController{
    private func addGestures(){
        addTapAnyWhereToDismissGesture()
    }
    
    private func addTapAnyWhereToDismissGesture(){
        view.rx
            .tapGesture{
                tapGesure, delegate in
                tapGesure.cancelsTouchesInView = false
            }
            .when(.recognized)
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] (tapGestureEvent) in
                if let _ = tapGestureEvent.element{
                    self?.view.endEditing(true)
                }
            })
            .disposed(by: bag)
    }
    
    @objc private func touchToDismissKeyBoard(){
        view.endEditing(true)
    }
}


// MARK: - ScrollView Delegate
extension CurrencyListViewController{
    // When user scrolls the scrollView, we dismiss the keyboard
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - Notifications
extension CurrencyListViewController{
    private func addNotifications(){
        addKeyBoardNotfications()
    }
    
    private func addKeyBoardNotfications(){
        /// this notifications will help to re-draw the index bar at the right
        /// It will not have much effect on tableView inset since when user starts scrolls
        /// the keyboard will already be dismissed "scrollViewWillBeginDragging"
        
        NotificationCenter.default.rx
            .notification(Notification.Name.UIKeyboardDidShow)
            .observeOn(MainScheduler.instance)
            .takeUntil(rx.methodInvoked(#selector(viewWillDisappear(_:))))
            .bind(to: tableView.rx.keyboardNotification)
            .disposed(by: bag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name.UIKeyboardWillHide)
            .takeUntil(rx.methodInvoked(#selector(viewWillDisappear(_:))))
            .bind(to: tableView.rx.keyboardNotification)
            .disposed(by: bag)
    }
}



