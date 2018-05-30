//
//  NSObjectExtensions.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 18..
//  Copyright © 2018년 CHK. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
