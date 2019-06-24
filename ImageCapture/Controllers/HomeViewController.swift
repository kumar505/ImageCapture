//
//  HomeViewController.swift
//  ImageCapture
//
//  Created by Challa Karthik on 21/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit
import Toast_Swift

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categoryCellId = "categoryCellId"
    let subCategoryCellId = "subCategoryCellId"
    let imageCellId = "imageCellId"
    let otherCellId = "otherCellId"
    let footerCellId = "footerCellId"
    
    var imagePicker: UIImagePickerController!
    var categories: [BaseItemModel] = {
        var listOfItems = [BaseItemModel]()
        for eachItem in Array(items.keys.sorted()) {
            listOfItems.append(BaseItemModel(name: eachItem, imageName: eachItem.lowercased()))
        }
        return listOfItems
    }()
    var subCategories: [BaseItemModel] = [] {
        didSet {
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    var selectedIndex: Int?
    var selectedCell: ItemsCollectionViewCell = ItemsCollectionViewCell() {
        didSet {
            guard let indexPath = collectionView.indexPath(for: selectedCell) else {
                return
            }
            selectedIndex = indexPath.item
        }
    }
    var selectedItem: String = "" {
        didSet {
            if selectedIndex == 0 {
                if let subCategoryItems = items[selectedItem]?.sorted() {
                    var items: [BaseItemModel] = []
                    for eachItem in subCategoryItems {
                        let baseModelItem = BaseItemModel(name: eachItem, imageName: eachItem.lowercased())
                        items.append(baseModelItem)
                    }
                    subCategories = items
                    imageCaptureModel.category = selectedItem
                }
            } else {
                imageCaptureModel.subCategory = selectedItem
            }
        }
    }
    
    let cameraBoxView: UIView = {
        let supportView = UIView()
        supportView.backgroundColor = UIColor.clear
        supportView.layer.borderColor = orangeBackgroundColor.cgColor
        supportView.layer.borderWidth = 1
        return supportView
    }()
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self                
        
        collectionView.bounces = false
        collectionView.backgroundColor = orangeBackgroundColor
        collectionView.register(ItemsCollectionViewCell.self, forCellWithReuseIdentifier: categoryCellId)
        collectionView.register(ItemsCollectionViewCell.self, forCellWithReuseIdentifier: subCategoryCellId)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView.register(OthersCollectionViewCell.self, forCellWithReuseIdentifier: otherCellId)
        collectionView.register(FooterCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerCellId)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = view.frame.width
//        let viewHeight = view.frame.height
//        let itemHeight = viewHeight / 5
//        let otherHeight = (viewHeight - itemHeight * 2) / 2
        
        if indexPath.item == 0 || indexPath.item == 1 {
            return CGSize(width: viewWidth, height: 110)
        }
        
        return CGSize(width: viewWidth, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! ItemsCollectionViewCell
            cell.backgroundColor = .clear
            cell.titleLabel.text = "Category"
            cell.homeViewController = self
            cell.list = categories
            return cell
            
        } else if indexPath.item == 1 {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCategoryCellId, for: indexPath) as! ItemsCollectionViewCell
            cell.backgroundColor = .clear
            cell.titleLabel.text = "Subcategory"
            cell.homeViewController = self
            cell.list = subCategories
            return cell
            
        } else if indexPath.item == 2 {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCollectionViewCell
            setupImageViewWithOptions(cell.imageView)
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherCellId, for: indexPath) as! OthersCollectionViewCell
            return cell
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellId, for: indexPath) as! FooterCollectionViewCell
        cell.button.addTarget(self, action: #selector(self.performUpload(_:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: Action

    @objc func performUpload(_ sender: UIButton) {
        
        guard imageCaptureModel.category != nil else {
            self.view.makeToast(NSLocalizedString("NO_CATEGORY", comment: "NO_CATEGORY"), duration: 2.0, position: .bottom)
            return
        }
        
        guard imageCaptureModel.subCategory != nil else {
            self.view.makeToast(NSLocalizedString("NO_SUBCATEGORY", comment: "NO_SUBCATEGORY"), duration: 2.0, position: .bottom)
            return
        }
        
        guard imageCaptureModel.image != nil else {
            self.view.makeToast(NSLocalizedString("NO_IMAGE_SELECTED", comment: "NO_IMAGE_SELECTED"), duration: 2.0, position: .bottom)
            return
        }
        
        guard imageCaptureModel.rating != nil else {
            self.view.makeToast(NSLocalizedString("NO_RATING", comment: "NO_RATING"), duration: 2.0, position: .bottom)
            return
        }
        
        // comment is optional for now, so defaulted to ""
        guard imageCaptureModel.comment != nil else {
            self.view.makeToast(NSLocalizedString("NO_COMMENT", comment: "NO_COMMENT"), duration: 2.0, position: .bottom)
            return
        }
        
        // Insert Data to DB
        
        do {
            try db?.insertImageData(imageData: imageCaptureModel)
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print((db?.errorMessage)!)
        }
    }
    
}
