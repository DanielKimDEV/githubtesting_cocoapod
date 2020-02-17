//
//  AppChecker.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import UIKit

class AppChecker {
    
    class func checkBitBerry() -> Bool {
        if let url = URL(string: "bitberry://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
