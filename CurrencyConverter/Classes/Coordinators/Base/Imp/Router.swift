//
//  Router.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import UIKit

final class Router : NSObject, RouterType, Presentable{
    
    var finishedVerticalFlow : (()->Void)?
    var finishedVerticalFlowWithData : ((Any?)->Void)?
    
    // MARK: - Properties
    private weak var navigationController : UINavigationController?
    private var completions : [UIViewController : ()-> Void]
    
    // Custom Modal Presentation Animator
    //let horizontal
    
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
        self.navigationController?.transitioningDelegate = self
        
    }
    
    
    // MARK: - Navigations
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module.toPresent(), !(controller is UINavigationController) else{
            return
        }
        
        if let completion = completion{
            self.completions[controller] = completion
        }
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func present(_ module: Presentable, animated: Bool) {
        guard let controller = module.toPresent() else{
            return
        }
        self.navigationController?.present(controller, animated: animated, completion: nil)
    }
    
    
    func present(_ module: Presentable, animated : Bool, hideNavBar : Bool){
        guard let controller = module.toPresent() as? UINavigationController else{
            return
        }
        controller.navigationBar.isHidden = hideNavBar
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func setRootModule(_ module: Presentable){
        guard let controller = module.toPresent() else {
            return
        }
        navigationController?.setViewControllers([controller], animated: false)
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    private func popModule(animated: Bool)  {
        if let controller = navigationController?.popViewController(animated: animated) {
            runCompletionHandler(viewController: controller)
        }
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    
    
    
    // MARK: - Helper Function
    private func runCompletionHandler(viewController : UIViewController){
        guard let completion = self.completions[viewController] else{
            return
        }
        completion()
        self.completions.removeValue(forKey: viewController)
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
    
    
    
    // getting rid of the backbutton
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.titleLabel.font = UIFont(name: SRFonts.asap_medium.fontName, size: SRFonts.fontSize15.fontSize)
    }
}


// UIViewControllerTransitioningDelegate
extension Router : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // only when presenting SRListingResultContainerViewController, we return the custom animation
        guard let navigationController = presented as? UINavigationController,
            navigationController.viewControllers[0] is SRSearchResultContainerViewController ||
                navigationController.viewControllers[0] is SRSearchNewProjectResultContainerViewController
            else{
                return nil
        }
        return SRHorizontalCoverAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let navigationController = dismissed as? UINavigationController,
            navigationController.viewControllers[0] is SRSearchResultContainerViewController ||
                navigationController.viewControllers[0] is SRSearchNewProjectResultContainerViewController else{
                    return nil
        }
        print("i am called in here?")
        let horizontalCoverAnimator = SRHorizontalCoverAnimator()
        horizontalCoverAnimator.presenting = false
        return horizontalCoverAnimator
    }
}
