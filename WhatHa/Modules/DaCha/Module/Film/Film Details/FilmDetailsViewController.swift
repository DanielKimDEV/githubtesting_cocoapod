//
//  FilmDetailsViewController.swift
//  WhatFilm
//
//  Created by Jason Kim on 28/09/2018.
//  Copyright © 2018 Jason Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import MaterialComponents
import Material
import Lottie
// MARK: -

public final class FilmDetailsViewController: UIViewController, ReactiveDisposable {

    
    // MARK: - Properties for Programically Used
    
    fileprivate var fabButton = MDCFloatingButton()
    
    // MARK: - Properties
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: FilmDetailsViewModel?
    var backgroundImagePath: Observable<ImagePath?> = Observable.empty()
    var tadaView: LOTAnimationView!
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var blurredImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var fakeNavigationBar: UIView!
    @IBOutlet weak var fakeNavigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backdropImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmOverviewLabel: UILabel!
    @IBOutlet weak var filmSubDetailsView: UIView!
    @IBOutlet weak var filmRuntimeImageView: UIImageView!
    @IBOutlet weak var filmRuntimeLabel: UILabel!
    @IBOutlet weak var filmRatingImageView: UIImageView!
    @IBOutlet weak var filmRatingLabel: UILabel!
    @IBOutlet weak var creditsView: UIView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var castViewHeight: NSLayoutConstraint!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var crewView: UIView!
    @IBOutlet weak var crewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var crewCollectionView: UICollectionView!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var videosViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videosLabel: UILabel!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var ratingView: UIView!
    
    // MARK: - UIViewController life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if let v = self.navigationController?.navigationBar as? NavigationBar  {
            log?.debug("wow material navigation!!!!!!!!")
            v.depthPreset = .none
            v.heightPreset = .none
            v.dividerColor = UIColor.clear
            v.backgroundColor = UIColor.clear
            v.tintColor = UIColor.white
            //        v.heightPreset = .xxlarge
            //        v.backgroundColor = WhiteColor
            //        v.tintColor = RealBlackColor
            v.isTranslucent = true
            v.shadowImage = nil
            v.setBackgroundImage(nil, for: .default)
        }
