//
//  UIViewExtensions.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 10..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib<T>(withName nibName: String) -> T? {
        let nib  = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }
}
