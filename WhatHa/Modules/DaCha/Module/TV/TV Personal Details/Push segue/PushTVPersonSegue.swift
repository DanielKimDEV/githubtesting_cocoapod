//
//  PushTVPersonSegue.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
//
//  PushPersonDetailsSegue.swift
//  WhatFilm
//
//  Created by Jason Kim on 08/12/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import RxSwift

// MARK: -

public protocol TVPersonFromCellTransitionable: class {
    
    func preparePushTransition(to viewController: TVPersonViewController, with person: Person, fromCell cell: PersonCollectionViewCell, andBackgroundImagePath path: Observable<ImagePath?>, via segue: PushTVPersonSegue)
}

extension TVPersonFromCellTransitionable where Self: UIViewController {
    
    public func preparePushTransition(to viewController: TVPersonViewController, with person: Person, fromCell cell: PersonCollectionViewCell, andBackgroundImagePath path: Observable<ImagePath?> = Observable.empty(), via segue: PushTVPersonSegue) {
        
        // Create the view model
        let personViewModel = TVPersonViewModel(withPersonId: person.id)
        viewController.viewModel = personViewModel
        
        // Prepopulate with the selected person
        if let reactiveDisposable = self as? ReactiveDisposable {
            viewController.rx.viewDidLoad.subscribe(onNext: { _ in
                viewController.prePopulate(forPerson: person)
            }).addDisposableTo(reactiveDisposable.disposeBag)
        }
        
        viewController.backgroundImagePath = path
        
        // Setup the segue for transition
        segue.startingFrame = cell.convert(cell.bounds, to: self.view)
        segue.profileImage = cell.profileImageView.image
    }
}

// MARK: -

public final class PushTVPersonSegue: UIStoryboardSegue {
    
    // MARK: - Properties
    
    var startingFrame: CGRect = CGRect.zero
    var profileImage: UIImage?
    
    public static var identifier: String { return "PushTVPersonSegueIdentifier" }
    
    // MARK: - UIStoryboardSegue
    
    public override func perform() {
        
        // TODO: - Implement custom segue transition
        
    }
}
