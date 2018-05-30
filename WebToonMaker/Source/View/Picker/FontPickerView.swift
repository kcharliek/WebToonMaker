//
//  FontPicker.swift
//  FontPicker
//
//  Created by CHANHEE KIM on 2018. 5. 16..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

protocol FontPickerViewDelegate {
    func fontPickerView(_ fontPickerView: FontPickerView, didSelectAttributes attributes: [NSAttributedStringKey: Any]?)
}

class FontPickerView: UIPickerView {
    // MARK: - Constant
    private let fontFamiles = ["NanumGothicOTF", "NanumBarunGothicOTF", "NanumSquareOTF", "NanumMyeongjoOTF", "NanumSquareRoundOTF", "NanumBarunpen", "Nanum Brush Script OTF"]
    private var fonts = [String]()
    private let colors: [UIColor] = [.white, .gray, .black, .red, .orange, .green, .cyan, .blue, .purple]
    private var sizes: [CGFloat]!
    
    // MARK: - Variable
    public var fontDelegate: FontPickerViewDelegate?
    
    private var selectedColor: UIColor?
    public private(set) var selectedSize: CGFloat?
    private var selectedFont: String?
    
    // MARK: - Contructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Method
    private func configureUI() {
        self.dataSource = self
        
        fonts.append("HelveticaNeue")
        for family in fontFamiles {
            let fontsInFamily = UIFont.fontNames(forFamilyName: family)
            for font in fontsInFamily {
                fonts.append(font)
            }
        }
        
        sizes = [CGFloat]()
        for i in stride(from: 1.0, through: 50.0, by: 0.5) { sizes.append(CGFloat(i)) }
        
        //*Set Default Font*
        selectedFont = "HelveticaNeue"
        //*Set Default Color*
        selectedColor = .black
        //*Set Default Size*
        selectedSize = 16
        
        //*Set Default Rows*
        selectRow(0, inComponent: 0, animated: false) //default font : HelveticaNeue
        selectRow(2, inComponent: 1, animated: false) //default color : black
        selectRow(30, inComponent: 2, animated: false) //default font size : 16
        
        self.delegate = self
    }
    
    private func makeAttribute() -> [NSAttributedStringKey: Any]? {
        guard let selectedFont = selectedFont, let selectedSize = selectedSize else { return nil }
        
        var ret = [NSAttributedStringKey: Any]()
        ret[NSAttributedStringKey.font] = UIFont(name: selectedFont, size: selectedSize)
        if let selectedColor = selectedColor {
            ret[NSAttributedStringKey.foregroundColor] = selectedColor
        }
        return ret
    }
}

extension FontPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //font, text color, font size
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: //font
            return fonts.count
        case 1: //text color
            return colors.count
        case 2: //font size
            return sizes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        
        switch component {
        case 0: //font
            label.text = fonts[row]
            label.font = UIFont(name: fonts[row], size: 13)
        case 1: //text color
            label.text = ""
            label.backgroundColor = colors[row]
        case 2: //font size
            label.text = "\(sizes[row])"
        default:
            break
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        switch component {
        case 0: //font
            return screenWidth * 0.6
        case 1: //text color
            return screenWidth * 0.2
        case 2: //font size
            return screenWidth * 0.2
        default:
            return 0
        }
    }
    
    // MARK: - PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: //font
            selectedFont = fonts[row]
        case 1: //text color
            selectedColor = colors[row]
        case 2: //font size
            selectedSize = sizes[row]
        default:
            break
        }
        
        fontDelegate?.fontPickerView(self, didSelectAttributes: makeAttribute())
    }
}
