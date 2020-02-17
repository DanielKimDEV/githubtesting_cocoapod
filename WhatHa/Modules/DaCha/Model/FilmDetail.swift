//
//  FilmDetail.swift
//  WhatFilm
//
//  Created by Jason Kim on 28/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import SwiftyJSON

public final class FilmDetail: Film {
    
    // MARK: - Properties
    
    let homepage: URL?
    let imdbId: Int?
    let filmOverview: String?
    let runtime: Int?
    let videos: [Video]
    
    // MARK: - JSONInitializable initializer
    
    public required init(json: JSON) {
        self.homepage = json["homepage"].url
        self.imdbId = json["imdb_id"].int
        self.filmOverview = json["overview"].string
        self.runtime = json["runtime"].int
        self.videos = json["videos"]["results"].arrayValue.compactMap({ Video(json: $0) })
        super.init(json: json)
    }
}
