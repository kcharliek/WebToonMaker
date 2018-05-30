//
//  FontTextFieldAlertViewController.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 18..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Toaster

protocol FontTextFieldAlertDelegate {
    func alert(_ controller: BaseViewController, didFinishText textImage: UIImage)
}

class FontTextFieldAlertViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var fontPickerTextField: FontPickerTextField!
    
    // MARK: - Variable
    public var delegate: FontTextFieldAlertDelegate?
    
    // MARK: - Action
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        guard let text = fontPickerTextField.text, text.count > 0 else {
            fontPickerTextField.resignFirstResponder()
            Toast(text: "텍스트를 입력 해주세요.").show()
            return
        }
        
        self.dismiss(animated: true) {
            guard let attributedText = self.fontPickerTextField.attributedText else { return }
            let textHeight = self.fontPickerTextField.picker.selectedSize!
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: textHeight)
            let boundingBox = attributedText.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
            let textSize = CGSize(width: ceil(boundingBox.width), height: textHeight)
            
            let textImage = UIImage(text: attributedText, size: textSize)
            self.delegate?.alert(self, didFinishText: textImage)
        }
    }
    
    // MARK: - Method
    public static func make() -> FontTextFieldAlertViewController {
        let vc = Storyboard.alert.instantiateViewController(withIdentifier: "FontTextFieldAlertViewController") as! FontTextFieldAlertViewController
        return vc
    }
    
    private func configureUI() {
        fontPickerTextField.picker.fontDelegate = self
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension FontTextFieldAlertViewController: FontPickerViewDelegate {
    func fontPickerView(_ fontPickerView: FontPickerView, didSelectAttributes attributes: [NSAttributedStringKey: Any]?) {
        guard let attributes = attributes else { return }
        fontPickerTextField.attributedText = NSAttributedString(string: fontPickerTextField.text!, attributes: attributes)
    }
}
