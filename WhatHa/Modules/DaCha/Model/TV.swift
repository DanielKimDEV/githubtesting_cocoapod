//
//  TV.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation


import UIKit
import SwiftyJSON

public class TV: NSObject, JSONInitializable {
    
    // MARK: - Properties
    
    let id: Int
    let posterPathString: String?
    let adult: Bool
    let overview: String
    let releaseDate: Date
    let genreIds: [Int]
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPathString: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    // MARK: - Computed properties
    
    var fullTitle: String {
        let date = self.releaseDate as NSDate
        return self.title + " (\(date.year()))"
    }
    
    var posterPath: ImagePath? {
        guard let posterPathString = self.posterPathString else { return nil }
        return ImagePath.poster(path: posterPathString)
    }
    
    var backdropPath: ImagePath? {
        guard let backdropPathString = self.backdropPathString else { return nil }
        return ImagePath.backdrop(path: backdropPathString)
    }
    
    // MARK: - JSONInitializable initializer
    
    public required init(json: JSON) {
        log?.debug("tv data is Get!!! \(json.stringValue)")
        self.id = json["id"].intValue
        self.posterPathString = json["poster_path"].string
        self.adult = json["adult"].boolValue ?? false
        self.overview = json["overview"].stringValue
        self.releaseDate = json["first_air_date"].dateValue
        self.genreIds = json["genres"].arrayValue.compactMap({ $0["id"].intValue })
        self.originalTitle = json["original_name"].stringValue
        self.originalLanguage = json["original_language"].stringValue
        self.title = json["name"].stringValue
        self.backdropPathString = json["poster_path"].string
        self.popularity = json["popularity"].doubleValue
        self.voteCount = json["popularity"].intValue
        self.video = json["video"].boolValue
        self.voteAverage = json["vote_average"].doubleValue
        super.init()
    }
}

// MARK: -

extension TV {
    
    // MARK: - Description
    
    public override var description: String {
        let dateString: String = DateManager.SharedFormatter.string(from: self.releaseDate)
        return "\(self.originalTitle) (\(dateString))"
    }
    
    public override var debugDescription: String { return self.description }
}

// MARK: -

extension Array where Element: TV {
    
    var withoutDuplicates: [TV] {
        var exists: [Int: Bool] = [:]
        return self.filter { exists.updateValue(true, forKey: $0.id) == nil }
    }
}
