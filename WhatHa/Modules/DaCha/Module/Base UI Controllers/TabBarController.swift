//
//  TabBarViewController.swift
//  WhatFilm
//
//  Created by Jason Kim on 12/12/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit

public final class TabBarController: UITabBarController {

    // MARK: - UIViewController life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
   
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
//        if let aboutItem = self.tabBar.items?[2] {
//            aboutItem.selectedImage = #imageLiteral(resourceName: "About_Icon").withRenderingMode(.alwaysTemplate)
//            aboutItem.image = #imageLiteral(resourceName: "About_Icon").withRenderingMode(.alwaysTemplate)
//        }
//        let viewTabBar = tabBarItem.value(forKey: "view") as? UIView
//        for(_,v1) in (viewTabBar?.subviews.enumerated())! {
//            if let label = v1.subviews.enumerated() as? UILabel {
//                label.lineBreakMode = NSLineBreakMode.byClipping
//
//            }
//        }
//        var view = self.tabBarItem.value(forKey: "view") as? UIView
//        if let label = view?.subviews[1] as? UILabel {
//            label.lineBreakMode = NSLineBreakMode.byClipping
//        }
        
        
//        if let one = self.tabBar.items?[0] {
//           one.tit
//        }
        
        
    }
}
