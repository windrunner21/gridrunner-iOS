//
//  Dimensions.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.09.23.
//

import UIKit

struct Dimensions {
    // Font sizes
    static let largeFont = UIScreen.main.bounds.width * 0.1
    static let nameFont = UIScreen.main.bounds.width * 0.075
    static let titleFont = UIScreen.main.bounds.width * 0.06
    static let subtitleFont = UIScreen.main.bounds.width * 0.04
    static let headingFont = UIScreen.main.bounds.width * 0.05
    static let buttonFont = UIScreen.main.bounds.width * 0.035
    static let subHeadingFont = UIScreen.main.bounds.width * 0.03
    static let captionFont = UIScreen.main.bounds.width * 0.0275
    
    // Other
    static let verticalSpacing20 = UIScreen.main.bounds.height / 46.6
    static let buttonWidth =  UIScreen.main.bounds.width / 5
    static let roundViewHeight =  UIScreen.main.bounds.width / 10
    static let menuItemViewHeight = UIScreen.main.bounds.width >= 390 ? UIScreen.main.bounds.height / 4 : UIScreen.main.bounds.height / 3.5
    static let roomParameterView = UIScreen.main.bounds.height / 12
}
