//
//  ViewerViewController.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 9..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

class ViewerViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    private var model: WebToon!
    
    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Method
    func set(model: WebToon) {
        self.model = model
        self.title = model.title
    }
    
    static func make() -> ViewerViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "ViewerViewController") as! ViewerViewController
        return vc
    }
    
    func configureUI() {
        tableView.register(UINib(nibName: ViewerTableViewCell.className, bundle: nil), forCellReuseIdentifier: ViewerTableViewCell.className)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
extension ViewerViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.scenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewerTableViewCell.className, for: indexPath) as! ViewerTableViewCell
        cell.set(model: model.scenes[indexPath.row])
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 1.5
    }
}
