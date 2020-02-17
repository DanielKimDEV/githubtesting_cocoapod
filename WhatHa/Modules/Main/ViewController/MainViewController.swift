//
//  MainViewController.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

class MainViewController: UIViewController,ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var demos: [DemoItem] = [
        DemoItem(name: "비트베리 연결",
                 controllerClass: ConnectViewController.self),
        DemoItem(name: "비트베리 결제",
                 controllerClass: TransactionViewController.self),
        DemoItem(name: "계정 설정 및 확인",
                 controllerClass: DisConnectAccountViewController.self),

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationController()
        collectionView.backgroundColor = WhiteColor
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        collectionView.snp.makeConstraints{ m in
            m.top.equalToSuperview().offset(xTopOffset)
            m.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
    }
    
}

extension MainViewController {
    // MARK: ListAdapterDataSource
    
    fileprivate func initNavigationController() {
        self.view.backgroundColor = WhiteColor
        navigationController?.navigationBar.backgroundColor = RealBlackColor
        self.navigationController?.navigationBar.tintColor = WhiteColor
        navigationItem.titleLabel.textColor = WhiteColor
        navigationItem.titleLabel.text = "BitBerry Connect Demos"
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {

        return self.demos
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return DemoSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}
