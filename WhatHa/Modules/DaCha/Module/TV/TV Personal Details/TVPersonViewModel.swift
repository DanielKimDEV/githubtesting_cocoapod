//
//  TVPersonViewModel.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TVPersonViewModel: NSObject {
    
    // MARK: - Properties
    
    let personDetail: Observable<PersonDetail>
    let tvCredits: Observable<TVsCredited>
    
    // MARK: - Initializer
    
    init(withPersonId id: Int) {
        
        self.personDetail = Observable
            .just(())
            .flatMapLatest { _ in
                return TMDbAPI.instance.person(forId: id)
            }.shareReplay(1)
        
        self.tvCredits = Observable
            .just(())
            .flatMapLatest { _ in
                return TMDbAPI.instance.tvsCredited(forPersonId: id)
            }.shareReplay(1)
        
        super.init()
    }
}
