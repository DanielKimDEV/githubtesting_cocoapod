//
//  PushFilmDetailsSegue.swift
//  WhatFilm
//
//  Created by Jason Kim on 01/12/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit

// MARK: -

public protocol FilmDetailsFromCellTransitionable: class {
    
    func preparePushTransition(to viewController: FilmDetailsViewController, with film: Film, fromCell cell: FilmCollectionViewCell, via segue: PushFilmDetailsSegue)
}

extension FilmDetailsFromCellTransitionable where Self: UIViewController {
    
    public func preparePushTransition(to viewController: FilmDetailsViewController, with film: Film, fromCell cell: FilmCollectionViewCell, via segue: PushFilmDetailsSegue) {
        
        // Create the view model
        let filmDetailViewModel = FilmDetailsViewModel(withFilmId: film.id)
        viewController.viewModel = filmDetailViewModel
        
        // Prepopulate with the selected film
        if let reactiveDisposable = self as? ReactiveDisposable {
            viewController.rx.viewDidLoad.subscribe(onNext: { _ in
                viewController.prePopulate(forFilm: film)
            }).addDisposableTo(reactiveDisposable.disposeBag)
        }
        
        // Setup the segue for transition
        segue.startingFrame = cell.convert(cell.bounds, to: self.view)
        segue.posterImage = cell.filmPosterImageView.image
    }
    
    public func preparePushTransition2(to viewController: FilmDetailsViewController, with film: Film, fromCell cell: FilmCollectionViewCell2, via segue: PushFilmDetailsSegue) {
        
        // Create the view model
        let filmDetailViewModel = FilmDetailsViewModel(withFilmId: film.id)
        viewController.viewModel = filmDetailViewModel
        
        // Prepopulate with the selected film
        if let reactiveDisposable = self as? ReactiveDisposable {
            viewController.rx.viewDidLoad.subscribe(onNext: { _ in
                viewController.prePopulate(forFilm: film)
            }).addDisposableTo(reactiveDisposable.disposeBag)
        }
        
        // Setup the segue for transition
        segue.startingFrame = cell.convert(cell.bounds, to: self.view)
        segue.posterImage = cell.filmPosterImageView.image
    }
    
}

// MARK: -

public final class PushFilmDetailsSegue: UIStoryboardSegue {
    
    // MARK: - Properties

    var startingFrame: CGRect = CGRect.zero
    var posterImage: UIImage?
    
    public static var identifier: String { return "PushFilmDetailSegueIdentifier" }
    
    // MARK: - UIStoryboardSegue
    
    public override func perform() {
        guard let sourceView = self.source.view else { fatalError() }
        
        self.source.navigationController?.pushViewController(self.destination, animated: true)

    }
}
