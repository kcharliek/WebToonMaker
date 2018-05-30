//
//  StickerPopoverViewController.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Toaster

class ImagePopoverViewController: BasePopoverViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var images: [UIImage]!
    
    // MARK: - Action
    @IBAction func addBtnClicked(_ sender: Any) {
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?[0] else {
            Toast(text: "이미지를 한 개 이상 선택 해주세요.").show()
            return
        }
        let selectedImage: UIImage = images[selectedIndexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.popover!(self, didSelectImage: selectedImage)
        }
    }
    
    // MARK: - Method
    public static func make(with images: [UIImage]) -> ImagePopoverViewController {
        let vc = Storyboard.popover.instantiateViewController(withIdentifier: "ImagePopoverViewController") as! ImagePopoverViewController
        vc.images = images
        return vc
    }
    
    func configureUI() {
        collectionView.register(UINib(nibName: ImagePopoverCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ImagePopoverCollectionViewCell.className)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension ImagePopoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePopoverCollectionViewCell.className, for: indexPath) as! ImagePopoverCollectionViewCell
        cell.set(image: images[indexPath.row])
        return cell
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // MARK: - CollecitonView Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
