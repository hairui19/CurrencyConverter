//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

class MainCoordinator : SRCoordinator{
    var childCoordinators: [SRCoordinator] = []
    
    var viewController: UIViewController
    
    var router: Router
    
    required init(router: Router, viewController: UIViewController) {
        self.router = router
        self.viewController = viewController
    }
    

    func start() {
        router.setRootModule(viewController)
    }
}
