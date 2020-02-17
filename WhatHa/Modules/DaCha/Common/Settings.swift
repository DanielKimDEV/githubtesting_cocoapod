//
//  Settings.swift
//  WhatFilm
//
//  Created by Jason Kim on 28/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

public struct Settings {
    
    // MARK: - Private initializer
    
    private init() {}
    
    // MARK: - Functions
    
    static func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    static func initializeServices() {
        TMDbAPI.instance.start()
    }
    
    static func setupAppearance() {
        
        // Tint colors
        UIApplication.shared.delegate?.window??.tintColor = UIColor(commonColor: .black)
        UIRefreshControl.appearance().tintColor = UIColor(commonColor: .black)
        UITabBar.appearance().barTintColor = UIColor(commonColor: .offBlack)
        
        // Global font
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: TextStyle.navigationTitle.font])
        UILabel.appearance().font = TextStyle.body.font
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): TextStyle.body.font]), for: .normal)
        
        // UINavigation bar
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
