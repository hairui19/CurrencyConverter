//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

class MainCoordinator : Coordinator{
    var childCoordinators: [Coordinator] = []
    
    var viewController: UIViewController
    
    var router: Router
    
    required init(router: Router, viewController: UIViewController) {
        self.router = router
        self.viewController = viewController
    }
    

    func start() {
        guard let viewController = viewController as? MainViewController else{
            fatalError("Wrong ViewController Embedded")
        }
    
        viewController.presentCurrencyList = {
            [weak self] in
            self?.presentCurrencyList()
        }
        
        viewController.presentAmountEntry = {
            [weak self] in
            self?.presentAmountEntry()
        }
        
    }
}

// MARK: - Navigations
extension MainCoordinator{
    private func presentCurrencyList(){
        let navigationController = UINavigationController()
        let newRouter = Router(navigationController: navigationController)
        let coordinator = CoordinatorFactory.createCurrencyListCoordinator(router: newRouter)
        self.addChildCoordinator(coordinator)
        newRouter.setRootModule(coordinator.viewController)
        newRouter.finishedVerticalFlow = {
            [weak self, weak coordinator] in
            self?.router.dismissModule(animated: true, completion: nil)
            self?.removeChildCoordinator(coordinator!)
        }
        self.router.present(newRouter, animated: true, hideNavBar: false)
    }
    
    private func presentAmountEntry(){
        let navigationController = UINavigationController()
        let newRouter = Router(navigationController: navigationController)
        let coordinator = CoordinatorFactory.createAmountEntryCoordinator(router: newRouter)
        self.addChildCoordinator(coordinator)
        newRouter.setRootModule(coordinator.viewController)
        newRouter.finishedVerticalFlow = {
            [weak self, weak coordinator] in
            self?.router.dismissModule(animated: true, completion: nil)
            self?.removeChildCoordinator(coordinator!)
        }
        self.router.present(newRouter, animated: true, hideNavBar: false)
    }
}
