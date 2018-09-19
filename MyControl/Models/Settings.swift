//
//  Settings.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 07/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

class Settings {
    var tv: SmartTV? {
        didSet {
            if (tv != nil) {
                let tvDic = [
                    "ipAddress" : tv!.ipAddress,
                    "macAddress" : tv!.macAddress,
                    "brand" : tv!.brand.stringValue
                ]
                
                UserDefaults.standard.set(tvDic, forKey: "tv")
            }
        }
    }
    var theme: KeyboardTheme = .dark {
        didSet {
            UserDefaults.standard.set(theme.stringValue, forKey: "theme")
        }
    }
    
    static let shared = Settings()
    
    private init() {
        if let tvDic = UserDefaults.standard.value(forKey: "tv") as? [String: String] {
            let ip: String? = String(data: (tvDic["ipAddress"]?.data(using: String.Encoding.utf8))!, encoding: String.Encoding.utf8)
            self.tv = SmartTV(ipAddress: ip, brand: TVBrand(rawValue: tvDic["brand"]!), macAddress: tvDic["macAddress"]!)
        } else {
            self.tv = nil
        }
        
        if let theme = UserDefaults.standard.string(forKey: "theme") {
            self.theme = KeyboardTheme(rawValue: theme)!
        } else {
            self.theme = .bright
        }
    }
}

enum KeyboardTheme: String, CodingKey {
    case bright = "bright"
    case dark = "dark"
}
