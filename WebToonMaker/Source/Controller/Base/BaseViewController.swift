//
//  BaseViewController.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Toaster

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Toast(text: "메모리가 부족합니다. 실행중인 다른 앱을 종료해주세요.").show()
    }
}
