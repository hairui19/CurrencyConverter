//
//  Router.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

final class Router : NSObject, Routerable, Presentable{
    
    var finishedVerticalFlow : (()->Void)?
    var finishedVerticalFlowWithData : ((Any?)->Void)?
    
    // MARK: - Properties
    private weak var navigationController : UINavigationController?
    private var completions : [UIViewController : ()-> Void]
    
    // MARK: Presentable Protocol
    func toPresent() -> UIViewController? {
        return self.navigationController
    }
    
    
    // MARK: - Init
    init(navigationController : UINavigationController?){
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController?.delegate = self
    }
    
    
    // MARK: - Navigations
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module.toPresent(), !(controller is UINavigationController) else{
            return
        }
        
        if let completion = completion{
            completions[controller] = completion
        }
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func present(_ module: Presentable, animated : Bool, hideNavBar : Bool){
        guard let controller = module.toPresent() as? UINavigationController else{
            return
        }
        controller.navigationBar.isHidden = hideNavBar
        navigationController?.present(controller, animated: animated, completion: nil)
    }
    
    
    func setRootModule(_ module: Presentable){
        guard let controller = module.toPresent() else {
            return
        }
        navigationController?.setViewControllers([controller], animated: false)
    }
    
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    
    
    // MARK: - Helper Function
    private func runCompletionHandler(viewController : UIViewController){
        guard let completion = self.completions[viewController] else{
            return
        }
        completion()
        completions.removeValue(forKey: viewController)
    }
    
}

// MARK: - Navigation Delegate
extension Router : UINavigationControllerDelegate {
    // perfrom relevant closures when a viewcontroller is pushed back
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let poppedViewController = self.navigationController?.transitionCoordinator?.viewController(forKey: .from), !(self.navigationController?.viewControllers.contains(poppedViewController))! else{
            return
        }
        runCompletionHandler(viewController: poppedViewController)
    }
}


