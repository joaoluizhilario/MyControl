//
//  RemoteControlViewController.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 06/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class RemoteControlViewController: UIViewController {
 
    lazy var viewOptionsNav: NavigatioButtonsView = NavigatioButtonsView(target: self, action: #selector(buttonKeySelected))
    lazy var stackViewNumbers: NumberPadView = NumberPadView(target: self, action: #selector(buttonKeySelected))
    
    lazy var stackViewTopFirst: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            ControlButton(icon: .channelDown, bgColor: AppColors.buttonBackgroundColor, target: self, action: #selector(buttonKeySelected), imagePadding: 8),
            ControlButton(icon: .power, target: self, action: #selector(buttonKeySelected), imagePadding: 3),
            ControlButton(icon: .channelUp, bgColor: AppColors.buttonBackgroundColor, target: self, action: #selector(buttonKeySelected), imagePadding: 8)
            ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    lazy var stackViewTopSecond: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            ControlButton(icon: .volumeDown, bgColor: AppColors.buttonBackgroundColor, target: self, action: #selector(buttonKeySelected), imagePadding: 8),
            ControlButton(icon: .mute, bgColor: AppColors.buttonBackgroundColor, target: self, action: #selector(buttonKeySelected), imagePadding: 8),
            ControlButton(icon: .volumeUp, bgColor: AppColors.buttonBackgroundColor, target: self, action: #selector(buttonKeySelected), imagePadding: 8)
            ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [stackViewTopFirst, stackViewTopSecond].forEach { (stackView) in
            stackView.arrangedSubviews.forEach({ (button) in
                button.layer.cornerRadius = 5
            })
        }
    }
    
    func setupViews() {
        view.backgroundColor = AppColors.backgroundColor
        view.addSubview(stackViewTopFirst)
        view.addSubview(stackViewTopSecond)
        view.addSubview(viewOptionsNav)
        view.addSubview(stackViewNumbers)
        
        let relativeHeight = UIScreen.main.bounds.width * 0.5
        view.addConstraintsWithFormat(format: String(format: "V:|-20-[v0(45)]-20-[v1(45)]", relativeHeight), views: stackViewTopFirst, stackViewTopSecond)
        view.addConstraintsWithFormat(format: String(format: "H:|-10-[v0]-10-|", relativeHeight), views: stackViewTopFirst)
        view.addConstraintsWithFormat(format: String(format: "H:|-10-[v0]-10-|", relativeHeight), views: stackViewTopSecond)
        view.addConstraintsWithFormat(format: String(format: "V:[v0]-20-[v1(%.0f)]-10-|", relativeHeight), views: viewOptionsNav, stackViewNumbers)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: stackViewNumbers)
        
        viewOptionsNav.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        viewOptionsNav.heightAnchor.constraint(equalTo: viewOptionsNav.widthAnchor, multiplier: 0.9).isActive = true
        viewOptionsNav.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func buttonKeySelected(_ sender: ControlButton) {
        ApiTV.shared.toggleInputKey(buttonKey: sender.keyType)
        print("Clicou \(sender.keyType)")
    }
}
