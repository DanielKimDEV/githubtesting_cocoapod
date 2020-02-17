//
//  DateManager.swift
//  WhatFilm
//
//  Created by Jason Kim on 13/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit

public final class DateManager: NSObject {
    
    // MARK: - Properties
    
    static var SharedFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    // MARK: - Initializer

    fileprivate override init() { super.init() } 
}
