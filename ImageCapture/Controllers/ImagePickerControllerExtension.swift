//
//  ImagePickerControllerExtension.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    func setupImageViewWithOptions(_ sender: UIImageView) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.loadImageOptions(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        sender.addGestureRecognizer(tapGesture)
    }
    @objc func loadImageOptions(_ sender: UIImageView) {
        
        let alert = UIAlertController(title: NSLocalizedString("ADD_PHOTO", comment: "ADD_PHOTO"), message: nil, preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        
        // Alert Actions
        alert.addAction(UIAlertAction(title: NSLocalizedString("TAKE_PHOTO", comment: "TAKE_PHOTO"), style: .default, handler: {
            action in self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CHOOSE_LIBRARY", comment: "CHOOSE_LIBRARY"), style: .default, handler: {
            action in self.openLibrary()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: "CANCEL"), style: .cancel, handler: nil))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePicker?.allowsEditing = true
            imagePicker?.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            
            let frame = CGRect(x: 0, y: 100, width: imagePicker.view.frame.width, height: imagePicker.view.frame.height/2 + 50)
            cameraBoxView.frame = frame
            imagePicker.cameraOverlayView = cameraBoxView
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            self.view.makeToast(NSLocalizedString("NO_CAMERA", comment: "NO_CAMERA"), duration: 2.0, position: .bottom)
        }
    }
    
    func openLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            self.view.makeToast(NSLocalizedString("NO_LIBRARY", comment: "NO_LIBRARY"), duration: 2.0, position: .bottom)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            // Get imageView from collection view's cell
            let indexPath = IndexPath(item: 2, section: 0)
            let imageCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
            imageCell.imageView.image = selectedImage
            
//            let minScale = min(selectedImage.size.width/picker.view.frame.size.width, selectedImage.size.height/picker.view.frame.size.height).rounded()
//            let maxScale = max(selectedImage.size.width/picker.view.frame.size.width, selectedImage.size.height/picker.view.frame.size.height).rounded()
//
//            let cropZone = CGRect(x:cameraBoxView.frame.origin.x * maxScale,
//                                  y:cameraBoxView.frame.origin.y * maxScale,
//                                  width:cameraBoxView.frame.size.width * maxScale,
//                                  height:cameraBoxView.frame.size.height * maxScale)
//            guard let croppedImage = selectedImage.cgImage?.cropping(to: cropZone) else {
//                print("Unable to crop image")
//                return
//            }
//            let editedImage = UIImage(cgImage: croppedImage, scale: maxScale, orientation: selectedImage.imageOrientation)
//            imageCell.imageView.image = editedImage
            
            // Save image to global object and save it to DB
            imageCaptureModel.image = selectedImage
            
            let imageName = (UIDevice.current.identifierForVendor?.uuidString)!+"_\(getCurrentGMTDateTimeMillis(date: getCurrentGMTDateTime()))"+".jpg"
            let imageURL = pathToDocumentDirectory.appendingPathComponent(imageName)
            let data = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            data.write(toFile: imageURL.path, atomically: true)
            imageCaptureModel.imageName = imageName
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled image selection")
        dismiss(animated: true, completion: nil)
    }
}
