//
//  TVTVSearchViewModel.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

public final class TVSearchViewModel: NSObject {
    
    // MARK: - Properties
    
    let disposaBag: DisposeBag = DisposeBag()
    
    // Input
    let textSearchTrigger: PublishSubject<String> = PublishSubject()
    let nextPageTrigger: PublishSubject<Void> = PublishSubject()
    
    // Output
    lazy private(set) var tv: Observable<[TV]> = self.setuptvs()
    lazy private(set) var isLoading: PublishSubject<Bool> = PublishSubject()
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        self.setupIsLoading()
    }
    
    // MARK: - Reactive Setup
    
    fileprivate func setupIsLoading() {
        self.tv
            .subscribe(onNext: { [weak self] (tv) in
                self?.isLoading.on(.next(false))
                }, onError: { [weak self] (error) in
                    self?.isLoading.on(.next(false))
                }, onCompleted: { [weak self] in
                    self?.isLoading.on(.next(false))
                }, onDisposed: { [weak self] in
                    self?.isLoading.on(.next(false))
            }).addDisposableTo(self.disposaBag)
    }
    
    fileprivate func setuptvs() -> Observable<[TV]> {
        
        let trigger = self.nextPageTrigger.asObservable().debounce(0.2, scheduler: MainScheduler.instance)
        
        return self.textSearchTrigger
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] (query) -> Observable<[TV]> in
                self?.isLoading.on(.next(true))
                return TMDbAPI.instance.tvs(withTitle: query, loadNextPageTrigger: trigger)
            }
            .shareReplay(1)
    }
}
