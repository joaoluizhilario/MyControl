//
//  AppColors.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 07/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class AppColors {
    
    static var backgroundColor: UIColor {
        get {
            if (Settings.shared.theme == .dark) {
                return UIColor(white: 0.1, alpha: 1)
            } else {
                return .white
            }
        }
    }
    
    static var buttonBackgroundColor: UIColor {
        get {
            if (Settings.shared.theme == .dark) {
                return UIColor(white: 0.30, alpha: 1)
            } else {
                return UIColor(white: 0.70, alpha: 1)
            }
        }
    }
    
    static var navigationViewBackgroundColor: UIColor {
        get {
            if (Settings.shared.theme == .dark) {
                return UIColor(white: 0.40, alpha: 1)
            } else {
                return UIColor(white: 0.90, alpha: 1)
            }
        }
    }
    
    static var buttonTintCollor: UIColor {
        get {
            if (Settings.shared.theme == .dark) {
                return .white
            } else {
                return .black
            }
        }
    }
}
