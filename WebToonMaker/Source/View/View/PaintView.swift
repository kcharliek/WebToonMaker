//
//  PaintView.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 6..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class PaintView: UIView, Canvas {
    
    // MARK: - Canvase Protocol Implementation
    var context: CGContext {
        return UIGraphicsGetCurrentContext()!
    }
    var contentView: UIView {
        return self
    }
    
    // MARK: - Variable
    private var buffer: UIImage?
    
    // MARK: - Method
    public func reset() {
        buffer = nil
        layer.contents = nil
    }
    
    public func execute(commands: [Command]?) {
        guard let commands = commands else { return }
        buffer = drawView(with: commands)
        layer.contents = buffer?.cgImage ?? nil
    }
    
    private func drawView(with commands: [Command]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        
        context.setFillColor(Color.white.cgColor)
        context.fill(bounds)
        
        if let buffer = buffer {
            buffer.draw(in: bounds)
        }
        
        for cmd in commands { cmd.execute(in: self) }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
