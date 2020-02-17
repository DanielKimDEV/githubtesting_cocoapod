//
//  PaginatedList.swift
//  WhatFilm
//
//  Created by Jason Kim on 16/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit

public struct PaginatedList<T> {

    // MARK: - Properties
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [T]
    
    // MARK: - Initializer
    
    init(page: Int, totalResults: Int, totalPages: Int, results: [T]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
    
    // MARK: - Helper functions / properties
    
    var count: Int { return self.results.count }
    
    var nextPage: Int? {
        let nextPage = self.page + 1
        guard nextPage < self.totalPages else { return nil }
        return nextPage
    }
    
    static func Empty() -> PaginatedList { return PaginatedList(page: 0, totalResults: 0, totalPages: 0, results: []) }
}

extension PaginatedList {
    
    // MARK: - Subscript
    
    subscript(index: Int) -> T {
        return self.results[index]
    }
}
