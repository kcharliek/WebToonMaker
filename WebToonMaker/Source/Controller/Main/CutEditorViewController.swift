//
//  SceneEditorViewController.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Then
import PKHUD
import Toaster

// WebToon => Scene => *Cut*
class CutEditorViewController: BaseViewController {
    // MARK: - Constant
    private let menus: [(Menu, UIImage)] = [(.color, #imageLiteral(resourceName: "cut_editor_menu_color")), (.pen, #imageLiteral(resourceName: "cut_editor_menu_pen")), (.eraser, #imageLiteral(resourceName: "cut_editor_menu_eraser")), (.photo, #imageLiteral(resourceName: "cut_editor_menu_photo")), (.sticker, #imageLiteral(resourceName: "cut_editor_menu_sticker")), (.bubble, #imageLiteral(resourceName: "cut_editor_menu_bubble")), (.text, #imageLiteral(resourceName: "cut_editor_menu_text")), (.undo, #imageLiteral(resourceName: "cut_editor_menu_undo")), (.redo, #imageLiteral(resourceName: "cut_editor_menu_redo")), (.clear, #imageLiteral(resourceName: "cut_editor_menu_clear"))]
    
    // MARK: - IBOutlet
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var editorView: PaintView!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Variable
    private var model: WebToonCut!
    private var isLandscape: Bool = false
    private var mode: Menu = .pen
    private var config: EditorConfiguration!
    
    //Temporary Variables For Drawing Line
    private var lastPoint: CGPoint = CGPoint.zero
    private var lineCommand: LineCommand?
    private var lastDot: Dot?
    
    // MARK: - Actions
    @IBAction func backBtnClicked(_ sender: Any) {
        model.image = UIImage(view: editorView)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Pan Gesture Method
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: sender.view)
        switch sender.state {
        case .began:
            panBeganAt(point: point)
        case .changed:
            panChangedAt(point: point)
        case .ended, .cancelled, .failed:
            panEndAt(point: point)
        default:
            break
        }
    }
    
    private func panBeganAt(point: CGPoint) {
        if mode == .pen || mode == .eraser {
            lineCommand = LineCommand()
        }
        lastPoint = point
    }
    
    private func panChangedAt(point: CGPoint) {
        if mode == .pen || mode == .eraser {
            let width: CGFloat = mode == .pen ? config.penWidth : config.eraserWidth
            let color: Color = mode == .eraser ? .white : config.currentColor
            let dot = Dot(a: lastPoint, b: point, width: width, color: color)
            
            let dotCommand = DotCommand(current: dot, previous: lastDot)
            editorView.execute(commands: [dotCommand])
            lineCommand?.addDotCommand(command: dotCommand)
            lastDot = dot
        }
        
        lastPoint = point
    }
    
    private func panEndAt(point: CGPoint) {
        if mode == .pen || mode == .eraser {
            if let lineCommand = lineCommand {
                config.commandInvoker.add(command: lineCommand)
            }
            lastDot = nil
            lineCommand = nil
        }
        
        lastPoint = CGPoint.zero
    }
    
    // MARK: - Method
    private func showImageEditor(with image: UIImage) {
        let imageEditorVC = ImageEditorViewController.make(image: image).then {
            $0.modalPresentationStyle = .overCurrentContext
            $0.modalTransitionStyle = .crossDissolve
            $0.delegate = self
        }
        self.isAllComponentHidden(flag: true)
        self.present(imageEditorVC, animated: true, completion: nil)
    }
    private func isAllComponentHidden(flag: Bool) {
        menuCollectionView.isHidden = flag
        backButton.isHidden = flag
    }
    
    private func configureFor(orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            if let flowLayout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .vertical
            }
            isLandscape = true
        } else {
            if let flowLayout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .horizontal
            }
            isLandscape = false
        }
    }
    
    public static func make(cut: WebToonCut) -> CutEditorViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "CutEditorViewController") as! CutEditorViewController
        vc.model = cut
        vc.config = cut.config
        return vc
    }
    
    private func configureUI() {
        view.do {
            $0.backgroundColor = TMColor.primaryColor
        }
        menuCollectionView.do {
            $0.register(UINib(nibName: CutEditorMenuCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CutEditorMenuCollectionViewCell.className)
            $0.backgroundColor = TMColor.primaryColor
        }
        
        editorView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addConstraint(NSLayoutConstraint(item: $0,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: $0,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: model.layout.aspectRatio,
                                                constant: 0))
            $0.layer.borderColor = Color.black.cgColor
            $0.layer.borderWidth = 1
            $0.layoutIfNeeded()
        }
        configureFor(orientation: UIDevice.current.orientation)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HUD.show(.systemActivity)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if model.layout.aspectRatio < 1 {
            AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Load Scene
        editorView.execute(commands: config.commandInvoker.currentCommands())
        HUD.hide()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //Detect Orientation Change Here
        configureFor(orientation: UIDevice.current.orientation)
    }
}

