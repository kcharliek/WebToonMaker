//
//  LineCommand.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 7..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class LineCommand: NSObject, NSCoding, Command {
    // MARK: - Variable
    private var dotCommands: [DotCommand]!
    
    // MARK: - Constructor
    public override init() {
        super.init()
        dotCommands = [DotCommand]()
    }
    
    // MARK: - Command Protocol
    func execute(in canvas: Canvas) {
        for dotCmd in dotCommands {
            dotCmd.execute(in: canvas)
        }
    }
    
    // MARK: - Method
    public func addDotCommand(command: DotCommand!) {
        dotCommands.append(command)
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dotCommands, forKey: "dotCommands")
    }
    
    required init(coder aDecoder: NSCoder) {
        dotCommands = aDecoder.decodeObject(forKey: "dotCommands") as! [DotCommand]
    }
}
