//
//  AppInstallCheck.swift
//  WhatHa
//
//  Created by kim jason on 10/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import UIKit

class AppInstallCheck {
    
    class func isBitBerry() -> Bool {
        return UIApplication.init().canOpenURL(URL.init(string: "bitberry://")!)
    }
}
