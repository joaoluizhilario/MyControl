//
//  TVBrand.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 12/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

class SmartTV {
    let ipAddress: String!
    let brand: TVBrand!
    let macAddress: String?
    
    init(ipAddress: String!, brand: TVBrand!, macAddress: String) {
        self.ipAddress = ipAddress
        self.brand = brand
        self.macAddress = macAddress
    }
}

enum TVBrand: String, CodingKey {
    case philips = "philips"
    case samsung = "samsung"
    
    static func keys() -> [TVBrand] {
        return [.philips, .samsung]
    }
}