//        self.navigationController?.navigationItem.backButton.tintColor = RealBlackColor
        self.setupUI()
        self.setupCollectionViews()
        if let viewModel = self.viewModel { self.setupBindings(forViewModel: viewModel) }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        blurredImageView.snp.updateConstraints{ m in
//            m.top.equalToSuperview().offset(backdropImageViewHeight.constant - 56)
//            m.bottom.equalTo(filmTitleLabel.snp.top).offset(16)
//            m.left.equalToSuperview().offset(56)
//            m.width.equalTo(self.view.bounds.width / 2)
//            m.height.equalTo(self.view.bounds.height / 2)
//        }
        
        if(self.navigationController?.navigationBar.isHidden ?? true) {
            //nothing..
            log?.debug("wow, navi is hidden!!")
        } else {
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.fakeNavigationBarHeight.constant = self.topLayoutGuide.length
//        self.navigationController?.navigationBar.backItem?.title = ""
        // Adjust scrollview insets based on film title
        let height: CGFloat = self.view.bounds.width / ImageSize.backdropRatio
        self.scrollView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
//        self.fakeNavigationBar.backgroundColor = UIColor(commonColor: .offBlack).withAlphaComponent(0.2)
        self.filmTitleLabel.apply(style: .filmDetailTitle)
        self.filmSubDetailsView.alpha = 0.0
        self.filmSubDetailsView.backgroundColor = UIColor.clear
        self.filmRuntimeImageView.image = #imageLiteral(resourceName: "Time_Icon").withRenderingMode(.alwaysTemplate)
        self.filmRuntimeImageView.tintColor = UIColor(commonColor: .yellow)
        self.filmRuntimeLabel.apply(style: .filmRating)
        self.filmRatingImageView.image = #imageLiteral(resourceName: "favoriteicon_profile_24x24_").withRenderingMode(.alwaysTemplate)
        self.filmRatingImageView.tintColor = UIColor(hexString: "#F68F17")
        self.filmRatingLabel.apply(style: .filmRating)
        self.filmRatingLabel.textColor = UIColor(hexString:"#F68F17")
        self.filmOverviewLabel.apply(style: .body)
        self.creditsView.alpha = 0.0
        self.crewLabel.apply(style: .filmDetailTitle)
        self.castLabel.apply(style: .filmDetailTitle)
        self.videosLabel.apply(style: .filmDetailTitle)
        
        // layout update
        self.ratingView.snp.updateConstraints{ m in
            m.left.equalToSuperview()
            m.right.equalToSuperview()
            m.centerY.equalToSuperview()
        }
        self.ratingView.isHidden = true
//        self.filmTitleLabel.snp.updateConstraints{ m in
//            m.left.equalToSuperview().offset(16)
//            m.right.equalToSuperview().offset(-80)
//            m.top.equalTo(self.ratingView.snp.top)
//        }
        self.prepareBackButton()
        self.prepareFAB()
        self.navigationController?.navigationBar.backgroundColor = RealBlackColor
    }
    
    
    fileprivate func prepareBackButton() {
        let backButton = IconButton(image: UIImage(named:"personal_home_back_white_24x24_"), tintColor: WhiteColor)
        backButton.addTarget(self, action: #selector(clickedBackButton), for: .touchUpInside)
        backButton.layer.zPosition = 999
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints{ m in
            m.width.height.equalTo(24)
            m.top.equalToSuperview().offset(56)
            m.left.equalToSuperview().offset(16)
        }
    }
    
    @objc
    func clickedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func prepareFAB() {
        let plusImage = UIImage(named: "favoriteicon_profile_24x24_")
        
        fabButton.sizeToFit()
        fabButton.layer.masksToBounds = false
        
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        fabButton.setImage(plusImage, for: .normal)
        fabButton.backgroundColor = BBGreenColor
        fabButton.accessibilityLabel = "Create"
        fabButton.addTarget(self, action: #selector(fabButtonClicked), for: .touchUpInside)
        
        view.layout(fabButton).width(56).height(56)
        
        
        fabButton.snp.makeConstraints { m in
            m.right.equalToSuperview().offset(-24)
            m.bottom.equalToSuperview().offset(-160)
        }
    }
    
    
    @objc func fabButtonClicked() {
        log?.debug("wow....!!!")
        self.presentRaitingBottomSheet()
    }
    
    fileprivate func presentRaitingBottomSheet() {
        let bottomVC = ReviewBottomSheetViewController()
            bottomVC.delegate = self
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: bottomVC)
        bottomSheet.preferredContentSize.height = 300
        bottomSheet.dismissOnBackgroundTap = true
        self.present(bottomSheet, animated: true) {
            if let draggableSubviews = bottomSheet.presentationController!.presentedView?.subviews {
                for draggableSubview in draggableSubviews {
                    if let dragGestureRecognizers = draggableSubview.gestureRecognizers {
                        for gesture in dragGestureRecognizers {
                            draggableSubview.removeGestureRecognizer(gesture)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setupCollectionViews() {
        self.crewCollectionView.registerReusableCell(PersonCollectionViewCell.self)
        self.crewCollectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.crewCollectionView.showsHorizontalScrollIndicator = false
        self.castCollectionView.registerReusableCell(PersonCollectionViewCell.self)
        self.castCollectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.castCollectionView.showsHorizontalScrollIndicator = false
        self.videosCollectionView.registerReusableCell(VideoCollectionViewCell.self)
        self.videosCollectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        self.videosCollectionView.showsHorizontalScrollIndicator = false
    }
    
    fileprivate func updateBackdropImageViewHeight(forScrollOffset offset: CGPoint?) {
        if let height = offset?.y {
            self.blurredImageViewHeight.constant = max(0.0, -height)
        } else {
            let height: CGFloat = self.view.bounds.width / ImageSize.backdropRatio
            self.blurredImageViewHeight.constant = max(0.0, height)
        }
    }
    
    // MARK: - Populate
    
    fileprivate func populate(forFilmDetail filmDetail: FilmDetail) {
        UIView.animate(withDuration: 0.2) { self.filmSubDetailsView.alpha = 1.0 }
        if let runtime = filmDetail.runtime { self.filmRuntimeLabel.text = "\(runtime) min" }
        else { self.filmRuntimeLabel.text = " - " }
        self.filmRatingLabel.text = "\(filmDetail.voteAverage)/10"
        self.blurredImageView.contentMode = .scaleAspectFill
        if let backdropPath = filmDetail.backdropPath {
            if let posterPath = filmDetail.posterPath { self.blurredImageView.setImage(fromTMDbPath: posterPath, withSize: .medium) }
            self.blurredImageView.contentMode = .scaleAspectFill
            self.blurredImageView.setImage(fromTMDbPath: backdropPath, withSize: .medium, animatedOnce: true)
            self.backdropImageView.backgroundColor = UIColor.clear
        } else if let posterPath = filmDetail.posterPath {
            self.blurredImageView.setImage(fromTMDbPath: posterPath, withSize: .medium)
            self.blurredImageView.contentMode = .scaleAspectFill
            self.blurredImageView.setImage(fromTMDbPath: posterPath, withSize: .medium)
            self.blurredImageView.backgroundColor = UIColor.clear
        } else {
            self.blurredImageView.image = nil
            self.blurredImageView.contentMode = .scaleAspectFill
            self.blurredImageView.image = #imageLiteral(resourceName: "channel11")
            self.blurredImageView.backgroundColor = UIColor.groupTableViewBackground
        }
        self.filmTitleLabel.text = filmDetail.fullTitle.uppercased()
        self.filmOverviewLabel.text = filmDetail.overview
        self.videosView.alpha = 0.0
    }
    
    public func prePopulate(forFilm film: Film) {
        if let posterPath = film.posterPath { self.blurredImageView.setImage(fromTMDbPath: posterPath, withSize: .medium, animatedOnce: true) }
        self.filmTitleLabel.text = film.fullTitle.uppercased()
        self.title = film.fullTitle.uppercased()
        self.filmOverviewLabel.text = film.overview
    }
    
    // MARK: - Reactive setup
    
    fileprivate func setupBindings(forViewModel viewModel: FilmDetailsViewModel) {
        
        viewModel
            .filmDetail
            .subscribe(onNext: { [weak self] (filmDetail) in
                self?.populate(forFilmDetail: filmDetail)
            }).addDisposableTo(self.disposeBag)
        
        self.backgroundImagePath = viewModel.filmDetail.map { (filmDetail) -> ImagePath? in
            return filmDetail.posterPath ?? filmDetail.backdropPath
        }
        
//        self.scrollView.backgroundColor = WhiteColor.withAlphaComponent(0.4)
        self.scrollView.rx.contentOffset.subscribe { [weak self] (contentOffset) in
            self?.updateBackdropImageViewHeight(forScrollOffset: contentOffset.element)
        }.addDisposableTo(self.disposeBag)
        
        viewModel
            .credits
            .map({ $0.crew })
            .bindTo(self.crewCollectionView.rx.items(cellIdentifier: PersonCollectionViewCell.DefaultReuseIdentifier, cellType: PersonCollectionViewCell.self)) {
                (row, person, cell) in
                cell.populate(with: person)
            }.addDisposableTo(self.disposeBag)
        
        viewModel
            .credits
            .map({ $0.cast })
            .bindTo(self.castCollectionView.rx.items(cellIdentifier: PersonCollectionViewCell.DefaultReuseIdentifier, cellType: PersonCollectionViewCell.self)) {
                (row, person, cell) in
                cell.populate(with: person)
            }.addDisposableTo(self.disposeBag)
        
        viewModel
            .filmDetail
            .map({ $0.videos })
            .subscribe(onNext: { [weak self] (videos) in
                if videos.count > 0 {
                    self?.videosLabel.text = "클립 영상"
                    self?.videosViewHeight.constant = 15.0 + TextStyle.filmDetailTitle.font.lineHeight + 100.0
                } else {
                    self?.videosLabel.text = nil
                    self?.videosViewHeight.constant = 0.0
                }
                self?.scrollView.layoutIfNeeded()
            }).addDisposableTo(self.disposeBag)
        
        
        viewModel
            .filmDetail
            .map({ $0.videos })
            .bindTo(self.videosCollectionView.rx.items(cellIdentifier: VideoCollectionViewCell.DefaultReuseIdentifier, cellType: VideoCollectionViewCell.self)) {
                (row, video, cell) in
                if let thumbnailURL = video.youtubeThumbnailURL {
                    cell.videoThumbnailImageView.sd_setImage(with: thumbnailURL)
                } else {
                    cell.videoThumbnailImageView.image = nil
                }
            }.addDisposableTo(self.disposeBag)
        
        self.videosCollectionView.rx.modelSelected(Video.self).subscribe { [weak self] (event) in
            guard let video = event.element else { return }
            self?.play(video: video)
            }.addDisposableTo(self.disposeBag)
        
        viewModel
            .credits
            .subscribe(onNext: { [weak self] (credits) in
                let defaultHeight: CGFloat = 15.0 + TextStyle.filmDetailTitle.font.lineHeight + 140.0
                if credits.cast.count > 0 {
                    self?.castLabel.text = "출연진"
                    self?.castViewHeight.constant = defaultHeight
                } else {
                    self?.castLabel.text = nil
                    self?.castViewHeight.constant = 0.0
                }
                if credits.crew.count > 0 {
                    self?.crewLabel.text = "제작진"
                    self?.crewViewHeight.constant = defaultHeight
                } else {
                    self?.crewLabel.text = nil
                    self?.crewViewHeight.constant = 0.0
                }
                self?.scrollView.layoutIfNeeded()
                UIView.animate(withDuration: 0.2) {
                    self?.videosView.alpha = 1.0
                    self?.creditsView.alpha = 1.0
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Actions handling
    
    fileprivate func play(video: Video) {
        guard let url = video.youtubeURL else { return }
//        UIApplication.shared.openURL(url)
        let vc = PlayWebViewController()
        vc.url = url.absoluteString
        vc.isWhite = true
        let bvc = FullScreenNavigationController(rootViewController:vc)
        self.present(bvc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
    // MARK: - Navigation handling
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let personViewController = segue.destination as? PersonViewController,
            let sender = sender as? CollectionViewSelection {
            do {
                let person: Person = try sender.collectionView.rx.model(at: sender.indexPath)
                let personViewModel = PersonViewModel(withPersonId: person.id)
                personViewController.viewModel = personViewModel
                personViewController.backgroundImagePath = self.backgroundImagePath
                personViewController.rx.viewDidLoad.subscribe(onNext: { _ in
                    personViewController.prePopulate(forPerson: person)
                }).addDisposableTo(self.disposeBag)
                Analytics.track(viewContent: "Selected person", ofType: "Person", withId: "\(person.id)", withAttributes: ["Person": person.name])
            } catch { fatalError(error.localizedDescription) }
        }
    }
}

// MARK: -

extension FilmDetailsViewController: SegueReachable {
    
    // MARK: - SegueReachable
    
    static var segueIdentifier: String { return PushFilmDetailsSegue.identifier }
}

// MARK: - 

extension FilmDetailsViewController: UICollectionViewDelegate {
    
    // MARK: - UITableViewDelegate functions
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == self.castCollectionView || collectionView == self.crewCollectionView else { return }
        let sender = CollectionViewSelection(collectionView: collectionView, indexPath: indexPath)
        self.performSegue(withIdentifier: PersonViewController.segueIdentifier, sender: sender)
    }
}

// MARK: -

extension FilmDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout functions
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.videosCollectionView {
            let width: CGFloat = collectionView.bounds.height * VideoCollectionViewCell.imageRatio
            return CGSize(width: width, height: collectionView.bounds.height)
        } else {
            return CGSize(width: 80.0, height: collectionView.bounds.height)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}


extension FilmDetailsViewController: ReviewBottomSheetDelegate {
    public func done() {
        log?.debug("ta-ta!!")
        tadaView = LOTAnimationView(name: "love")
        tadaView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        tadaView.center = self.view.center
        tadaView.contentMode = .scaleAspectFill
//        tadaView.layer.zPosition = 999
        self.view.addSubview(tadaView)
        
        tadaView.play() {
            done in
            if(done) {
                self.tadaView.isHidden = true
            }
        }
    }
}

extension FilmDetailsViewController: PersonFromCellTransitionable { }
