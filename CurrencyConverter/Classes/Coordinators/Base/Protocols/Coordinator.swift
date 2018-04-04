//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

protocol SRCoordinator : class{
    var router : Router {get}
    var childCoordinators : [SRCoordinator] {get set}
    func start()
    
}

extension SRCoordinator{
    func addChildCoordinator(_ childCoordinator : SRCoordinator){
        for element in childCoordinators {
            if element === childCoordinator { return }
        }
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator : SRCoordinator){
        if self.childCoordinators.count == 0 {return }
        for (index, element) in childCoordinators.enumerated(){
            if element === childCoordinator{
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
