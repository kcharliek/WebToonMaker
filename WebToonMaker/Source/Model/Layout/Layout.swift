//
//  Layout.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 3..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class CutLayout: NSObject, NSCoding {
    // MARK: - Variable
    private var startPoint: (Int, Int)! //Horizontal Position : 0, 1, Vertical Position : 0, 1, 2
    private var widthRatio: CGFloat!
    private var heightRatio: CGFloat!
    public private(set) var aspectRatio: CGFloat!
    
    // MARK: - Constructor
    private override init() {
        super.init()
    }
    
    public init(sp: (Int, Int), wr: CGFloat, hr: CGFloat) {
        super.init()
        
        self.startPoint = sp
        self.widthRatio = wr / 2
        self.heightRatio = hr / 3
        self.aspectRatio = hr / wr
    }
    
    // MARK: - Method
    public func frame(in superViewFrame: CGRect) -> CGRect {
        let x = superViewFrame.width * CGFloat(startPoint.0) / 2
        let y = superViewFrame.height * CGFloat(startPoint.1) / 3
        let width = superViewFrame.width * widthRatio
        let height = superViewFrame.height * heightRatio
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(startPoint.0, forKey: "startPoint0")
        aCoder.encode(startPoint.1, forKey: "startPoint1")
        aCoder.encode(widthRatio, forKey: "widthRatio")
        aCoder.encode(heightRatio, forKey: "heightRatio")
        aCoder.encode(aspectRatio, forKey: "aspectRatio")
    }
    
    required init(coder aDecoder: NSCoder) {
        let startPoint0 = aDecoder.decodeInteger(forKey: "startPoint0")
        let startPoint1 = aDecoder.decodeInteger(forKey: "startPoint1")
        startPoint = (startPoint0, startPoint1)
        widthRatio = aDecoder.decodeObject(forKey: "widthRatio") as! CGFloat
        heightRatio = aDecoder.decodeObject(forKey: "heightRatio") as! CGFloat
        aspectRatio = aDecoder.decodeObject(forKey: "aspectRatio") as! CGFloat
    }
}

class SceneLayout: NSObject, NSCoding {
    // MARK: - Variable
    public private(set) var cutLayouts: [CutLayout]!
    public private(set) var sample: UIImage!
    
    // MARK: - Constructor
    override init() {
        super.init()
        self.cutLayouts = [CutLayout]()
    }
    
    // MARK: - Predesigned Layout
    public static func getAll() -> [SceneLayout] {
        return [Type1(), Type2(), Type3(), Type4(), Type5(), Type6(), Type7(), Type8()]
    }
    
    public static func Type1() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type1")
        
        let cut1 = CutLayout(sp: (0, 0), wr: 2, hr: 3)
        layout.cutLayouts.append(cut1)
        
        return layout
    }
    
    public static func Type2() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type2")
        let cut1 = CutLayout(sp: (0, 0), wr: 2, hr: 2)
        let cut2 = CutLayout(sp: (0, 2), wr: 2, hr: 1)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        
        return layout
    }
    
    public static func Type3() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type3")
        let cut1 = CutLayout(sp: (0, 0), wr: 2, hr: 1)
        let cut2 = CutLayout(sp: (0, 1), wr: 2, hr: 2)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        
        return layout
    }
    
    public static func Type4() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type4")
        let cut1 = CutLayout(sp: (0, 0), wr: 2, hr: 1)
        let cut2 = CutLayout(sp: (0, 1), wr: 2, hr: 1)
        let cut3 = CutLayout(sp: (0, 2), wr: 2, hr: 1)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        layout.cutLayouts.append(cut3)
        
        return layout
    }
    
    public static func Type5() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type5")
        let cut1 = CutLayout(sp: (0, 0), wr: 1, hr: 2)
        let cut2 = CutLayout(sp: (1, 0), wr: 1, hr: 1)
        let cut3 = CutLayout(sp: (0, 2), wr: 1, hr: 1)
        let cut4 = CutLayout(sp: (1, 1), wr: 1, hr: 2)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        layout.cutLayouts.append(cut3)
        layout.cutLayouts.append(cut4)
        
        return layout
    }
    
    public static func Type6() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type6")
        let cut1 = CutLayout(sp: (0, 0), wr: 1, hr: 1)
        let cut2 = CutLayout(sp: (1, 0), wr: 1, hr: 2)
        let cut3 = CutLayout(sp: (0, 1), wr: 1, hr: 2)
        let cut4 = CutLayout(sp: (1, 2), wr: 1, hr: 1)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        layout.cutLayouts.append(cut3)
        layout.cutLayouts.append(cut4)
        
        return layout
    }
    
    public static func Type7() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type7")
        let cut1 = CutLayout(sp: (0, 0), wr: 2, hr: 1)
        let cut2 = CutLayout(sp: (0, 1), wr: 1, hr: 1)
        let cut3 = CutLayout(sp: (1, 1), wr: 1, hr: 1)
        let cut4 = CutLayout(sp: (0, 2), wr: 2, hr: 1)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        layout.cutLayouts.append(cut3)
        layout.cutLayouts.append(cut4)
        
        return layout
    }
    
    public static func Type8() -> SceneLayout {
        let layout = SceneLayout()
        layout.sample = #imageLiteral(resourceName: "Layout_Sample_Type8")
        let cut1 = CutLayout(sp: (0, 0), wr: 1, hr: 1)
        let cut2 = CutLayout(sp: (1, 0), wr: 1, hr: 1)
        let cut3 = CutLayout(sp: (0, 1), wr: 2, hr: 1)
        let cut4 = CutLayout(sp: (0, 2), wr: 1, hr: 1)
        let cut5 = CutLayout(sp: (1, 2), wr: 1, hr: 1)
        
        layout.cutLayouts.append(cut1)
        layout.cutLayouts.append(cut2)
        layout.cutLayouts.append(cut3)
        layout.cutLayouts.append(cut4)
        layout.cutLayouts.append(cut5)
        
        return layout
    }
    
    // MARK: - NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cutLayouts, forKey: "cutLayouts")
    }
    
    required init(coder aDecoder: NSCoder) {
        cutLayouts = aDecoder.decodeObject(forKey: "cutLayouts") as! [CutLayout]
    }
}
