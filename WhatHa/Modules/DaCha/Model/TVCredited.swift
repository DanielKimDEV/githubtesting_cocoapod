//
//  TVCredited.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public typealias TVsCredited = (asCast: [TVCredited], asCrew: [TVCredited])

public final class TVCredited: TV {
    
    // MARK: - Properties
    
    let category: PersonCategory?
    
    // MARK: - Initializer
    
    public required init(json: JSON) {
        self.category = PersonCategory(json: json)
        super.init(json: json)
    }
}
