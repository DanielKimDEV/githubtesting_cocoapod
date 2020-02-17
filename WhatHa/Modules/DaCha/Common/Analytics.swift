//
//  Analytics.swift
//  WhatFilm
//
//  Created by Jason Kim on 14/12/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import Foundation
import Crashlytics

public struct Analytics {
    
    // MARK: - 
    
    static public func track(viewContent content: String, ofType type: String? = nil, withId id: String? = nil, withAttributes attributes: [String: Any]? = nil) {
//        Answers.logContentView(withName: content, contentType: type, contentId: id, customAttributes: attributes)
    }
    
    static public func track(searchQuery query: String, withAttributes attributes: [String: Any]? = nil) {
//        Answers.logSearch(withQuery: query, customAttributes: attributes)
    }
}
