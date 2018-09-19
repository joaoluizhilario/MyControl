//
//  ApiPaths.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 06/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

struct ApiPaths: Decodable {
    
    var brand: String!
    var port: Int!
    var server: String!
    var methods: [Method]?
    var inputKeys: [InputKey]?
    
    private init() { }
    
    static func factory(_ brand: TVBrand!) -> ApiPaths! {
        if let path = Bundle.main.path(forResource: String(format: "ApiRestPaths-%@", brand.stringValue), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonPrinted = try? JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                return try JSONDecoder().decode(ApiPaths.self, from: jsonPrinted!)
            } catch {
                print("Error on decode ApiRestPaths JSON: \(error)")
                return nil
            }
        }
        return nil
    }
    
    var systemPath: String? {
        get {
            if (methods != nil) {
                return methods?.filter({ $0.name == "system" }).first?.path
            } else {
                return nil
            }
        }
    }
    
    var inputKeyPath: String? {
        if (methods != nil) {
            return methods?.filter({ $0.name == "input_key" }).first?.path
        } else {
            return nil
        }
    }
    
    func inputKeyForButtonType(_ buttonType: ButtonKeyType!) -> String! {
        return inputKeys!.filter({ $0.buttonKey == buttonType.buttonKey }).first!.inputKey
    }
    
    private enum CodingKeys: String, CodingKey {
        case inputKeys = "input_keys"
        case brand, port, server, methods
    }
}

struct Method: Decodable {
    var name: String?
    var supportedVerbs: [String]?
    var path: String?
    var subMethods: [Method]?
    
    private enum CodingKeys: String, CodingKey {
        case supportedVerbs = "supported_verbs"
        case subMethods = "sub_methods"
        case name, path
    }
}

struct InputKey: Decodable {
    var buttonKey: String?
    var inputKey: String?
    
    private enum CodingKeys: String, CodingKey {
        case buttonKey = "button_key"
        case inputKey = "input_key"
    }
}
