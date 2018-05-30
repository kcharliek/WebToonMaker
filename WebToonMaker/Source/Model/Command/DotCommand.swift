//
//  DotCommand.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 6..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class DotCommand: NSObject, NSCoding, Command {
    // MARK: - Variable
    private var current: Dot!
    private var previous: Dot?
    private var width: CGFloat = 5
    private var color: UIColor = .black
    
    // MARK: - Constructor
    private override init() {
        super.init()
    }
    
    public init(current: Dot!, previous: Dot?) {
        super.init()
        
        self.current = current
        self.previous = previous
        self.width = current.width
        self.color = current.color
    }
    
    // MARK: - Command Protocol
    func execute(in canvas: Canvas) {
        configure(canvas: canvas)
        
        if let previous = previous {
            canvas.context.move(to: previous.center)
            canvas.context.addLine(to: current.center)
        } else {
            canvas.context.move(to: current.a)
            canvas.context.addLine(to: current.b)
        }
        canvas.context.strokePath()
    }
    
    // MARK: - Method
    private func configure(canvas: Canvas) {
        canvas.context.setStrokeColor(color.cgColor)
        canvas.context.setLineWidth(width)
        canvas.context.setLineCap(CGLineCap.round)
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(current, forKey: "current")
        aCoder.encode(previous, forKey: "previous")
        aCoder.encode(width, forKey: "width")
        aCoder.encode(color, forKey: "color")
    }
    
    required init(coder aDecoder: NSCoder) {
        current = aDecoder.decodeObject(forKey: "current") as! Dot
        previous = aDecoder.decodeObject(forKey: "previous") as? Dot
        width = aDecoder.decodeObject(forKey: "width") as! CGFloat
        color = aDecoder.decodeObject(forKey: "color") as! UIColor
    }
}

class Dot: NSObject, NSCoding {
    // MARK: - Variable
    fileprivate var a: CGPoint! //top, left point
    fileprivate var b: CGPoint! //bottom, right point
    fileprivate var width: CGFloat!
    fileprivate var color: UIColor!
    
    fileprivate var center: CGPoint {
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
    
    // MARK: - Constructor
    public init(a: CGPoint!, b: CGPoint!, width: CGFloat = 5, color: UIColor = .black) {
        self.a = a
        self.b = b
        self.width = width
        self.color = color
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(a, forKey: "a")
        aCoder.encode(b, forKey: "b")
        aCoder.encode(width, forKey: "width")
        aCoder.encode(color, forKey: "color")
    }
    
    required init(coder aDecoder: NSCoder) {
        a = aDecoder.decodeObject(forKey: "a") as! CGPoint
        b = aDecoder.decodeObject(forKey: "b") as! CGPoint
        width = aDecoder.decodeObject(forKey: "width") as! CGFloat
        color = aDecoder.decodeObject(forKey: "color") as! UIColor
    }
}
