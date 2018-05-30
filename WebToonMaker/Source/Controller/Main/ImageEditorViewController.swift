//
//  ImageEditorViewController.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

@objc protocol ImageEditorDelegate {
    @objc optional func imageEditor(_ controller: ImageEditorViewController, didFinishPosition image: UIImage, point: CGPoint, size: CGSize)
    @objc optional func imageEditor(_ controller: ImageEditorViewController, didFailToEditing: Error?)
}

class ImageEditorViewController: BaseViewController {
    // MARK: - Variable
    private var editorView: EditorImageView!
    private var originImage: UIImage!
    public var delegate: ImageEditorDelegate?
    
    // MARK: - Action
    @IBAction func confirmBtnClicked(_ sender: Any) {
        delegate?.imageEditor!(self, didFinishPosition: originImage, point: editorView.frame.origin, size: editorView.frame.size)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        delegate?.imageEditor!(self, didFailToEditing: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Method
    public static func make(image: UIImage!) -> ImageEditorViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "ImageEditorViewController") as! ImageEditorViewController
        vc.originImage = image
        return vc
    }
    
    private func configureUI() {
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
            let width = UIScreen.main.bounds.width * 0.7
            var rect = CGRect.zero
            rect.size = CGSize(width: width, height: originImage.size.height / originImage.size.width * width)
            editorView = EditorImageView(frame: rect)
        } else {
            let height = UIScreen.main.bounds.height * 0.7
            var rect = CGRect.zero
            rect.size = CGSize(width: originImage.size.width / originImage.size.height * height, height: height)
            editorView = EditorImageView(frame: rect)
        }
        
        editorView.center = view.center
        editorView.image = originImage
        view.addSubview(editorView)
        
        view.backgroundColor = .clear
        view.isOpaque = false
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
