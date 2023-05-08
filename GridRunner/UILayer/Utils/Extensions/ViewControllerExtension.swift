//
//  ViewControllerExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 08.05.23.
//

import UIKit

extension UIViewController {
    
    func moveWithKeyboard(on notification: NSNotification, by value: CGFloat, this constraint: NSLayoutConstraint, up: Bool) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int) else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        if up {
            let safeArea = self.view.window?.safeAreaInsets.bottom != 0
            constraint.constant = keyboardHeight + (safeArea ? 0 : value)
        } else {
            constraint.constant = value
        }
        
        let animation = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            self?.view?.layoutIfNeeded()
        }
        
        animation.startAnimation()
    }
}
