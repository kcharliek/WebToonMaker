//
//  FontPickerTextField.swift
//  FontPicker
//
//  Created by CHANHEE KIM on 2018. 5. 16..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class FontPickerTextField: UITextField {
    // MARK: - Constant
    private let defualtFontSize: CGFloat = 16
    
    // MARK: - Variable
    public let picker = FontPickerView()
    
    // MARK: - Actions
    @objc func keyboardBtnClicked() {
        if inputView == picker {
            self.resignFirstResponder()
            inputView = nil
            self.becomeFirstResponder()
        }
    }
    
    @objc func fontBtnClicked() {
        if inputView == nil {
            self.resignFirstResponder()
            inputView = picker
            self.becomeFirstResponder()
        }
    }
    
    @objc func doneBtnClicked() {
        self.resignFirstResponder()
    }
    
    // MARK: - Method
    override func awakeFromNib() {
        configureUI()
    }
    
    func configureUI() {
        self.returnKeyType = .done
        self.adjustsFontSizeToFitWidth = false
        self.borderStyle = .none
        self.placeholder = "텍스트를 입력해주세요"
        self.font = UIFont.systemFont(ofSize: defualtFontSize)
        self.backgroundColor = .clear
        
        inputView = nil
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "키보드", style: .plain, target: self, action: #selector(self.keyboardBtnClicked)),
            UIBarButtonItem(title: "폰트", style: .plain, target: self, action: #selector(self.fontBtnClicked)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.doneBtnClicked))
        ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
}
