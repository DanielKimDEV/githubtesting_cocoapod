//
//  TVDetailsViewModel.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation

import UIKit
import RxCocoa
import RxSwift

public final class TVDetailsViewModel: NSObject {
    
    // MARK: - Properties
    
    let tvID: Int
    let tvDetail: Observable<TVDetail>
    let credits: Observable<TVCredits>
    
    // MARK: - Initializer
    
    init(withFilmId id: Int) {
        log?.debug("wow, id is.. \(id)")
        self.tvID = id
        
        self.tvDetail = Observable
            .just(())
            .flatMapLatest { (_) -> Observable<TVDetail> in
                return TMDbAPI.instance.tvDetail(fromId: id)
            }.shareReplay(1)
        
        
        self.credits = Observable
            .just(())
            .flatMapLatest { (_) -> Observable<TVCredits> in
                return TMDbAPI.instance.TVcredits(forTVId: id)
            }.shareReplay(1)
        
        super.init()
    }
}
