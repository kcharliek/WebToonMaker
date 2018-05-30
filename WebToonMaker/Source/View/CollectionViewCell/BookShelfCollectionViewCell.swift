//
//  BookShelfCollectionViewCell.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 3..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class BookShelfCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variable
    var model: WebToon?
    
    // MARK: - Method
    func set(model: WebToon) {
        coverImageView.image = model.scenes[0].image
        titleLabel.text = model.title
        self.model = model
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = Color.black.cgColor
        layer.borderWidth = 1
    }
}
