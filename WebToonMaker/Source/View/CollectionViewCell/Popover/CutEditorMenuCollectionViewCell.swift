//
//  EditorMenuCollectionViewCell.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 3..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class CutEditorMenuCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Variable
    var type: Menu!
    override var isSelected: Bool {
        didSet {
            guard type == .pen || type == .eraser  else {
                layer.borderWidth = 0
                return
            }
            
            if isSelected {
                layer.borderColor = Color.white.cgColor
                layer.borderWidth = 1
            } else {
                layer.borderWidth = 0
            }
        }
    }
    
    // MARK: - Method
    func setIcon(image: UIImage) {
        iconImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = TMColor.primaryColor
    }
}
