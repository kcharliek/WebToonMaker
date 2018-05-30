//
//  Constant.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

enum Storyboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let alert = UIStoryboard(name: "Alert", bundle: nil)
    static let popover = UIStoryboard(name: "Popover", bundle: nil)
}

enum TMColor {
    static let primaryColor = Color.Material.blueGrey900
}

enum Menu {
    case color
    case pen
    case eraser
    case sticker
    case bubble
    case undo
    case redo
    case clear
    case photo
    case text
}
