//
//  BookShelfViewController.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Toaster
import PKHUD

class BookShelfViewController: BaseViewController {
    // MARK: - Constant
    private let sectionInsetValue: CGFloat = 20
    private let itemSpcing: CGFloat = 20
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var webToons: [WebToon]?
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Method
    //For Extport WebToon
    func combine(images: [UIImage], title: String, width: CGFloat) -> UIImage {
        let labelHeight: CGFloat = 100
        //WebToon Title
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: labelHeight)).then {
            $0.text = title
            $0.isOpaque = false
            $0.textAlignment = .center
            $0.font = UIFont(name: "NanumGothicOTFBold", size: 30)
        }
        let labelImage = UIImage(view: label)
        
        var cache: UIImage = labelImage
        for img in images {
            cache = UIImage(top: cache, bottom: img, width: width)
        }
        return cache
    }
    
    func fetchData() {
        webToons = WebToonStore.shared.fetchAllWebToons()
    }

    // MARK: - Method
    public static func make() -> BookShelfViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "BookShelfViewController") as! BookShelfViewController
        return vc
    }
    
    func configureUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: sectionInsetValue, left: sectionInsetValue, bottom: sectionInsetValue, right: sectionInsetValue)
        }
        
        collectionView.register(UINib(nibName: BookShelfCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: BookShelfCollectionViewCell.className)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HUD.show(.systemActivity)
        fetchData()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.hide()
    }
}

extension BookShelfViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ret = webToons?.count ?? 0
        if ret == 0 { collectionView.isHidden = true } else { collectionView.isHidden = false }
        return ret
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookShelfCollectionViewCell.className, for: indexPath) as! BookShelfCollectionViewCell
        cell.set(model: webToons![indexPath.row])
        return cell
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BookShelfCollectionViewCell
        let menus = ["뷰어로 읽기", "이어서 편집", "앨범에 저장", "삭제"]
        _ = ListPopoverViewController.make(source: menus).then {
            $0.delegate = self
            $0.data = cell.model
            $0.sourceView = cell
            $0.preferredContentSize = CGSize(width: 95, height: $0.rowHeight * CGFloat(menus.count))
            present($0, animated: true, completion: nil)
        }
    }
    
    // MARK: - CollectionView FlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - sectionInsetValue * 2 - itemSpcing) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpcing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpcing
    }
}

extension BookShelfViewController: TMPopoverDelegate {
    func popover(_ controller: BasePopoverViewController, didSelectIndex index: Int) {
        guard let model = controller.data as? WebToon else { controller.dismiss(animated: true, completion: nil); return }
        controller.dismiss(animated: true, completion: {
            if index == 0 {
                //뷰어로 읽기
                if let _ = model.scenes[0].image {
                    let viewerVC = ViewerViewController.make()
                    viewerVC.set(model: model)
                    self.navigationController?.pushViewController(viewerVC, animated: true)
                } else {
                    Toast(text: "이미지가 없습니다. '이어서 편집' 기능으로 웹툰을 채워주세요.").show()
                }
            } else if index == 1 {
                //이어서 편집
                let sceneEditorVC = SceneEditorViewController.make(with: model)
                self.navigationController?.pushViewController(sceneEditorVC, animated: true)
            } else if index == 2 {
                //앨범에 저장
                let outputImage = self.combine(images: model.scenes.map({$0.image!}), title: model.title, width: 400)
                MyWebToonAlbum.shared.save(image: outputImage, completion: { (result) in
                    switch result {
                    case 0:
                        Toast(text: "앨범에 저장 되었습니다.").show()
                    case 1:
                        Toast(text: "앨범에 접근할 수 없습니다. 설정에서 권한을 허용해 주세요.").show()
                    case 2:
                        Toast(text: "파일을 저장할 수 없습니다. 저장 공간을 확인해 주세요.").show()
                    default:
                        break
                    }
                })
            } else if index == 3 {
                //삭제
                let alert = UIAlertController(title: "삭제", message: "삭제 실행 이후 다시 되돌릴 수 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                    if WebToonStore.shared.remove(webToon: model) {
                        Toast(text: "삭제 되었습니다.").show()
                        self.fetchData()
                        self.collectionView.reloadData()
                    } else {
                        Toast(text: "삭제에 실패했습니다.").show()
                    }
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
