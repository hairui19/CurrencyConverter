//
//  CurrencyListCoordinator.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

class CurrencyListCoordinator : Coordinator{
    
    var childCoordinators: [Coordinator] = []
    
    var viewController: UIViewController
    
    var router: Router
    
    required init(router: Router, viewController: UIViewController) {
        self.router = router
        self.viewController = viewController
    }
    
    
    func start() {
        
        guard let viewController = viewController as? CurrencyListViewController else{
            fatalError("Wrong ViewController Embedded")
        }
        
        viewController.closeDismiss = {
            [weak self] in
            self?.router.finishedVerticalFlow!()
        }
        
    }
}
