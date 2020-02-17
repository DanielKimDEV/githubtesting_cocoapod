//
//  ReviewBottomSheetViewController.swift
//  WhatHa
//
//  Created by kim jason on 19/02/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit
import MaterialComponents
import Material
import SnapKit
import Cosmos
import SVProgressHUD

public protocol ReviewBottomSheetDelegate: class {
    func done()
}

class ReviewBottomSheetViewController : UIViewController {
    
    
    public weak var delegate: ReviewBottomSheetDelegate?
    
    
    var raiting = 8.0
    
    var confirmButton: RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
}


extension ReviewBottomSheetViewController {
    
    fileprivate func initViews() {
     
        self.view.backgroundColor = WhiteColor
        
        var topHandleView = UIView()
        topHandleView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        topHandleView.layer.cornerRadius = 3
        
        self.view.addSubview(topHandleView)
        topHandleView.snp.makeConstraints{ m in
            m.top.equalToSuperview().offset(16)
            m.height.equalTo(6)
            m.width.equalTo(80)
            m.centerX.equalToSuperview()
        }
        
        
        var titleLabel = setLabel(title: "해당 영화의 별점을 입력 하세요.", size: 21, textColor: UIColor.black, textAlign: .center, numberOfLines: 0, isBold: true)
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ m in
            m.top.equalTo(topHandleView.snp.bottom).offset(24)
            m.centerX.equalToSuperview()
        }
        
        var subTitleLabel = setLabel(title: "별점에 참여 하시면 1SPT를 보상으로 드립니다. :D", size: 14, textColor: UIColor.gray, textAlign: .center)
        self.view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints{ m in
            m.top.equalTo(titleLabel.snp.bottom).offset(12)
            m.centerX.equalToSuperview()
        }
        
        var starViewSetting = CosmosSettings()
        starViewSetting.totalStars = 5
        starViewSetting.emptyColor = WhiteColor
        starViewSetting.filledColor = UIColor(hexString:"#EFC67F")!
        starViewSetting.starSize = 30
        starViewSetting.emptyBorderColor = UIColor(hexString:"#EFC67F")!
        starViewSetting.filledBorderColor = UIColor(hexString:"#EFC67F")!
        starViewSetting.passTouchesToSuperview = true
        starViewSetting.fillMode = .precise
        
        var starView = CosmosView()
        starView.settings = starViewSetting
        starView.rating = 8
        
        self.view.addSubview(starView)
        
        starView.snp.makeConstraints{ m in
            m.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            m.height.equalTo(50)
            m.centerX.equalToSuperview()
        }
        
        starView.didFinishTouchingCosmos = { rating in
            self.raiting = rating
        }
        starView.didTouchCosmos = { rating in
                  self.raiting = rating
        }
        
        confirmButton = RaisedButton(title: "리뷰 남기기", titleColor: WhiteColor)
        confirmButton.pulseColor = WhiteColor
        confirmButton.backgroundColor = UIColor(hexString:"#49A187")!
        confirmButton.isUserInteractionEnabled = true
        confirmButton.layer.zPosition = 1
        confirmButton.layer.shadowOpacity = 0.0
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.shadowColor = UIColor.clear.cgColor
        confirmButton.titleLabel?.font = setFontDefault(size: 15)
        
        self.view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints{ m in
            m.bottom.equalToSuperview().offset(-56)
            m.width.equalTo(self.view.bounds.width - 64)
            m.height.equalTo(56)
            m.centerX.equalToSuperview()
        }
        confirmButton.addTarget(self, action: #selector(clickedConfirmButton), for: .touchUpInside)
        
    }
}

extension ReviewBottomSheetViewController {
    @objc fileprivate func clickedConfirmButton() {
        confirmButton.removeTarget(self, action: nil, for: .allEvents)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
        log?.debug("clicked confirm button rating is \(self.raiting)")
        self.sendAirdrop()
    }
    
    fileprivate func sendAirdrop() {
        NetworkManager.requestAirdrop(walletId: dachaWalletID, amount: "1.0", phoneNumber: UserDefaults.UserData.string(forKey: .PhoneNumber)) {
            (successCode, data, isSuccess, errString) in
            SVProgressHUD.dismiss()
            self.confirmButton.addTarget(self, action: #selector(self.clickedConfirmButton), for: .touchUpInside)
            if(isSuccess) {
                self.delegate?.done()
                SwiftToast.showSwiftToast(message: "감사 합니다 1.0 SPT를 에어드랍 해드렸습니다.", duration: 1.0, vc: self)
                self.dismiss(animated: true)
            } else {
                self.dismiss(animated: true)
            }
            
        }
    }
}
