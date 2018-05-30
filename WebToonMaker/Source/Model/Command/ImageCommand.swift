//
//  ImageCommand.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 10..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class ImageCommand: NSObject, NSCoding, Command {
    // MARK: - Variable
    private var image: UIImage!
    private var position: CGRect!
    
    // MARK: - Command Protocol
    func execute(in canvas: Canvas) {
        image.draw(in: position)
    }
    
    // MARK: - Method
    private override init() {
        super.init()
    }
    
    public init(image: UIImage!, position: CGRect!) {
        super.init()
        
        self.image = image
        self.position = position
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(position, forKey: "position")
    }
    
    required init(coder aDecoder: NSCoder) {
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
        position = aDecoder.decodeObject(forKey: "position") as? CGRect
    }
}
