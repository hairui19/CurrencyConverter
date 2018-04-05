//
//  CoordinatorFactory.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

struct CoordinatorFactory {
    private init() {}
    
    static func getAppCoordinator()->Coordinator{
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        /// You can replace the rooter coordinator here to any other coordinator
        let coordinator = createMainCoordinator(router: router)
        router.setRootModule(coordinator.viewController)
        coordinator.start()
        return coordinator
    }
    
    static func createMainCoordinator(router : Router)-> Coordinator{
        let mainViewController = ViewControllers.main_storyboard_main.get
        let coordinator = MainCoordinator(router: router, viewController: mainViewController)
        coordinator.start()
        return coordinator
    }
    
    
    static func createCurrencyListCoordinator(
        router : Router
        )->Coordinator{
        let currencyViewController = ViewControllers.countriesList_storyboard_main.get as! CurrencyListViewController
        let coordinator = CurrencyListCoordinator(router: router, viewController: currencyViewController)
        coordinator.start()
        return coordinator
    }
    
    static func createAmountEntryCoordinator(router : Router)->Coordinator{
        let amountEntryViewController = ViewControllers.amountEntry_storyboard_main.get
        let coordinator = AmountEntryCoordinator(router: router, viewController: amountEntryViewController)
        coordinator.start()
        return coordinator
    }
    
}
