//
//  KeyboardObserver.swift
//  WhatFilm
//
//  Created by Jason Kim on 16/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

// Credit to muukii ()
// https://gist.github.com/muukii/a914b5bc2175f389a4348316fdf8acc9#file-keyboardobserver-swift

import Foundation
import RxSwift
import RxCocoa

// MARK:

public struct KeyboardInfo {
    
    // MARK: - Properties
    
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    public let animationDuration: Double
    
    // MARK: - Initializer
    
    init(notification: Notification) {
        self.frameEnd = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        self.frameBegin = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue
        self.animationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
    }
}

// MARK:

public final class KeyboardObserver {
    
    // MARK: - Properties
    
    public let willChangeFrame = PublishSubject<KeyboardInfo>()
    public let didChangeFrame = PublishSubject<KeyboardInfo>()
    public let willShow = PublishSubject<KeyboardInfo>()
    public let didShow = PublishSubject<KeyboardInfo>()
    public let willHide = PublishSubject<KeyboardInfo>()
    public let didHide = PublishSubject<KeyboardInfo>()
    
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    public init() {
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .map { KeyboardInfo(notification: $0) }
            .bindTo(self.willChangeFrame)
            .addDisposableTo(self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardDidChangeFrameNotification)
            .map { KeyboardInfo(notification: $0) }
            .bindTo(self.didChangeFrame)
            .addDisposableTo(self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { KeyboardInfo(notification: $0) }
            .bindTo(self.willShow)
            .addDisposableTo(self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification)
            .map { KeyboardInfo(notification: $0) }
            .bindTo(self.didShow)
            .addDisposableTo(self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { KeyboardInfo(notification: $0) }
            .bindTo(self.willHide)
            .addDisposableTo(self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification)
            .map { KeyboardInfo(notification: $0) }
            .bindTo(self.didHide)
            .addDisposableTo(self.disposeBag)
    }
}
