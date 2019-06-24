//
//  ButtonCell.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

class FooterCollectionViewCell: BaseCollectionViewCell {
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 147/255, green: 161/255, blue: 176/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(button)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": button]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": button]))
    }    
}
