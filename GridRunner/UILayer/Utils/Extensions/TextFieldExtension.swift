//
//  TextFieldExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 15.07.23.
//

import UIKit

extension UITextField {
    func setup(with placeholder: String? = nil) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor(named: "Gray")?.withAlphaComponent(0.25).cgColor
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "Enter...",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "Gray")?.withAlphaComponent(0.5) ?? UIColor.systemGray5
            ]
        )
    }
}
