//
//  Box.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 11/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
