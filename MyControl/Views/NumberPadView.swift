//
//  NumberPadStackView.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 07/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class NumberPadView: UIView {
    
    var stackView: UIStackView!
    
    init(target: Any!, action: Selector!) {
        super.init(frame: .zero)
        
        let stackViewFirst: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                ControlButton(icon: .one, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .two, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .three, bgColor: AppColors.buttonBackgroundColor, target: target, action: action)
            ])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            stack.spacing = 10
            return stack
        }()
        let stackViewSecond: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                ControlButton(icon: .four, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .five, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .six, bgColor: AppColors.buttonBackgroundColor, target: target, action: action)
            ])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            stack.spacing = 10
            return stack
        }()
        let stackViewThird: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                ControlButton(icon: .seven, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .eight, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .nine, bgColor: AppColors.buttonBackgroundColor, target: target, action: action)
            ])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            stack.spacing = 10
            return stack
        }()
        let stackViewFourth: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                ControlButton(icon: .none, bgColor: AppColors.buttonBackgroundColor, title: ".", target: target, action: action),
                ControlButton(icon: .zero, bgColor: AppColors.buttonBackgroundColor, target: target, action: action),
                ControlButton(icon: .none, bgColor: AppColors.buttonBackgroundColor, title: "", target: target, action: action)
            ])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            stack.spacing = 10
            return stack
        }()
        
        stackView = UIStackView(arrangedSubviews: [stackViewFirst,stackViewSecond,stackViewThird,stackViewFourth])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        setupViews()
    }
    
    override func layoutSubviews() {
        stackView.arrangedSubviews.forEach { (stackView) in
            if let stack = stackView as? UIStackView {
                stack.arrangedSubviews.forEach({ (button) in
                    button.layer.cornerRadius = 5
                })
            }
        }
    }
    
    func setupViews() {
        addSubview(stackView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: stackView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: stackView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
