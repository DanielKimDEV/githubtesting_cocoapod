//
//  CommonView+Extension.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import UIKit
import Material
import RxSwift

extension ObserverType where E == Void {
    public func onNext() {
        onNext(())
    }
}


extension UIWindow {
    
    func switchRootViewController(_ viewController: UIViewController, animated: Bool = true, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = BaseNavigationController(rootViewController: viewController)
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = BaseNavigationController(rootViewController: viewController)
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = UIColor(hexString: "#195D2E")!,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 1,
        blur: CGFloat = 1,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}


func getRaisedButton(title:String, color:UIColor) -> RaisedButton {
    let button:RaisedButton!
    
    button = RaisedButton(title: title, titleColor: color)
    button.pulseColor = WhiteColor
    button.backgroundColor = RedColor
    button.isUserInteractionEnabled = true
    button.layer.zPosition = 1
    button.layer.shadowOpacity = 0.0
    button.layer.shadowColor = UIColor.clear.cgColor
    button.titleLabel?.font = setFontDefault(size: 15)
    return button
}


func setFontDefault(size:Double) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size))
}

func setLabel(title: String = "", size: CGFloat = 12, textColor: UIColor = RealBlackColor, textAlign: NSTextAlignment = .center, numberOfLines: Int = 1, isBold: Bool = false, isLight: Bool = false,
              bgColor: UIColor? = .clear)
    -> UILabel {

        var isKorean = false
    
        
        let label = UILabel()
        label.text = title
        
        if (isBold) {
                label.font = UIFont.boldSystemFont(ofSize: size)
            
        } else {
                label.font = UIFont.systemFont(ofSize: size)
            }
        
        if (isLight) {
                label.font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
            }

        
        label.textColor = textColor
        label.backgroundColor = bgColor
        label.textAlignment = textAlign
        label.numberOfLines = numberOfLines
        return label
}
