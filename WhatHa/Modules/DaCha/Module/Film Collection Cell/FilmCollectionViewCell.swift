//
//  FilmCollectionViewCell.swift
//  WhatFilm
//
//  Created by Jason Kim on 21/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit

public final class FilmCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmPosterImageView: UIImageView!
    @IBOutlet weak var filmRaitingLabel: UILabel!
    
    // MARK: - UICollectionViewCell life cycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.filmTitleLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
             self.filmRaitingLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.filmPosterImageView.contentMode = .scaleAspectFit
        self.filmPosterImageView.clipsToBounds = true
    }
    
    // MARK: -
    
    func populate(withPosterPath posterPath: ImagePath?, andTitle title: String, rating:Double = 0.0) {
        self.filmTitleLabel.text = title
        if(rating == 0.0) {
            self.filmRaitingLabel.isHidden = true
        } else {
            self.filmRaitingLabel.isHidden = false
            self.filmRaitingLabel.text = "총점 \(rating)/10"
        }
        self.filmPosterImageView.image = nil
        if let posterPath = posterPath {
            self.filmPosterImageView.setImage(fromTMDbPath: posterPath, withSize: .medium, animatedOnce: true)
        }
    }
}

extension FilmCollectionViewCell: NibLoadableView { }

extension FilmCollectionViewCell: ReusableView { }

public final class FilmCollectionViewCell2: UICollectionViewCell {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmPosterImageView: UIImageView!
    @IBOutlet weak var filmRaitingLabel: UILabel!
    
    // MARK: - UICollectionViewCell life cycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.filmTitleLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        self.filmRaitingLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.filmPosterImageView.contentMode = .scaleAspectFit
        self.filmPosterImageView.clipsToBounds = true
    }
    
    // MARK: -
    
    func populate(withPosterPath posterPath: ImagePath?, andTitle title: String, rating:Double = 0.0) {
        self.filmTitleLabel.text = title
        if(rating == 0.0) {
            self.filmRaitingLabel.isHidden = true
        } else {
            self.filmRaitingLabel.isHidden = false
            self.filmRaitingLabel.text = "총점 \(rating)/10"
        }
        self.filmPosterImageView.image = nil
        if let posterPath = posterPath {
            self.filmPosterImageView.setImage(fromTMDbPath: posterPath, withSize: .medium, animatedOnce: true)
        }
    }
}

extension FilmCollectionViewCell2: NibLoadableView { }

extension FilmCollectionViewCell2: ReusableView { }


public final class TVCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmPosterImageView: UIImageView!
    
    // MARK: - UICollectionViewCell life cycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.filmTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.filmPosterImageView.contentMode = .scaleAspectFit
        self.filmPosterImageView.clipsToBounds = true
    }
    
    // MARK: -
    
    func populate(withPosterPath posterPath: ImagePath?, andTitle title: String) {
        self.filmTitleLabel.text = title
        self.filmPosterImageView.image = nil
        if let posterPath = posterPath {
            self.filmPosterImageView.setImage(fromTMDbPath: posterPath, withSize: .medium, animatedOnce: true)
        }
    }
}

extension TVCollectionViewCell: NibLoadableView { }

extension TVCollectionViewCell: ReusableView { }
