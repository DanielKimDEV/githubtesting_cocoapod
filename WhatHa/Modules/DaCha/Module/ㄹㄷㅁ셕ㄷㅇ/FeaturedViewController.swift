//
//  FeaturedViewController.swift
//  WhatFilm
//
//  Created by Jason Kim on 23/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RevealingSplashView
import SVProgressHUD
import Material

final class FeaturedViewController: BaseFilmCollectionViewController, ReactiveDisposable {
    // MARK: - IBOutlet Properties
    
    fileprivate let refreshControl: UIRefreshControl = UIRefreshControl()
    fileprivate let tvRefreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Properties
    
    fileprivate let keyboardObserver: KeyboardObserver = KeyboardObserver()
    fileprivate let featuredViewModel: FeaturedViewModel = FeaturedViewModel()
    fileprivate let upcommingViewModel: UpCommingViewModel = UpCommingViewModel()
    
    let disposeBag: DisposeBag = DisposeBag()
    let upCommingDisposeBag: DisposeBag = DisposeBag()
    
    // MARK: - UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let v = self.navigationController?.navigationBar as? NavigationBar  {
            log?.debug("wow material navigation!!")
            v.depthPreset = .none
            v.heightPreset = .none
            v.dividerColor = UIColor.clear
            //        v.heightPreset = .xxlarge
            //        v.backgroundColor = WhiteColor
            //        v.tintColor = RealBlackColor
            v.isTranslucent = true
            v.shadowImage = nil
            v.setBackgroundImage(nil, for: .default)
        }
        self.isMainScreen = true
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "splashImg")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: WhiteColor)
        revealingSplashView.heartAttack = true
        revealingSplashView.duration = 4.0
        revealingSplashView.delay = 0.3
        //Adds the revealing splash view as a sub view
        let window = UIApplication.shared.keyWindow
        window?.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            log?.debug("compelete splash view")
            let phoneNumber = UserDefaults.UserData.string(forKey: .PhoneNumber)
            if(phoneNumber.count > 3) {
                //nothing..
            } else {
                let vc = LoginViewController()
                let bvc = FullScreenNavigationController(rootViewController: vc)
                self.present(bvc, animated: true)
            }
        }
        
        self.setupUI()
        self.setupCollectionView()
        self.setupBindings()
        self.featuredViewModel.reloadTrigger.onNext(())
        self.upcommingViewModel.reloadTrigger.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Reactive bindings setup
    
    fileprivate func setupBindings() {
        
        // MARK : - Films
        
        // Bind refresh control to data reload
        self.refreshControl.rx
            .controlEvent(.valueChanged)
            .filter({ self.refreshControl.isRefreshing })
            .bindTo(self.featuredViewModel.reloadTrigger)
            .addDisposableTo(self.disposeBag)
        
        // Bind view model films to the table view
        self.featuredViewModel
            .films
            .bindTo(self.collectionView.rx.items(cellIdentifier: FilmCollectionViewCell.DefaultReuseIdentifier, cellType: FilmCollectionViewCell.self)) {
                (row, film, cell) in
                cell.populate(withPosterPath: film.posterPath, andTitle: film.fullTitle, rating: film.voteAverage)
            }.addDisposableTo(self.disposeBag)
        
        // Bind view model films to the refresh control
        self.featuredViewModel.films
            .subscribe { _ in
                self.refreshControl.endRefreshing()
            }.addDisposableTo(self.disposeBag)
        
        // Bind table view bottom reached event to loading the next page
        self.collectionView.rx
            .reachRight
            .bindTo(self.featuredViewModel.nextPageTrigger)
            .addDisposableTo(self.disposeBag)
        
        // MARK : - TVs
        
        // Bind View model tvs to the table view
        self.tvRefreshControl.rx
            .controlEvent(.valueChanged)
            .filter({ self.tvRefreshControl.isRefreshing })
            .bindTo(self.upcommingViewModel.reloadTrigger)
            .addDisposableTo(self.upCommingDisposeBag)
        
        // Bind view model tvs to the table view
        self.upcommingViewModel
            .tvs
            .bindTo(self.tvCollectionView.rx.items(cellIdentifier: FilmCollectionViewCell2.DefaultReuseIdentifier, cellType: FilmCollectionViewCell2.self)) {
                (row, tv, cell) in
                cell.populate(withPosterPath: tv.posterPath, andTitle: tv.fullTitle,  rating: tv.voteAverage)
            }.addDisposableTo(self.upCommingDisposeBag)
        
        // Bind view model tvs to the refresh control
        self.upcommingViewModel.tvs
            .subscribe { _ in
                self.tvRefreshControl.endRefreshing()
            }.addDisposableTo(self.upCommingDisposeBag)
        
        // Bind table view bottom reached event to loading the next page
        self.tvCollectionView.rx
            .reachRight
            .bindTo(self.upcommingViewModel.nextPageTrigger)
            .addDisposableTo(self.upCommingDisposeBag)
        
        // Bind keyboard updates to table view inset
        self.keyboardObserver
            .willShow
            .subscribe(onNext: { [unowned self] (keyboardInfo) in
                self.setupScrollViewViewInset(forBottom: keyboardInfo.frameEnd.height, animationDuration: keyboardInfo.animationDuration)
            }).disposed(by: self.disposeBag)
        self.keyboardObserver
            .willHide
            .subscribe(onNext: { [unowned self] (keyboardInfo) in
                self.setupScrollViewViewInset(forBottom: 0, animationDuration: keyboardInfo.animationDuration)
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() { }
    
    fileprivate func setupCollectionView() {
        self.collectionView.registerReusableCell(FilmCollectionViewCell.self)
        self.collectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.tag = 1
        self.tvCollectionView.registerReusableCell(FilmCollectionViewCell2.self)
        self.tvCollectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.tvCollectionView.addSubview(self.tvRefreshControl)
        self.tvCollectionView.tag = 2
    }
    
    fileprivate func setupScrollViewViewInset(forBottom bottom: CGFloat, animationDuration duration: Double? = nil) {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        if let duration = duration {
            UIView.animate(withDuration: duration, animations: {
                self.collectionView.contentInset = inset
                self.collectionView.scrollIndicatorInsets = inset
            })
        } else {
            self.collectionView.contentInset = inset
            self.collectionView.scrollIndicatorInsets = inset
        }
        
        let inset2 = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        if let duration2 = duration {
            UIView.animate(withDuration: duration2, animations: {
                self.tvCollectionView.contentInset = inset2
                self.tvCollectionView.scrollIndicatorInsets = inset2
            })
        } else {
            self.tvCollectionView.contentInset = inset2
            self.tvCollectionView.scrollIndicatorInsets = inset2
        }
    }
    
    // MARK: - Navigation handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        log?.debug("wowwow prepare")
        if let filmDetailsViewController = segue.destination as? FilmDetailsViewController,
            let PushFilmDetailsSegue = segue as? PushFilmDetailsSegue,
            let data = sender as? SenderData,
            let indexPath = data.indexPath as? IndexPath,
            let tag = data.tag as? Int,
            let cell = self.collectionView.cellForItem(at: indexPath) as? FilmCollectionViewCell {
            if(tag == 1) {
                do {
                    log?.debug("wowwow11111")
                    let film: Film = try collectionView.rx.model(at: indexPath)
                    self.preparePushTransition(to: filmDetailsViewController, with: film, fromCell: cell, via: PushFilmDetailsSegue)
                } catch { fatalError(error.localizedDescription) }
            }
        }
        
        
        if let filmDetailsViewController = segue.destination as? FilmDetailsViewController,
            let PushFilmDetailsSegue = segue as? PushFilmDetailsSegue,
            let data = sender as? SenderData,
            let indexPath = data.indexPath as? IndexPath,
            let tag = data.tag as? Int,
            let cell = self.tvCollectionView.cellForItem(at: indexPath) as? FilmCollectionViewCell2 {
            if(tag == 2) {
                do {
                    log?.debug("wowwow222222")
                    let film: Film = try tvCollectionView.rx.model(at: indexPath)
                    self.preparePushTransition2(to: filmDetailsViewController, with: film, fromCell: cell, via: PushFilmDetailsSegue)
                } catch { fatalError(error.localizedDescription) }
            }
        }
        
        //        if let tvDetailsViewController = segue.destination as? TVDetailsViewController,
        //            let TVFilmDetailsSegue = segue as? PushTVDetailsSegue,
        //            let indexPath = sender as? IndexPath,
        //            let cell = self.tvCollectionView.cellForItem(at: indexPath) as? TVCollectionViewCell {
        //            log?.debug("wowwow1")
        //            do {
        //                let film: TV = try tvCollectionView.rx.model(at: indexPath)
        //                self.preparePushTransition(to: tvDetailsViewController, with: film, fromCell: cell, via: TVFilmDetailsSegue)
        //            } catch { fatalError(error.localizedDescription) }
        //        }
    }
}

// MARK: -

extension FeaturedViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate functions
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(UserDefaults.isSet.bool(forKey: .isPaid)) {
            
            let tag = collectionView.tag
            if(tag == 1) {
                log?.debug("wow1")
                var data = SenderData()
                data.indexPath = indexPath
                data.tag = tag
                self.performSegue(withIdentifier: FilmDetailsViewController.segueIdentifier, sender: data)
            } else {
                log?.debug("wow2")
                var data = SenderData()
                data.indexPath = indexPath
                data.tag = tag
                self.performSegue(withIdentifier: FilmDetailsViewController.segueIdentifier, sender: data)
            }
            
        } else {
            if(UserDefaults.FreePlay.integer(forKey: .RemainFreeUse) > 0) {
                var remainUsed = UserDefaults.FreePlay.integer(forKey: .RemainFreeUse)
      
                    self.showAlertPresentAction(alertMessage:  "무료 사용이 \(remainUsed)번 남았습니다.") {
                        result in
                        let tag = collectionView.tag
                        if(tag == 1) {
                            log?.debug("wow1")
                            var data = SenderData()
                            data.indexPath = indexPath
                            data.tag = tag
                            self.performSegue(withIdentifier: FilmDetailsViewController.segueIdentifier, sender: data)
                        } else {
                            log?.debug("wow2")
                            var data = SenderData()
                            data.indexPath = indexPath
                            data.tag = tag
                            self.performSegue(withIdentifier: FilmDetailsViewController.segueIdentifier, sender: data)
                        }
                        UserDefaults.FreePlay.set(remainUsed - 1, forKey: .RemainFreeUse)
                    }
                
            } else {
//                if(remainUsed == 0) {
                    self.showAlertPresentAction(alertMessage:  "무료 사용이 끝났습니다. 결제 하세요.") {
                        result in
                        if(UserDefaults.UserData.string(forKey: .UserToken).count > 0) {
                            let vc = TransactionViewController()
                            let bvc = BaseNavigationController(rootViewController: vc)
                            self.present(bvc, animated: true)
                        } else {
                            let vc = ConnectViewController()
                            vc.delegate = self
                            let bvc = BaseNavigationController(rootViewController: vc)
                            self.present(bvc, animated: true)
                        }
                    }
//                } else {
                    
//                if(UserDefaults.UserData.string(forKey: .UserToken).count > 0) {
//                    let vc = TransactionViewController()
//                    let bvc = BaseNavigationController(rootViewController: vc)
//                    self.present(bvc, animated: true)
//                } else {
//                    let vc = ConnectViewController()
//                    let bvc = BaseNavigationController(rootViewController: vc)
//                    self.present(bvc, animated: true)
//                }
            }
        }
    }
}

extension FeaturedViewController : connectDelegate {
    func connectDone() {
        let vc = TransactionViewController()
        let bvc = BaseNavigationController(rootViewController: vc)
        self.present(bvc, animated: true)
    }
}

extension FeaturedViewController {
    public func showAlertPresentAction(alertMessage: String, completion: @escaping ((Bool) -> ())) {
        
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: UIAlertAction.Style.cancel, handler: { action in
            completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
extension FeaturedViewController: FilmDetailsFromCellTransitionable { }
extension FeaturedViewController: TVDetailsFromCellTransitionable { }

class SenderData: NSObject {
    var indexPath: IndexPath?
    var tag : Int?
}
