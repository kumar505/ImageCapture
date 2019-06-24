//
//  BaseCollectionViewCell.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = baseCellbackgroundColor
    }
}
