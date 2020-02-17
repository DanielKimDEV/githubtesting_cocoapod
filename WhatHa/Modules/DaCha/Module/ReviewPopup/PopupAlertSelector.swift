////
////  PopupAlert.swift
////  WhatHa
////
////  Created by kim jason on 18/02/2019.
////  Copyright © 2019 rootone - danielKim. All rights reserved.
////
//
//
//import UIKit
//import Material
//import Localize_Swift
//import Kingfisher
//import SnapKit
//import SwiftyJSON
//
//class PopupAlertSelector: UIView, Modal {
//
//    var backgroundView = UIView()
//    var dialogView = UIView()
//    var dismissAfterStatusBarColor = WhiteColor
//
//    var id: String!
//
//    convenience init(id: String) {
//        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        self.id = id
//        initialize()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func initialize() {
//        self.prepareViews()
//        isMotionEnabled = true
//    }
//}
//
//
//extension PopupAlertSelector {
//
//
//    fileprivate func prepareViews() {
//
//        let viewWidth = self.bounds.width - 32
//        let viewHeight = self.bounds.height * 0.6
//
//        dialogView.clipsToBounds = true
//
//        backgroundView.frame = frame
//        backgroundView.backgroundColor = UIColor.black
//        backgroundView.alpha = 0.35
//        backgroundView.layer.masksToBounds = true
//        //        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
//        addSubview(backgroundView)
//
//        dialogView.backgroundColor = WhiteColor
//        dialogView.layer.cornerRadius = 4
//
//        self.addSubview(dialogView)
//        dialogView.snp.makeConstraints{ m in
//            m.height.equalTo(viewHeight)
//            m.width.equalTo(viewWidth)
//            m.centerX.centerY.equalToSuperview()
//        }
//
//    }
//}
//
//extension PopupAlertSelector {
//
//
//}
