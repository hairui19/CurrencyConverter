//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

protocol Coordinator : class{
    var router : Router {get}
    var childCoordinators : [Coordinator] {get set}
    var viewController : UIViewController {get}
    func start()
    
    init(router : Router, viewController : UIViewController) 
    
}

extension Coordinator{
    func addChildCoordinator(_ childCoordinator : Coordinator){
        for element in childCoordinators {
            if element === childCoordinator { return }
        }
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator : Coordinator){
        if self.childCoordinators.count == 0 {return }
        for (index, element) in childCoordinators.enumerated(){
            if element === childCoordinator{
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
