//
//  PersonViewModel.swift
//  WhatFilm
//
//  Created by Jason Kim on 10/10/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PersonViewModel: NSObject {
    
    // MARK: - Properties
    
    let personDetail: Observable<PersonDetail>
    let filmsCredits: Observable<FilmsCredited>
    
    // MARK: - Initializer
    
    init(withPersonId id: Int) {
        
        self.personDetail = Observable
            .just(())
            .flatMapLatest { _ in
                return TMDbAPI.instance.person(forId: id)
            }.shareReplay(1)
        
        
        self.filmsCredits = Observable
            .just(())
            .flatMapLatest { _ in
                return TMDbAPI.instance.filmsCredited(forPersonId: id)
            }.shareReplay(1)
        
        super.init()
    }
}
