//
//  TransitionController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.05.23.
//

import Foundation
import UIKit

class TransitionViewController: UIViewController {
    
    private var currentViewController: UIViewController?
    
    func transition(to viewController: UIViewController, with options: UIView.AnimationOptions) {
        guard viewController.parent == nil else {
            print("Error: The view controller is already a child view controller.")
            return
        }

        self.addChild(viewController)
        
        guard let newView = viewController.view else {
            print("Error: The view controller has no view.")
            return
        }

        newView.frame = self.view.bounds
        
        if let currentViewController = self.currentViewController, let oldView = currentViewController.view {
            print("Mark: Current view controller exists.")
            UIView.transition(with: self.view, duration: 0.3, options: options, animations: {
                oldView.removeFromSuperview()
            }, completion: { _ in
                self.view.addSubview(newView)
                viewController.didMove(toParent: self)
            })
        } else {
            print("Mark: Current view controller did not exist.")
            view.addSubview(newView)
            viewController.didMove(toParent: self)
        }
        
        currentViewController = viewController
    }
}
