//
//  ActivityIndicatorExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 06.06.23.
//

import UIKit

extension UIActivityIndicatorView {
    func setup() {
        self.isHidden = true
        self.color = .white
        self.hidesWhenStopped = true
    }
    
    func start() {
        self.isHidden = false
        self.startAnimating()
    }
}
