//
//  DeviceTVCell.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 12/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class DeviceTVCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let deviceInfo: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0.945, alpha: 1)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        contentView.addSubview(imageView)
        contentView.addSubview(deviceInfo)
        contentView.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: imageView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: deviceInfo)
        contentView.addConstraintsWithFormat(format: "V:|[v0][v1(15)]|", views: imageView, deviceInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
