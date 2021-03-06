//
//  Person.swift
//  WhatFilm
//
//  Created by Jason Kim on 06/10/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import SwiftyJSON

public typealias FilmCredits = (cast: [Person], crew: [Person])
public typealias TVCredits = (cast: [Person], crew: [Person])
// MARK: -

public enum PersonCategory {
    
    case cast(character: String)
    case crew(job: String)
}

// MARK: -

extension PersonCategory: JSONFailableInitializable {
    
    // MARK: - JSONFailableInitializable
    
    init?(json: JSON) {
        if let character = json["character"].string {
            self = .cast(character: character)
        } else if let job = json["job"].string {
            self = .crew(job: job)
        } else { return nil }
    }
}

// MARK: -

public final class Person: NSObject, JSONFailableInitializable {

    // MARK: - Properties
    
    let id: Int
    let name: String
    let category: PersonCategory
    let profilePathString: String?
    
    // MARK: - Computed properties
    
    var profilePath: ImagePath? {
        guard let profilePathString = self.profilePathString else { return nil }
        return ImagePath.profile(path: profilePathString)
    }
    
    var initials: String {
        let components: [String] = self.name.components(separatedBy: " ")
        let size = min(components.count, 3)
        return components[0..<size].reduce("") { (aggregate, subname) -> String in
            guard subname.characters.count > 0 else { return "" }
            return aggregate + String(subname.characters.prefix(1))
        }
    }
    
    var role: String {
        switch self.category {
        case .cast(let character): return character
        case .crew(let job): return job
        }
    }
    
    // MARK: - Initializer (JSONFailableInitializable)
    
    init?(json: JSON) {
        guard let category = PersonCategory(json: json) else { return nil }
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.category = category
        self.profilePathString = json["profile_path"].string
    }
}
