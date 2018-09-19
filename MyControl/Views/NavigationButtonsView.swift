//
//  NavigationButtonsStackview.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 07/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class NavigatioButtonsView: UIView {
    
    let upButton: ControlButton!
    let downButton: ControlButton!
    let leftButton: ControlButton!
    let rightButton: ControlButton!
    let okButton: ControlButton!
    
    let searchButton: ControlButton!
    let optionsButton: ControlButton!
    let undoButton: ControlButton!
    let exitButton: ControlButton!
    
    let viewNavigation: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewOptionsNav: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(target: Any!, action: Selector!) {
        upButton = ControlButton(icon: .up, target: target, action: action)
        downButton = ControlButton(icon: .down, target: target, action: action)
        leftButton = ControlButton(icon: .left, target: target, action: action)
        rightButton = ControlButton(icon: .right, target: target, action: action)
        okButton = ControlButton(icon: .ok, target: target, action: action)
        
        searchButton = ControlButton(icon: .search, target: target, action: action)
        optionsButton = ControlButton(icon: .options, target: target, action: action)
        undoButton = ControlButton(icon: .undo, target: target, action: action)
        exitButton = ControlButton(icon: .exit, target: target, action: action)
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        updateThemeColor()
    }
    
    override func layoutSubviews() {
        viewNavigation.layer.cornerRadius = viewNavigation.frame.height/2
        viewOptionsNav.layer.cornerRadius = 10
        okButton.layer.cornerRadius = okButton.frame.height/2
    }
    
    func setupViews() {
        addSubview(viewOptionsNav)
        viewOptionsNav.addSubview(viewNavigation)
        [searchButton, undoButton, optionsButton, exitButton].forEach { (button) in viewOptionsNav.addSubview(button) }
        
        [upButton, leftButton, downButton, rightButton, okButton].forEach { (button) in viewNavigation.addSubview(button) }
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: viewOptionsNav)
        addConstraintsWithFormat(format: "H:|[v0]|", views: viewOptionsNav)
        
        viewOptionsNav.addConstraintsWithFormat(format: "H:|-10-[v0(35)]", views: searchButton)
        viewOptionsNav.addConstraintsWithFormat(format: "H:|-10-[v0(35)]", views: undoButton)
        viewOptionsNav.addConstraintsWithFormat(format: "H:[v0(35)]-10-|", views: optionsButton)
        viewOptionsNav.addConstraintsWithFormat(format: "H:[v0(30)]-10-|", views: exitButton)
        viewOptionsNav.addConstraintsWithFormat(format: "V:|-10-[v0(35)]", views: searchButton)
        viewOptionsNav.addConstraintsWithFormat(format: "V:|-10-[v0(35)]", views: optionsButton)
        viewOptionsNav.addConstraintsWithFormat(format: "V:[v0(35)]-10-|", views: undoButton)
        viewOptionsNav.addConstraintsWithFormat(format: "V:[v0(30)]-10-|", views: exitButton)
        
        
        viewNavigation.heightAnchor.constraint(equalTo: viewOptionsNav.heightAnchor, multiplier: 0.9).isActive = true
        viewNavigation.widthAnchor.constraint(equalTo: viewNavigation.heightAnchor).isActive = true
        viewNavigation.centerXAnchor.constraint(equalTo: viewOptionsNav.centerXAnchor).isActive = true
        viewNavigation.centerYAnchor.constraint(equalTo: viewOptionsNav.centerYAnchor).isActive = true
        
        viewNavigation.addConstraintsWithFormat(format: "V:|[v0(70)]", views: upButton)
        viewNavigation.addConstraintsWithFormat(format: "H:|[v0(70)]", views: leftButton)
        viewNavigation.addConstraintsWithFormat(format: "V:[v0(70)]|", views: downButton)
        viewNavigation.addConstraintsWithFormat(format: "H:[v0(70)]|", views: rightButton)
        
        upButton.centerXAnchor.constraint(equalTo: viewNavigation.centerXAnchor).isActive = true
        downButton.centerXAnchor.constraint(equalTo: viewNavigation.centerXAnchor).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: viewNavigation.centerYAnchor).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: viewNavigation.centerYAnchor).isActive = true
        
        okButton.centerXAnchor.constraint(equalTo: viewNavigation.centerXAnchor).isActive = true
        okButton.widthAnchor.constraint(equalTo: viewNavigation.widthAnchor, multiplier: 0.5).isActive = true
        okButton.heightAnchor.constraint(equalTo: okButton.widthAnchor).isActive = true
        okButton.centerYAnchor.constraint(equalTo: viewNavigation.centerYAnchor).isActive = true
    }
    
    func updateThemeColor() {
        viewNavigation.backgroundColor = AppColors.navigationViewBackgroundColor
        viewOptionsNav.backgroundColor = AppColors.buttonBackgroundColor
        
        [okButton, searchButton, optionsButton, undoButton, exitButton, okButton].forEach { (button) in
            
            button!.backgroundColor = AppColors.buttonBackgroundColor
            button!.setTitleColor(AppColors.buttonTintColor, for: .normal)
            button!.tintColor = AppColors.buttonTintColor
        }
        
        [upButton, leftButton, downButton, rightButton].forEach { (button) in
            button!.tintColor = AppColors.buttonTintColor
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
