//
//  EditorConfig.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 8..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class EditorConfiguration: NSObject, NSCoding {
    var penWidth: CGFloat = 5.0
    var eraserWidth: CGFloat = 7.0
    var currentColor: UIColor = .black
    var commandInvoker = CommandInvoker()
    
    var canUndo: Bool = false
    var canRedo: Bool = false
    
    override init() {
        super.init()
    }
    
    // MARK: - NSCoding Implementation
    func encode(with aCoder: NSCoder) {
        aCoder.encode(penWidth, forKey: "penWidth")
        aCoder.encode(eraserWidth, forKey: "eraserWidth")
        aCoder.encode(currentColor, forKey: "currentColor")
        aCoder.encode(commandInvoker, forKey: "commandInvoker")
    }
    
    required init(coder aDecoder: NSCoder) {
        penWidth = aDecoder.decodeObject(forKey: "penWidth") as! CGFloat
        eraserWidth = aDecoder.decodeObject(forKey: "eraserWidth") as! CGFloat
        currentColor = aDecoder.decodeObject(forKey: "currentColor") as! UIColor
        commandInvoker = aDecoder.decodeObject(forKey: "commandInvoker") as! CommandInvoker
    }
    
}
