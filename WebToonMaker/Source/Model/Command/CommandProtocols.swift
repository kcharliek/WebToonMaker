//
//  CommandProtocols.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 6..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

protocol Command {
    func execute(in canvas: Canvas)
}

protocol Canvas {
    var context: CGContext { get }
}
