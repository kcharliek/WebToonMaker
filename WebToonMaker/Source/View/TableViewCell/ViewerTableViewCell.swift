//
//  ViewerTableViewCell.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 9..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class ViewerTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var sceneImageView: UIImageView!
    
    // MARK: - Variable
    var model: WebToonScene?
    
    // MARK: - Method
    func set(model: WebToonScene) {
        self.model = model
        sceneImageView.image = model.image ?? #imageLiteral(resourceName: "etc_noImage")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
