//
//  FilmCredit.swift
//  WhatFilm
//
//  Created by Jason Kim on 10/10/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import SwiftyJSON

public typealias FilmsCredited = (asCast: [FilmCredited], asCrew: [FilmCredited])

public final class FilmCredited: Film {

    // MARK: - Properties
    
    let category: PersonCategory?
    
    // MARK: - Initializer
    
    public required init(json: JSON) {
        self.category = PersonCategory(json: json)
        super.init(json: json)
    }
}
