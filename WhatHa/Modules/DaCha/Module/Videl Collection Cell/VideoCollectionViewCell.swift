//
//  VideoCollectionViewCell.swift
//  WhatFilm
//
//  Created by Jason Kim on 07/10/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    static let imageRatio: CGFloat = 480 / 360
    
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = UIColor(commonColor: .offBlack).withAlphaComponent(0.2)
        self.videoThumbnailImageView.contentMode = .scaleAspectFill
    }
}

extension VideoCollectionViewCell: NibLoadableView { }

extension VideoCollectionViewCell: ReusableView { }
