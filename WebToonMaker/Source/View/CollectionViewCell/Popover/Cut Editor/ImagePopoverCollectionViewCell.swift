//
//  ImagePopoverCollectionViewCell.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class ImagePopoverCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    // MARK: - Variable
    override var isSelected: Bool {
        didSet {
            checkmarkImageView.isHidden = !isSelected
        }
    }
    
    // MARK: - Method
    public func set(image: UIImage) {
        imageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
