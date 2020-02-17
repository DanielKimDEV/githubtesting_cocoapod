//
//  BaseFilmCollectionViewController.swift
//  WhatFilm
//
//  Created by Jason Kim on 23/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import RevealingSplashView
import SVProgressHUD
import SnapKit
// MARK: -

public class BaseFilmCollectionViewController: UIViewController {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tvCollectionView: UICollectionView!
    // MARK: - UIViewController handling
    var isFirstLoad = false
    var isMainScreen = false
    public override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if(!isFirstLoad) {
           isFirstLoad = true
            log?.debug("check1111")
            self.prepareView()
            self.collectionViewItemsPerRow = self.itemsPerRow(for: UIScreen.main.bounds.size)
        }

        
    }
    
    // MARK: - Rotation handling
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard self.isViewLoaded else { return }
         if(!isFirstLoad) {
            log?.debug("check1111")
            self.collectionViewItemsPerRow = self.itemsPerRow(for: size)
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    fileprivate func itemsPerRow(for size: CGSize) -> Int {
        if size.width > 768 { return 4 }
        else if size.width > 414 { return 3 }
        else {
            if(self.isMainScreen) {
                return 1
            } else {
                return 1
            }
        }
    }
    
    // MARK: - UICollectionViewCell layout properties
    
    fileprivate var collectionViewItemsPerRow: Int = 2
    fileprivate let collectionViewMargin: CGFloat = 20.0
    fileprivate let collectionViewItemSizeRatio: CGFloat = ImageSize.posterRatio
    fileprivate var collectionViewItemWidth: CGFloat {
        return (self.collectionView.bounds.width - (CGFloat(self.collectionViewItemsPerRow + 1) * self.collectionViewMargin)) / CGFloat(self.collectionViewItemsPerRow)
    }
    fileprivate var collectionViewItemHeight: CGFloat {
        return self.collectionViewItemWidth / self.collectionViewItemSizeRatio
    }
}

extension BaseFilmCollectionViewController {
    
    public func prepareView() {
        collectionView.tag = 1
        if(isMainScreen) {
            let height = self.collectionView.bounds.height
            
            collectionView.snp.updateConstraints{ m in
                m.top.equalToSuperview().offset(xTopOffset + 56)
                m.left.equalToSuperview()
                m.right.equalToSuperview()
                m.bottom.equalToSuperview().offset(-(height/2))
            }
            
            tvCollectionView.snp.updateConstraints{ m in
                m.top.equalToSuperview().offset(height/2)
                m.left.equalToSuperview()
                m.right.equalToSuperview()
            }
            
            tvCollectionView.tag = 2
            
            self.collectionView.collectionViewLayout.invalidateLayout()
            
            
            let movieLabel = setLabel(title: "최신작", size: 20, textColor: WhiteColor, textAlign: .center, isBold: true)
            
            let dramaLabel = setLabel(title: "추천작", size: 20, textColor: WhiteColor, textAlign: .center, isBold: true)
            
            self.view.addSubview(movieLabel)
            self.view.addSubview(dramaLabel)
            
            movieLabel.snp.makeConstraints{ m in
                m.top.equalTo(collectionView.snp.top).offset(-4)
                m.left.equalToSuperview().offset(24)
            }
            
            dramaLabel.snp.makeConstraints{ m in
                m.top.equalTo(tvCollectionView.snp.top).offset(-4)
//                m.centerX.equalToSuperview()
                m.left.equalToSuperview().offset(24)
            }
        } else {
            //nothing..
        }
    
        
    }
}


// MARK: -

extension BaseFilmCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewItemWidth/2, height: self.collectionViewItemHeight/2)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.collectionViewMargin, left: self.collectionViewMargin, bottom: self.collectionViewMargin, right: self.collectionViewMargin)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.collectionViewMargin
    }
}

extension BaseFilmCollectionViewController {
    
    public func showProgressBar() {
        SVProgressHUD.show()
    }
    
    public func hideProgressBar() {
        SVProgressHUD.dismiss()
    }
}
