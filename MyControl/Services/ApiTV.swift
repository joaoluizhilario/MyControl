//
//  ApiTV.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 06/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation
import SystemConfiguration

extension ApiTV {
    
    func sendInputKey(buttonKey: ButtonKeyType!) {
        guard let serverUrl = TV_SERVER_URL else { print("Sem servidor")
            return }
        let url = String(format:"%@%@", serverUrl, paths.inputKeyPath!)
        let params: [String: Any] = ["key": paths.inputKeyForButtonType(buttonKey)]
        fetchGenericData(url: url, method: .post, parameters: params) { (jsonResponse, error) in }
    }
    
    func tvSystemInfo(completion: @escaping(TVSystem?, String?) -> ()) {
        guard let serverUrl = TV_SERVER_URL else { print("Sem servidor")
            return }
        let url = String(format:"%@%@", serverUrl, paths.systemPath!)
        fetchGenericData(url: url, method: .get, parameters: nil) { (jsonResponse, error) in
            if (error != nil) {
                completion(nil, error)
            } else {
                if let dic = jsonResponse as? [String: Any] {
                    self.decodeDictionary(dictionary: dic, completion: { (system: TVSystem?) in
                        completion(system, nil)
                    })
                }
            }
        }
    }
}

class ApiTV {
    fileprivate var TV_SERVER_URL: String!
    fileprivate var TV_SERVER_PORT: Int!
    fileprivate let paths: ApiPaths!
    
    private init(paths: ApiPaths) {
        self.paths = paths
        TV_SERVER_PORT = paths.port
    }
    
    public static func factory(brand: TVBrand!) -> ApiTV! {
        return ApiTV(paths: ApiPaths.factory(brand))
    }
    
    var isFound: Bool! {
        get {
            return TV_SERVER_URL != nil
        }
    }
    
    func setServerAddress(address: String!) {
        self.TV_SERVER_URL = String(format:"http://%@:%i%@", address, self.paths.port, self.paths.server)
    }
    
    func tryFetchServerForAddress(address: String!, completion: @escaping((Bool) -> ())) {
        if (!isFound) {
            let url = String(format:"http://%@:%i%@%@", address, paths.port, paths.server, paths.systemPath!)
            let nsurl: URL! = URL(string: url)!
            var request : URLRequest! = URLRequest(url: nsurl as URL)
            request.httpMethod = "GET"
            request.timeoutInterval = 1.0
            
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
            var dataTask: URLSessionDataTask?
            dataTask = defaultSession.dataTask(with: request! as URLRequest) { (_, response, error) -> Void in
                if let urlResponse = response as? HTTPURLResponse {
                    completion((urlResponse.statusCode != 404))
                } else {
                    completion(false)
                }
            }
            
            dataTask?.resume()
        }
    }
    
    public func isConected() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    fileprivate func fetchGenericData(url: String!, method: RequestMethod!, parameters: [String: Any]?, completion: @escaping(Any?, String?) -> ()) {
        
        if (!isConected())
        {
            completion(nil, "Sem conexão")
        }
        else
        {
            let nsurl: URL! = URL(string: url)!
            
            var request : URLRequest! = URLRequest(url: nsurl as URL)
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [String: Any](), options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method.stringValue
            request.timeoutInterval = 3.0
            
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
            var dataTask: URLSessionDataTask?
            dataTask = defaultSession.dataTask(with: request! as URLRequest) { (data, response, error) -> Void in
                
                if let urlResponse = response as? HTTPURLResponse
                {
                    if urlResponse.statusCode == 200
                    {
                        guard let data = data else { return }
                        do {
                            let obj = try JSONSerialization.jsonObject(with: data, options: [])
                            completion(obj, nil)
                        } catch {
                            completion(nil, "Erro ao decodificar JSON")
                        }
                    }
                    else
                    {
                        completion(nil, "Falha ao conectar com o serviço remoto")
                    }
                }
                else if (error != nil) {
                    completion(nil, "Falha ao conectar com o serviço remoto")
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func decodeArray<T: Decodable>(array: Array<Dictionary<String, Any>>!, completion: @escaping([T]?) -> ()) {
        let jsonPrinted = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        do {
            guard let data = jsonPrinted else {
                completion(nil)
                return
            }
            let obj = try JSONDecoder().decode([T].self, from: data)
            completion(obj)
        } catch {
            completion(nil)
        }
    }
    
    func decodeDictionary<T: Decodable>(dictionary: Dictionary<String, Any>!, completion: @escaping(T?) -> ()) {
        let jsonPrinted = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        do {
            guard let data = jsonPrinted else {
                completion(nil)
                return
            }
            let obj = try JSONDecoder().decode(T.self, from: data)
            completion(obj)
        } catch {
            completion(nil)
        }
    }
    
    enum RequestMethod: String, CodingKey {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}
