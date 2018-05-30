//
//  SceneEditorViewController.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Then
import Toaster
import Actions
import PKHUD

// WebToon => *Scene* => Cut
class SceneEditorViewController: BaseViewController {
    // MARK: - Constant
    let sceneSpacing: CGFloat = 5
    
    // MARK: - IBOutlet
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var moreBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var layoutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var newBarButtonItem: UIBarButtonItem!
    
    // MARK: - Variable
    private var webToonModel: WebToon!
    private var sceneModel: WebToonScene! {
        didSet {
            if isViewDidAppearCalled {
                drawScene()
            }
        }
    }
    private var currentScene: Int = -1 {
        didSet {
            if currentScene >= 0 {
                sceneModel = webToonModel.scenes[currentScene]
                if currentScene > 0 {
                    Toast(text: "\(currentScene)/\(webToonModel.scenes.count - 1)").show()
                } else {
                    Toast(text: "표지").show()
                }
            } else {
                currentScene = 0
            }
        }
    }
    private var isViewDidAppearCalled: Bool = false
    private var isDataChanged: Bool = false
    
    // MARK: - Actions
    @IBAction func newSceneBtnClicked(_ sender: Any) {
        var menus = ["아래로 삽입"]
        //cover cannot insert scene to front
        if currentScene > 0 { menus.insert("위로 삽입", at: 0) }
        
        _ = ListPopoverViewController.make(source: menus).then {
            $0.tag = 111 //new
            $0.modalPresentationStyle = .popover
            $0.delegate = self
            $0.popoverPresentationController?.barButtonItem = newBarButtonItem
            $0.preferredContentSize = CGSize(width: 95, height: $0.rowHeight * CGFloat(menus.count))
            present($0, animated: true, completion: nil)
        }
    }
    
    @IBAction func moreBtnClicked(_ sender: Any) {
        let menus = ["저장", "페이지 삭제"]
        _ = ListPopoverViewController.make(source: menus).then {
            $0.tag = 222
            $0.modalPresentationStyle = .popover
            $0.delegate = self
            $0.popoverPresentationController?.barButtonItem = moreBarButtonItem
            $0.preferredContentSize = CGSize(width: 95, height: $0.rowHeight * CGFloat(menus.count))
            present($0, animated: true, completion: nil)
        }
    }
    
