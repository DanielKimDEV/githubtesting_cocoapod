//
//  TVDetail.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import SwiftyJSON

public final class TVDetail: TV {
    
    // MARK: - Properties
    
    let homepage: URL?
    let imdbId: Int?
    let filmOverview: String?
    let runtime: Int?
    let videos: [Video]
    
    // MARK: - JSONInitializable initializer
    
    public required init(json: JSON) {
        self.homepage = json["homepage"].url
        self.imdbId = json["id"].int
        self.filmOverview = json["overview"].string
        self.runtime = json["episode_run_time"].int
        self.videos = json["videos"]["results"].arrayValue.compactMap({ Video(json: $0) })
        super.init(json: json)
    }
}
