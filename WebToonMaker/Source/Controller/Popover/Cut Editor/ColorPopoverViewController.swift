//
//  EditorMenuColorPopoverViewController.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class ColorPopoverViewController: BasePopoverViewController {
    // MARK: - Constant
    private typealias CM = Color.Material
    private let numberOfColorsInSection = 5
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var colors = [[Color]]()
    
    // MARK: - Method
    private func configureUI() {
        collectionView.register(UINib(nibName: ColorPopoverCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ColorPopoverCollectionViewCell.className)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    public static func make() -> ColorPopoverViewController {
        let vc = Storyboard.popover.instantiateViewController(withIdentifier: "ColorPopoverViewController") as! ColorPopoverViewController
        return vc
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setColorPreset()
    }
    
    // MARK: - Color Preset
    private func setColorPreset() {
        colors.append([CM.redA700, CM.redA400, CM.redA200, CM.redA100, CM.red100])
        colors.append([CM.pinkA700, CM.pinkA400, CM.pinkA200, CM.pinkA100, CM.pink100])
        colors.append([CM.purpleA700, CM.purpleA400, CM.purpleA200, CM.purpleA100, CM.purple100])
        colors.append([CM.deepPurpleA700, CM.deepPurpleA400, CM.deepPurpleA200, CM.deepPurpleA100, CM.deepPurple100])
        colors.append([CM.indigoA700, CM.indigoA400, CM.indigoA200, CM.indigoA100, CM.indigo100])
        colors.append([CM.blueA700, CM.blueA400, CM.blueA200, CM.blueA100, CM.blue100])
        colors.append([CM.lightBlueA700, CM.lightBlueA400, CM.lightBlueA200, CM.lightBlueA100, CM.lightBlue100])
        colors.append([CM.cyanA700, CM.cyanA400, CM.cyanA200, CM.cyanA100, CM.cyan100])
        colors.append([CM.tealA700, CM.tealA400, CM.tealA200, CM.tealA100, CM.teal100])
        colors.append([CM.greenA700, CM.greenA400, CM.greenA200, CM.greenA100, CM.green100])
        colors.append([CM.lightGreenA700, CM.lightGreenA400, CM.lightGreenA200, CM.lightGreenA100, CM.lightGreen100])
        colors.append([CM.limeA700, CM.limeA400, CM.limeA200, CM.limeA100, CM.lime100])
        colors.append([CM.yellowA700, CM.yellowA400, CM.yellowA200, CM.yellowA100, CM.yellow100])
        colors.append([CM.amberA700, CM.amberA400, CM.amberA200, CM.amberA100, CM.amber100])
        colors.append([CM.orangeA700, CM.orangeA400, CM.orangeA200, CM.orangeA100, CM.orange100])
        colors.append([CM.deepOrangeA700, CM.deepOrangeA400, CM.deepOrangeA200, CM.deepOrangeA100, CM.deepOrange100])
        colors.append([CM.brown900, CM.brown700, CM.brown500, CM.brown200, CM.brown100])
        colors.append([CM.blueGrey900, CM.blueGrey700, CM.blueGrey500, CM.blueGrey200, CM.blueGrey100])
        colors.append([CM.black, CM.grey900, CM.grey700, CM.grey500, CM.white])
    }
}

extension ColorPopoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPopoverCollectionViewCell.className, for: indexPath) as! ColorPopoverCollectionViewCell
        cell.color = colors[indexPath.section][indexPath.row]
        return cell
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.popover!(self, didSelectColor: colors[indexPath.section][indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(numberOfColorsInSection)
        return CGSize(width: width, height: width)
    }
}