    @IBAction func layoutBtnClicked(_ sender: Any) {
        guard presentedViewController == nil else { return }
        guard currentScene > 0 else {
            Toast(text: "표지 레이아웃은 변경할 수 없습니다.").show()
            return
        }
        let alert = UIAlertController(title: "레이아웃 변경", message: "레이아웃을 변경하면 페이지 안의 모든 이미지는 삭제됩니다.", preferredStyle: .alert).then {
            $0.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
                _ = LayoutSamplePopoverViewController.make().then {
                    $0.delegate = self
                    $0.popoverPresentationController?.barButtonItem = self.layoutBarButtonItem
                    $0.preferredContentSize = CGSize(width: 320, height: 400)
                    self.present($0, animated: true, completion: nil)
                }
            })
            $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func viewSwiped(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            go(scene: currentScene + 1)
        } else if sender.direction == .down {
            go(scene: currentScene - 1)
        }
    }
    
    @IBAction func goBeforeSceneBtnClicked(_ sender: Any) {
        go(scene: currentScene - 1)
    }
    @IBAction func goNextSceneBtnClicked(_ sender: Any) {
        go(scene: currentScene + 1)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        guard isDataChanged == false else {
            let alert = UIAlertController(title: "알림", message: "변경 사항이 있습니다. 저장 하시겠습니까?", preferredStyle: .alert).then {
                $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                $0.addAction(UIAlertAction(title: "무시", style: .default, handler: { (_) in
                    self.closeEditor()
                }))
                $0.addAction(UIAlertAction(title: "저장", style: .default, handler: { (_) in
                    _ = WebToonStore.shared.save(webToon: self.webToonModel)
                    self.closeEditor()
                }))
            }
            present(alert, animated: true, completion: nil)
            return
        }
        
        closeEditor()
    }
    
    private func closeEditor() {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController!.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cutSelected(sender: Any) {
        let sender = sender as! UIImageView
        guard let cut = sceneModel.cut(indexOf: sender.tag) else { return }
        
        let cutEditorVC = CutEditorViewController.make(cut: cut)
        navigationController?.pushViewController(cutEditorVC, animated: true)
        isDataChanged = true
    }
    
    // MARK: - Method
    private func go(scene: Int) {
        if scene < 0 {
            Toast(text: "웹툰의 처음입니다.").show()
            return
        } else if scene > webToonModel.scenes.count - 1 {
            Toast(text: "웹툰의 마지막입니다.").show()
            return
        }
        
        currentScene = scene
    }
    
    private func drawScene() {
        for v in sceneView.subviews { v.removeFromSuperview() }
        
        var idx = 0
        sceneView.layoutIfNeeded()
        
        for cutLayout in sceneModel.layout.cutLayouts {
            let sceneFrame = cutLayout.frame(in: sceneView.bounds)
            _ = UIImageView().then {
                $0.frame = sceneFrame.insetBy(dx: sceneSpacing, dy: sceneSpacing)
                $0.layer.borderColor = UIColor.black.cgColor
                $0.layer.borderWidth = 1
                $0.tag = idx
                $0.image = sceneModel.cut(indexOf: idx)?.image
                $0.addTap(action: {self.cutSelected(sender: $0)})
                sceneView.addSubview($0)
            }
            idx += 1
        }
        sceneView.backgroundColor = .white
        //make scene image
        let image = UIImage(view: sceneView)
        sceneModel.image = image
    }
    
    public static func make(with model: WebToon) -> SceneEditorViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "SceneEditorViewController") as! SceneEditorViewController
        vc.webToonModel = model
        vc.title = model.title
        vc.go(scene: 0)
        return vc
    }
    
    private func configureUI() {
        closeBarButtonItem.image = navigationController!.viewControllers.count > 1 ? #imageLiteral(resourceName: "etc_arrow_left") : #imageLiteral(resourceName: "etc_close") //pop or dismiss
        newBarButtonItem.title = nil
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HUD.show(.systemActivity)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //start draw after view did appear
        isViewDidAppearCalled = true
        drawScene()
        HUD.hide()
    }
}

extension SceneEditorViewController: TMPopoverDelegate {
    func popover(_ controller: BasePopoverViewController, didSelectIndex index: Int) {
        if controller.tag == 111 {
            //from new scene button
            var newSceneIndex: Int = 0
            if currentScene > 0 {
                if index == 0 {
                    //insert to front
                    newSceneIndex = currentScene
                } else {
                    //insert to back
                    newSceneIndex = currentScene + 1
                }
            } else {
                //insert to back
                newSceneIndex = currentScene + 1
            }
            webToonModel.insertNewScene(at: newSceneIndex)
            go(scene: newSceneIndex)
            controller.dismiss(animated: true, completion: nil)
            isDataChanged = true
        } else if controller.tag == 222 {
            //from more button
            if index == 0 {
                //save data
                controller.dismiss(animated: true) {
                    guard self.isDataChanged else { Toast(text: "변경 사항이 없습니다.").show(); return }
                    
                    if WebToonStore.shared.save(webToon: self.webToonModel) {
                        Toast(text: "저장 되었습니다.").show()
                        self.isDataChanged = false
                    } else {
                        Toast(text: "저장에 실패했습니다.").show()
                    }
                }
            } else if index == 1 {
                //remove scene
                controller.dismiss(animated: true) {
                    guard self.currentScene > 0 else {
                        Toast(text: "표지는 삭제할 수 없습니다.").show()
                        return
                    }
                    let alert = UIAlertController(title: "삭제", message: "삭제 실행 이후 다시 되돌릴 수 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                        self.webToonModel.removeScene(at: self.currentScene)
                        self.go(scene: self.currentScene - 1)
                        self.isDataChanged = true
                    }))
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func popover(_ controller: BasePopoverViewController, didSelectLayout layout: SceneLayout) {
        sceneModel.set(layout: layout)
        drawScene()
        isDataChanged = true
    }
}
