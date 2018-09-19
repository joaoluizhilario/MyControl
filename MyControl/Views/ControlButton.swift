//
//  ControlButton.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 06/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class ControlButton: UIButton {
    
    var keyType: ButtonKeyType!

    init(icon: ButtonKeyType!, bgColor: UIColor? = UIColor.clear, title: String? = nil, target: Any? = nil, action: Selector? = nil, imagePadding: Int? = nil) {
        super.init(frame: .zero)
        self.keyType = icon
        backgroundColor = bgColor
        imageView?.contentMode = .scaleAspectFit
        
        setTitleColor(AppColors.buttonTintColor, for: .normal)
        
        if (icon != .none) {
            if (icon.isNumber || icon == .dot) {
                setTitle(icon.stringValue, for: .normal)
            } else {
                if (icon == .power) {
                    setImage(UIImage(named: self.keyType.stringValue), for: .normal)
                } else {
                    setImage(UIImage(named: self.keyType.stringValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
                    tintColor = AppColors.buttonTintColor
                }
                
                if (icon == .ok) {
                    addConstraintsWithFormat(format: "V:[v0(40)]", views: imageView!)
                }
                
                if (icon == .theme) {
                    addConstraintsWithFormat(format: "V:[v0(20)]", views: imageView!)
                }
                
                if let padding = imagePadding {
                    addConstraintsWithFormat(format: String(format: "V:|-%i-[v0]-%i-|", padding, padding), views: imageView!)
                }
            }
        }
        
        if (title != nil) {
            setTitle(title, for: .normal)
        }
        
        if (target != nil && action != nil) {
            addTarget(target, action: action!, for: .touchUpInside)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
