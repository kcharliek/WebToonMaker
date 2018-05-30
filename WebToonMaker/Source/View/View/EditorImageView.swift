//
//  ImageEditorView.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 10..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class EditorImageView: UIImageView {
    // MARK: - Variable
    var panGesture: UIPanGestureRecognizer!
    var pinchGesture: UIPinchGestureRecognizer!
    
    // MARK: - Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)   
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureSelf() {
        isUserInteractionEnabled = true
        setupGestures()
        
        let borderLayer = CAShapeLayer()
        let border = UIBezierPath(roundedRect: self.frame, cornerRadius: 3)
        borderLayer.path = border.cgPath
        borderLayer.strokeColor = Color.red.cgColor
        borderLayer.lineDashPattern = [4, 2]
        borderLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        layer.addSublayer(borderLayer)
    }
    
    func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePinchGesture(gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began || gesture.state == UIGestureRecognizerState.changed {
            gesture.view?.transform = (gesture.view?.transform)!.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began || gesture.state == UIGestureRecognizerState.changed {
            let translation = gesture.translation(in: self)
            gesture.view?.transform = (gesture.view?.transform)!.translatedBy(x: translation.x, y: translation.y)
            gesture.setTranslation(CGPoint(x: 0, y: 0), in: self)
        }
    }
}
