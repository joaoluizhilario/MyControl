//
//  TVSystem.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 06/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

struct TVSystem: Decodable {
    let menulanguage: String?
    let name: String?
    let country: String?
    let serialnumber: String?
    let softwareversion: String?
    let model: String?
}

struct Channel: Decodable {
    let id: String?
    let preset: String?
    let name: String?
    let source: String?
}
