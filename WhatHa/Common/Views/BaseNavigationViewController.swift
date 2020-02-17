//
//  BaseNavigationViewController.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import Material
import Localize_Swift
import Motion

class BaseNavigationController: NavigationController {
    
    var isOverLap:Bool = false
    
    open override func prepare() {
        super.prepare()
        
        if(isOverLap) {
            isMotionEnabled = true
            motionTransitionType = .autoReverse(presenting: .cover(direction: .right))
        }
        
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.heightPreset = .default
        v.dividerColor = UIColor.clear
        //        v.heightPreset = .xxlarge
        v.backgroundColor = WhiteColor
        v.tintColor = RealBlackColor
        v.isTranslucent = true
        v.shadowImage = nil
        v.setBackgroundImage(nil, for: .default)
    }
}

