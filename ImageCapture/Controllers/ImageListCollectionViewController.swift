//
//  ImageListCollectionViewController.swift
//  ImageCapture
//
//  Created by Challa Karthik on 24/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

private let imageListCellId = "imageListCellId"

class ImageListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var list: [ImageCaptureModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = orangeBackgroundColor
        navigationController?.navigationBar.isTranslucent = false
        // for bar
        navigationController?.navigationBar.barTintColor = orangeBackgroundColor
        // for bar text
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "List of images"

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: imageListCellId)

        let addImageButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(redirectToImageVC(_:)))
        navigationItem.rightBarButtonItem = addImageButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        list = (db?.selectAll())!
        print("Successfully queried table. \(list.count) rows retured.")
        self.collectionView.reloadData()
    }
    
    @objc func redirectToImageVC(_ sender: UIBarButtonItem) {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionFootersPinToVisibleBounds = true
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(homeViewController, animated: true)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageListCellId, for: indexPath)
        let imageModel = list[indexPath.row]
        let imageView = UIImageView(image: imageModel.image)
        imageView.contentMode = .scaleAspectFit
        cell.backgroundView = imageView
        cell.backgroundView?.layer.cornerRadius = cell.frame.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }        

}
