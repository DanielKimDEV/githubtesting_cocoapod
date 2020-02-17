//
//  PushTVDetails.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

public protocol TVDetailsFromCellTransitionable: class {
    
    func preparePushTransition(to viewController: TVDetailsViewController, with tv: TV, fromCell cell: TVCollectionViewCell, via segue: PushTVDetailsSegue)
}

extension TVDetailsFromCellTransitionable where Self: UIViewController {
    
    public func preparePushTransition(to viewController: TVDetailsViewController, with tv: TV, fromCell cell: TVCollectionViewCell, via segue: PushTVDetailsSegue) {
        
        // Create the view model
        let filmDetailViewModel = TVDetailsViewModel(withFilmId: tv.id)
        viewController.viewModel = filmDetailViewModel
        
        // Prepopulate with the selected film
        if let reactiveDisposable = self as? ReactiveDisposable {
            viewController.rx.viewDidLoad.subscribe(onNext: { _ in
                viewController.prePopulate(forTV: tv)
            }).addDisposableTo(reactiveDisposable.disposeBag)
        }
        
        // Setup the segue for transition
        segue.startingFrame = cell.convert(cell.bounds, to: self.view)
        segue.posterImage = cell.filmPosterImageView.image
    }
}

// MARK: -

public final class PushTVDetailsSegue: UIStoryboardSegue {
    
    // MARK: - Properties
    
    var startingFrame: CGRect = CGRect.zero
    var posterImage: UIImage?
    
    public static var identifier: String { return "PushTVDetailSegueIdentifier" }
    
    // MARK: - UIStoryboardSegue
    
    public override func perform() {
        guard let sourceView = self.source.view else { fatalError() }
        
        
        self.source.navigationController?.pushViewController(self.destination, animated: true)
    }
}
