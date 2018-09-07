//
//  Settings.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 07/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

class Settings {
    var theme: KeyboardTheme = .dark {
        didSet {
            UserDefaults.standard.set(theme.stringValue, forKey: "theme")
        }
    }
    
    static let shared = Settings()
    private init() {
//        let theme = UserDefaults.standard.string(forKey: "theme") ?? ""
        
//        if (theme == "") {
//            self.theme = .dark
//        } else {
            self.theme = .bright
//        }
    }
}

enum KeyboardTheme: String, CodingKey {
    case bright = "bright"
    case dark = "dark"
}
