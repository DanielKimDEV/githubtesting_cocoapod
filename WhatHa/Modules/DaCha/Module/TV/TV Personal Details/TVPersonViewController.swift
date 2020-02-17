//
//  TVPersonViewController.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public final class TVPersonViewController: UIViewController, ReactiveDisposable {
    
    // MARK: - Properties
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: TVPersonViewModel?
    var backgroundImagePath: Observable<ImagePath?> = Observable.empty()
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var fakeNavigationBar: UIView!
    @IBOutlet weak var fakeNavigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personInitialsLabel: UILabel!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personAgeLabel: UILabel!
    @IBOutlet weak var crewView: UIView!
    @IBOutlet weak var crewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var crewCollectionView: UICollectionView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var castViewHeight: NSLayoutConstraint!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var personBiographyLabel: UILabel!
    
    // MARK: - UIViewController life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCollectionView()
        if let viewModel = self.viewModel { self.setupBindings(forViewModel: viewModel) }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.fakeNavigationBarHeight.constant = self.topLayoutGuide.length
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
        self.fakeNavigationBar.backgroundColor = UIColor(commonColor: .offBlack).withAlphaComponent(0.2)
        self.profileImageContainerView.backgroundColor = UIColor(commonColor: .offBlack).withAlphaComponent(0.2)
        self.profileImageContainerView.layer.cornerRadius = 50.0
        self.profileImageContainerView.layer.masksToBounds = true
        self.profileImageView.contentMode = .scaleAspectFill
        self.personInitialsLabel.apply(style: .bodySmall)
        self.personInitialsLabel.text = nil
        self.personNameLabel.apply(style: .filmDetailTitle)
        self.personNameLabel.text = nil
        self.personAgeLabel.apply(style: .filmRating)
        self.personAgeLabel.text = nil
        self.crewLabel.apply(style: .filmDetailTitle)
        self.castLabel.apply(style: .filmDetailTitle)
        self.personBiographyLabel.apply(style: .bodyDemiBold)
        self.personBiographyLabel.text = nil
    }
    
    fileprivate func setupCollectionView() {
        self.crewCollectionView.registerReusableCell(TVCollectionViewCell.self)
        self.crewCollectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.crewCollectionView.showsHorizontalScrollIndicator = false
        self.castCollectionView.registerReusableCell(TVCollectionViewCell.self)
        self.castCollectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.castCollectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Reactive setup
    
    fileprivate func setupBindings(forViewModel viewModel: TVPersonViewModel) {
        
        viewModel
            .personDetail
            .subscribe(onNext: { [weak self] (personDetail) in
                self?.populate(forPerson: personDetail)
            })
            .addDisposableTo(self.disposeBag)
        
        viewModel
            .tvCredits
            .subscribe(onNext: { [weak self] (credits) in
                let defaultHeight: CGFloat = 15.0 + TextStyle.filmDetailTitle.font.lineHeight + 8.0 + 200.0
                if credits.asCast.count > 0 {
                    self?.castLabel.text = "출연작"
                    self?.castViewHeight.constant = defaultHeight
                } else {
                    self?.castLabel.text = nil
                    self?.castViewHeight.constant = 0.0
                }
                if credits.asCrew.count > 0 {
                    self?.crewLabel.text = "참여작"
                    self?.crewViewHeight.constant = defaultHeight
                } else {
                    self?.crewLabel.text = nil
                    self?.crewViewHeight.constant = 0.0
                }
                self?.scrollView.layoutIfNeeded()
            })
            .addDisposableTo(self.disposeBag)
        
        viewModel
            .tvCredits
            .map({ $0.asCrew.withoutDuplicates })
            .bindTo(self.crewCollectionView.rx.items(cellIdentifier: TVCollectionViewCell.DefaultReuseIdentifier, cellType: TVCollectionViewCell.self)) {
                (row, film, cell) in
                cell.populate(withPosterPath: film.posterPath, andTitle: film.fullTitle)
            }.addDisposableTo(self.disposeBag)
        
        viewModel
            .tvCredits
            .map({ $0.asCast.withoutDuplicates })
            .bindTo(self.castCollectionView.rx.items(cellIdentifier: TVCollectionViewCell.DefaultReuseIdentifier, cellType: TVCollectionViewCell.self)) {
                (row, film, cell) in
                cell.populate(withPosterPath: film.posterPath, andTitle: film.fullTitle)
            }.addDisposableTo(self.disposeBag)
        
        self.backgroundImagePath
            .subscribe(onNext: { [weak self] (imagePath) in
                if let imagePath = imagePath {
                    self?.blurredImageView.setImage(fromTMDbPath: imagePath, withSize: .medium)
                } else {
                    self?.blurredImageView.image = nil
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Data handling
    
    fileprivate func populate(forPerson person: PersonDetail) {
        self.personInitialsLabel.text = person.initials
        self.profileImageView.image = nil
        if let profilePath = person.profilePath {
            self.profileImageView.setImage(fromTMDbPath: profilePath, withSize: .big)
        }
        self.personNameLabel.text = person.name
        self.personAgeLabel.text = self.age(forPerson: person)
        self.personBiographyLabel.text = person.biography
    }
    
    public func prePopulate(forPerson person: Person) {
        if let profilePath = person.profilePath {
            self.personInitialsLabel.text = nil
            self.profileImageView.setImage(fromTMDbPath: profilePath, withSize: .big)
        } else {
            self.personInitialsLabel.text = person.initials
            self.profileImageView.image = nil
        }
        self.personNameLabel.text = person.name
    }
    
    fileprivate func age(forPerson person: PersonDetail) -> String? {
        guard let birthDate = person.birthdate else { return nil }
        guard let birthDateString = (birthDate as NSDate).formattedDate(with: .medium) else { return nil }
        guard let age = person.age else { return nil }
        if let deathDate = person.deathDate {
            return birthDateString + " - " + (deathDate as NSDate).formattedDate(with: .medium) + " (\(age))"
        } else {
            return birthDateString + " (\(age))"
        }
    }
    
    // MARK: - Navigation handling
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tvDetailsViewController = segue.destination as? TVDetailsViewController,
            let PushFilmDetailsSegue = segue as? PushTVDetailsSegue,
            let sender = sender as? CollectionViewSelection,
            let cell = sender.collectionView.cellForItem(at: sender.indexPath) as? TVCollectionViewCell {
            do {
                let tv: TV = try sender.collectionView.rx.model(at: sender.indexPath)
                self.preparePushTransition(to: tvDetailsViewController, with: tv, fromCell: cell, via: PushFilmDetailsSegue)
            } catch { fatalError(error.localizedDescription) }
        }
    }
}

// MARK: -

extension TVPersonViewController: SegueReachable {
    
    // MARK: - SegueReachable
    
    static var segueIdentifier: String { return PushTVPersonSegue.identifier }
}

// MARK: -

extension TVPersonViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate functions
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sender = CollectionViewSelection(collectionView: collectionView, indexPath: indexPath)
        self.performSegue(withIdentifier: TVDetailsViewController.segueIdentifier, sender: sender)
    }
}

// MARK: -

extension TVPersonViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.height * ImageSize.posterRatio
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}

extension TVPersonViewController: TVDetailsFromCellTransitionable {}
