//
//  Alert.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 12/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

extension Alert {
    
    static func showNoOneTVFound(on vc: UIViewController) {
        showSimpleAlert(on: vc, title: "Atenção", message: "Nenhuma TV foi encontrada em sua rede \u{1F615}", closeButtonTitle: "Entendi")
    }
}

class Alert {
    
    private init() { }
    
    private static func showSimpleAlert(on vc: UIViewController!, title: String!, message: String!, closeButtonTitle: String? = "Ok", completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: closeButtonTitle, style: .default, handler: completion)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
