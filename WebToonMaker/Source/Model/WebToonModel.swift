//
//  WebToonModel.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 3..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class WebToon: NSObject, NSCoding {
    // MARK: - Variable
    public private(set) var title: String!
    public private(set) var scenes: [WebToonScene]!
    
    public private(set) var creationDate: Date!
    public var modifiedDate: Date!
    
    // MARK: - Constructor
    private override init() {
        super.init()
    }
    
    public init(title: String!) {
        self.title = title
        
        creationDate = Date()
        modifiedDate = Date()
        
        let cover = WebToonScene()
        scenes = [WebToonScene]()
        scenes.append(cover)
    }
    
    // MARK: - Method
    public func insertNewScene(at: Int) {
        let newScene = WebToonScene()
        scenes.insert(newScene, at: at)
    }
    
    public func removeScene(at: Int) {
        scenes.remove(at: at)
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(creationDate, forKey: "creationDate")
        aCoder.encode(modifiedDate, forKey: "modifiedDate")
        aCoder.encode(scenes, forKey: "scenes")
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        creationDate = aDecoder.decodeObject(forKey: "creationDate") as! Date
        modifiedDate = aDecoder.decodeObject(forKey: "modifiedDate") as! Date
        scenes = aDecoder.decodeObject(forKey: "scenes") as! [WebToonScene]
    }
}

class WebToonScene: NSObject, NSCoding {
    // MARK: - Variable
    private var cuts: [WebToonCut]!
    public var image: UIImage?
    public private(set) var layout: SceneLayout!
    
    // MARK: - Method
    private override init() {
        super.init()
    }
    
    public init(layout: SceneLayout = SceneLayout.Type1()) {
        super.init()
        self.set(layout: layout)
    }
    
    public func cut(indexOf: Int) -> WebToonCut? {
        guard indexOf < cuts.count else { return nil }
        return self.cuts[indexOf]
    }
    
    public func set(layout: SceneLayout) {
        self.layout = layout
        
        var newCuts = [WebToonCut]()
        for cutLayout in layout.cutLayouts {
            let cut = WebToonCut(layout: cutLayout) //WebToonScene(layout: cutLayout)
            newCuts.append(cut)
        }
        cuts = newCuts
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cuts, forKey: "cuts")
        aCoder.encode(layout, forKey: "layout")
        aCoder.encode(image, forKey: "image")
    }
    
    required init(coder aDecoder: NSCoder) {
        cuts = aDecoder.decodeObject(forKey: "cuts") as! [WebToonCut]
        layout = aDecoder.decodeObject(forKey: "layout") as! SceneLayout
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
    }
}

class WebToonCut: NSObject, NSCoding {
    // MARK: - Variable
    public var layout: CutLayout!
    public var image: UIImage?
    public var config: EditorConfiguration!
    
    // MARK: - Constructor
    private override init() {
        super.init()
    }
    
    public init(layout: CutLayout) {
        self.layout = layout
        config = EditorConfiguration()
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(layout, forKey: "layout")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(config, forKey: "config")
    }
    
    required init(coder aDecoder: NSCoder) {
        layout = aDecoder.decodeObject(forKey: "layout") as! CutLayout
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
        config = aDecoder.decodeObject(forKey: "config") as! EditorConfiguration
    }
}
