//
//  CommandInvoker.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 6..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class CommandInvoker: NSObject, NSCoding {
    // MARK: - Variable
    private var commands: [Command]!
    private var itr: Int = -1
    
    // MARK: - Constructor
    public override init() {
        super.init()
        commands = [Command]()
    }
    
    // MARK: - Method
    public func add(command: Command!) {
        if itr >= 0 { commands = Array(commands[0...itr]) } else { commands.removeAll() }
        
        commands.append(command)
        itr = commands.count - 1
    }
    
    public func removeAllCommands() {
        commands.removeAll()
        itr = -1
    }
    
    public func redoCommands() -> [Command]? {
        guard itr < commands.count - 1 else { return commands }
        
        itr += 1
        return Array(commands[0...itr])
    }
    
    public func undoCommands() -> [Command]? {
        guard itr > 0 else { itr = -1; return nil }
        
        itr -= 1
        return Array(commands[0...itr])
    }
    
    public func currentCommands() -> [Command]? {
        guard itr >= 0 else { return nil }
        return Array(commands[0...itr])
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(commands, forKey: "commands")
        aCoder.encode(itr, forKey: "itr")
    }
    
    required init(coder aDecoder: NSCoder) {
        commands = aDecoder.decodeObject(forKey: "commands") as! [Command]
        itr = aDecoder.decodeInteger(forKey: "itr")
    }
 }
