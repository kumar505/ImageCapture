//
//  OthersCell.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

class OthersCollectionViewCell: BaseCollectionViewCell {
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    let view: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingStackView = UIStackView()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 15
        textView.layer.borderColor = baseCellbackgroundColor.cgColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        commentTextView.delegate = self
        
        setupRatingButtons()
        addSubview(view)
        view.addSubview(ratingLabel)
        view.addSubview(ratingStackView)
        view.addSubview(commentLabel)
        view.addSubview(commentTextView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ratingLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ratingStackView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": commentLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": commentTextView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-[v1]-5-[v2]-5-[v3]-5-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ratingLabel, "v1": ratingStackView, "v2": commentLabel, "v3": commentTextView]))
    }
    
    func setupRatingButtons() {
        for _ in 0..<9 {
            let button = UIButton()
            button.setImage(UIImage(named: "star-gray"), for: .normal)
            button.setImage(UIImage(named: "star-yellow"), for: .selected)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(RatingButtonTapped(tappedButton:)), for: .touchUpInside)
            ratingStackView.addArrangedSubview(button)
        }
        ratingStackView.axis = .horizontal
        ratingStackView.distribution = .fillEqually
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func RatingButtonTapped(tappedButton: UIButton) {
        let buttons = ratingStackView.arrangedSubviews as! [UIButton]
        guard let index = buttons.index(of: tappedButton) else {
            fatalError("The button \(tappedButton) is not in the rating buttons array: \(buttons)")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        imageCaptureModel.rating = rating
    }
    
    func updateButtonSelectionStates() {
        let buttons = ratingStackView.arrangedSubviews as! [UIButton]
        for (index, button) in buttons.enumerated() {
            button.isSelected = index < rating
        }
    }
}

extension OthersCollectionViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text else {
            return
        }
        print(text)
        imageCaptureModel.comment = text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
