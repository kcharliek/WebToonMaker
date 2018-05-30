//
//  PopoverListTableViewCell.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 4..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import SnapKit

class ListPopoverTableViewCell: UITableViewCell {
    // MARK: - Variable
    var listTitleLabel: UILabel!
    var title: String? {
        didSet {
            listTitleLabel.text = title
        }
    }
    
    // MARK: - Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        listTitleLabel = UILabel()
        self.contentView.addSubview(listTitleLabel)
        listTitleLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(10)
        }
        listTitleLabel.font = UIFont(name: "NanumGothicOTF", size: 14.0)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
