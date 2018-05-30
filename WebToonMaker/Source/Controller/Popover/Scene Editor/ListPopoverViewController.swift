//
//  PopoverListViewController.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit
import Then
import SnapKit

class ListPopoverViewController: BasePopoverViewController {
    // MARK: - Constant
    public var rowHeight: CGFloat = 44
    
    // MARK: - Variable
    private var tableView: UITableView!
    private var source: [String]?
    
    // MARK: - Method
    private func configureUI() {
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain).then {
            view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            $0.bounces = false
            $0.delegate = self
            $0.dataSource = self
            $0.register(ListPopoverTableViewCell.self, forCellReuseIdentifier: ListPopoverTableViewCell.className)
            $0.reloadData()
        }
    }
    
    public static func make(source: [String]) -> ListPopoverViewController {
        let vc = ListPopoverViewController()
        vc.source = source
        return vc
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension ListPopoverViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let source = source {
            return source.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPopoverTableViewCell.className, for: indexPath) as! ListPopoverTableViewCell
        cell.title = source![indexPath.row]
        return cell
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.popover!(self, didSelectIndex: indexPath.row)
    }
}
