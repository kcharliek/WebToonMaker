//
//  MainViewController.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Then

class MainViewController: BaseViewController {
    // MARK: - Action
    @IBAction func goBookShelfBtnClicked(_ sender: Any) {
        let bookShelfVC = BookShelfViewController.make()
        let navigationC = BaseNavigationController(rootViewController: bookShelfVC)
        present(navigationC, animated: true, completion: nil)
    }
    
    @IBAction func newBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "새로 만들기", message: "웹툰의 제목을 입력해주세요.", preferredStyle: .alert).then {
            var tf: UITextField!
            $0.addTextField { (textField) in
                textField.placeholder = "여기에 입력해주세요."
                tf = textField
            }
            
            $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            $0.addAction(UIAlertAction(title: "만들기", style: .default, handler: { (_) in
                let model = WebToon(title: tf.text!)
                if WebToonStore.shared.save(webToon: model) {
                    let sceneEditorVC = SceneEditorViewController.make(with: model)
                    let navigationC = BaseNavigationController(rootViewController: sceneEditorVC)
                    self.present(navigationC, animated: true, completion: nil)
                }
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Method
    private func configureUI() {
        
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