extension CutEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CutEditorMenuCollectionViewCell.className, for: indexPath) as! CutEditorMenuCollectionViewCell
        cell.type = menus[indexPath.row].0
        
        var menuImage = menus[indexPath.row].1
        if cell.type == .color, let tintedImage = menuImage.tinted(with: config.currentColor) {
            menuImage = tintedImage
        }
        cell.setIcon(image: menuImage)
        
        return cell
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! CutEditorMenuCollectionViewCell
            if cell.type == .color {
                _ = ColorPopoverViewController.make().then {
                    $0.delegate = self
                    $0.sourceView = cell
                    let width: CGFloat = 200
                    $0.preferredContentSize = CGSize(width: width, height: width * 1.5)
                    present($0, animated: true, completion: nil)
                }
            } else if cell.type == .pen || cell.type == .eraser {
                _ = PenWidthPopoverViewController.make().then {
                    $0.delegate = self
                    $0.sourceView = cell
                    $0.type = cell.type
                    $0.dotWidth = cell.type == .pen ? config.penWidth : config.eraserWidth
                    $0.preferredContentSize = CGSize(width: 300, height: 125)
                    present($0, animated: true, completion: nil)
                }
                mode = cell.type
            } else if cell.type == .photo {
                let handler = CameraHandler(delegate: self)
                let alert = UIAlertController(title: "이미지 추가", message: nil, preferredStyle: .actionSheet).then {
                    $0.addAction(UIAlertAction(title: "갤러리에서 가져오기", style: .default, handler: { (_) in
                        handler.getPhotoLibrary(on: self, canEdit: false)
                    }))
                    $0.addAction(UIAlertAction(title: "카메라로 사진찍기", style: .default, handler: { (_) in
                        handler.getCamera(on: self, canEdit: false)
                    }))
                    $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                }
                //For Ipad
                if let popoverPresentationController = alert.popoverPresentationController {
                    popoverPresentationController.sourceView = cell
                    popoverPresentationController.sourceRect = cell.bounds
                }
                present(alert, animated: true, completion: nil)
            } else if cell.type == .sticker || cell.type == .bubble {
                var imageNames = [String]()
                let imagePrefix = cell.type == .sticker ? "sticker" : "speechBubble"
                let numberOfImage = cell.type == .sticker ? 12 : 9
                for i in 1...numberOfImage {
                    imageNames.append(imagePrefix + "\(i)")
                }
                let images: [UIImage] = imageNames.map { (str) -> UIImage in return UIImage(named: str)! }
                
                _ = ImagePopoverViewController.make(with: images).then {
                    $0.delegate = self
                    $0.sourceView = cell
                    let width = UIScreen.main.bounds.width * 0.7
                    $0.preferredContentSize = CGSize(width: width, height: width)
                    present($0, animated: true, completion: nil)
                }
            } else if cell.type == .text {
                
                let fontTFVC = FontTextFieldAlertViewController.make()
                fontTFVC.delegate = self
                self.present(fontTFVC, animated: true, completion: nil)
            } else if cell.type == .undo {
                editorView.reset()
                editorView.execute(commands: config.commandInvoker.undoCommands())
            } else if cell.type == .redo {
                editorView.reset()
                editorView.execute(commands: config.commandInvoker.redoCommands())
            } else if cell.type == .clear {
                let alert = UIAlertController(title: "화면 비우기", message: "화면 내 모든 내용이 사라집니다.", preferredStyle: .alert).then {
                    $0.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
                        self.config.commandInvoker.removeAllCommands()
                        self.editorView.reset()
                    })
                    $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                }
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - CollectionView FlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
}

extension CutEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            Toast(text: "이미지를 가져오지 못했습니다.").show()
            return
        }
        //make image small
        var selectedImage = image
        let MaxWidth: CGFloat = 1200
        let MaxHeight: CGFloat = 1200
        if selectedImage.size.width > MaxWidth {
            selectedImage = selectedImage.resize(targetSize: CGSize(width: MaxWidth, height: selectedImage.size.height / selectedImage.size.width * MaxWidth))
        }
        if selectedImage.size.height > MaxHeight {
            selectedImage = selectedImage.resize(targetSize: CGSize(width: selectedImage.size.width / selectedImage.size.height * MaxHeight, height: MaxHeight))
        }
        
        picker.dismiss(animated: true) {
            self.showImageEditor(with: selectedImage)
        }
    }
}

extension CutEditorViewController: ImageEditorDelegate {
    func imageEditor(_ controller: ImageEditorViewController, didFinishPosition image: UIImage, point: CGPoint, size: CGSize) {
        let origin = CGPoint(x: point.x - editorView.frame.origin.x, y: point.y - editorView.frame.origin.y)
        let imageCommand = ImageCommand(image: image, position: CGRect(origin: origin, size: size))
        editorView.execute(commands: [imageCommand])
        config.commandInvoker.add(command: imageCommand)
        isAllComponentHidden(flag: false)
    }
    func imageEditor(_ controller: ImageEditorViewController, didFailToEditing: Error?) {
        isAllComponentHidden(flag: false)
    }
}

extension CutEditorViewController: FontTextFieldAlertDelegate {
    func alert(_ controller: BaseViewController, didFinishText textImage: UIImage) {
        showImageEditor(with: textImage)
    }
}

extension CutEditorViewController: TMPopoverDelegate {
    func popover(_ controller: BasePopoverViewController, didSelectColor color: UIColor) {
        config.currentColor = color
        let indexPath = IndexPath(item: 0, section: 0) //color cell
        menuCollectionView.reloadItems(at: [indexPath])
    }
    
    func popover(_ controller: BasePopoverViewController, didSelectValue value: CGFloat) {
        if let vc = controller as? PenWidthPopoverViewController {
            if vc.type == .pen { config.penWidth = value } else { config.eraserWidth = value }
        }
    }
    
    func popover(_ controller: BasePopoverViewController, didSelectImage image: UIImage) {
        self.showImageEditor(with: image)
    }
}

extension CutEditorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            if mode == .pen || mode == .eraser {
                return true
            }
        }
        return false
    }
}
