////
////  Modal.swift
////  Bitberry
////
////  Created by Daniel Kim on 2018. 6. 26..
////  Copyright © 2018년 rootone. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Toast_Swift
//
////Todo - 요거 반복되는 것들 모듈화 해서 빼내야함.
//// 우선 디자인 잡히기 전에는 가져다 쓰다가 (AlertSelector)
//// 등등과 함께 리펙토링 예정.
//protocol Modal {
//    func show(animated: Bool)
//    func dismiss(animated: Bool)
//    var backgroundView: UIView { get }
//    var dialogView: UIView { get set }
//    var dismissAfterStatusBarColor: UIColor { get set }
//}
//
//extension Modal where Self: UIView {
//    func show(animated: Bool) {
//
//        self.backgroundView.alpha = 0
//        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            topController.view.addSubview(self)
//        }
//        if animated {
//
//            UIView.animate(withDuration: 0.33, animations: {
//                self.backgroundView.alpha = 0.35
//
//                let pvc = self.parentViewController
//                pvc?.setNeedsStatusBarAppearanceUpdate()
//                pvc?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//            })
//            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: UIView.AnimationOptions(rawValue: 0), animations: {
//                self.dialogView.center = CGPoint(x: 0, y: -self.backgroundView.height / 2)
//            }, completion: { (completed) in
//
//            })
//        } else {
//
//            self.backgroundView.alpha = 0.35
//            self.dialogView.center = self.center
//        }
//    }
//
//    func dismiss(animated: Bool) {
//        //바 변경은  VC의 ViewDidAppear에서 해도록 하자
//
//        let pvc = self.parentViewController
//        pvc?.setNeedsStatusBarAppearanceUpdate()
//        pvc?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        if animated {
//            UIView.animate(withDuration: 0.33, animations: {
//                self.backgroundView.alpha = 0
//            }, completion: { (completed) in
//
//            })
//            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: UIView.AnimationOptions(rawValue: 0), animations: {
//                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
//            }, completion: { (completed) in
//                self.removeFromSuperview()
//            })
//        } else {
//            self.removeFromSuperview()
//        }
//    }
//}
