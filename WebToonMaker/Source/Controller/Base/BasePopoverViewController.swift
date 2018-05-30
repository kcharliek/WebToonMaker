//
//  BasePopoverViewController.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

@objc protocol TMPopoverDelegate {
    @objc optional func popover(_ controller: BasePopoverViewController, didSelectIndex index: Int)
    @objc optional func popover(_ controller: BasePopoverViewController, didSelectValue value: CGFloat)
    @objc optional func popover(_ controller: BasePopoverViewController, didSelectColor color: UIColor)
    @objc optional func popover(_ controller: BasePopoverViewController, didSelectLayout layout: SceneLayout)
    @objc optional func popover(_ controller: BasePopoverViewController, didSelectImage image: UIImage)
}

class BasePopoverViewController: UIViewController {
    // MARK: - Variable
    public var arrowDirection: UIPopoverArrowDirection?
    public var data: Any?
    public var tag: Int = 0
    public var delegate: TMPopoverDelegate? {
        didSet {
            self.modalPresentationStyle = .popover
            self.popoverPresentationController?.delegate = self
        }
    }
    public var sourceView: UIView! {
        didSet {
            self.popoverPresentationController?.sourceView = self.sourceView
            self.popoverPresentationController?.sourceRect = self.sourceView.bounds
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = .white
    }
}

extension BasePopoverViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = arrowDirection ?? .any
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
