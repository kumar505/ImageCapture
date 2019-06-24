//
//  ItemsCollectionViewCell.swift
//  ImageCapture
//
//  Created by Challa Karthik on 21/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

class ItemsCollectionViewCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let itemCellId = "itemCellId"
    var list: [BaseItemModel]? {
        didSet {
            itemCollectionView.reloadData()
        }
    }
    var homeViewController: HomeViewController?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.6
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    let tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "tick")
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(titleLabel)
        addSubview(dividerLineView)
        addSubview(itemCollectionView)
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": itemCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1(20)]-5-[v2(0.5)]-5-[v0]-5-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": itemCollectionView, "v1": titleLabel, "v2": dividerLineView]))
        
        itemCollectionView.register(ItemsViewCell.self, forCellWithReuseIdentifier: itemCellId)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemCount = list?.count else {
            return 0
        }        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: frame.height - 36, height: frame.height - 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! ItemsViewCell
        guard let baseItem = list?[indexPath.item] else {
            return cell
        }
        cell.nameLabel.text = baseItem.name
        if let image = UIImage(named: baseItem.imageName) {
            cell.imageView.image = image
        } else {
            cell.imageView.image = UIImage(named: "empty")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("item selected")
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemsViewCell else {
            return
        }
        guard let superViewCell = cell.superview?.superview as? ItemsCollectionViewCell else {
            return
        }
        
        blurEffectView.frame = cell.imageView.bounds
        tickImageView.frame = cell.imageView.bounds
        
        blurEffectView.layer.cornerRadius = cell.imageView.bounds.width / 2
        tickImageView.layer.cornerRadius = cell.imageView.bounds.width / 2
        
        cell.imageView.addSubview(blurEffectView)
        cell.imageView.addSubview(tickImageView)
        cell.imageView.bringSubviewToFront(tickImageView)
        
        guard let name = cell.nameLabel.text else {
            return
        }
        
        homeViewController?.selectedCell = superViewCell
        homeViewController?.selectedItem = name
    }
}

class ItemsViewCell: BaseCollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
//        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "empty")
//        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {

        addSubview(imageView)
        addSubview(nameLabel)
        
//        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1(20)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView, "v1": nameLabel]))
    }
    
}
