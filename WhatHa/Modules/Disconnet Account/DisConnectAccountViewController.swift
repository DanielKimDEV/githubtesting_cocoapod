//
//  CheckAccountViewController.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//


import Foundation
import UIKit
import Material
import SnapKit


class DisConnectAccountViewController: UIViewController {
    
    var subscribeButton:RaisedButton!
    var clearButton:RaisedButton!
    var refundButton:RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var deleteButton: IconButton!
        
        var token = UserDefaults.UserData.string(forKey: .UserToken)
        if(token.count == 0) {
            SwiftToast.showSwiftToast(message: "먼저 연동부터 하셔야 합니다", duration: 1.0, vc: self)
            
            self.dismiss(animated: true)
        }
        
        deleteButton = IconButton(image: UIImage(named: "titlebar_close_24x24_"))
        deleteButton.addTarget(self, action: #selector(clickedClosebutton), for: .touchUpInside)
        
        self.navigationItem.titleLabel.textColor = WhiteColor
        self.navigationItem.titleLabel.text = "환불 및 연동 끊기"
        self.navigationItem.rightViews = [deleteButton]
        
        self.initViews()
    }
    
    @objc func clickedClosebutton() {
        self.dismiss(animated: true)
    }
    
}


extension DisConnectAccountViewController {
    fileprivate func initViews() {
        self.prepareNavigation()
        self.prepareSubscribeButton()
        self.prepareClear()
        self.prepareRefund()
    }
    
    
    fileprivate func prepareNavigation() {
        navigationController?.navigationBar.backgroundColor = MainBackGroundColor
        navigationController?.navigationBar.tintColor = RedColor
        navigationController?.navigationItem.title = "BitBerryConnect"
        self.view.backgroundColor = MainBackGroundColor
    }
    
    
    fileprivate func prepareSubscribeButton() {
        subscribeButton = RaisedButton(title: "연동 끊기", titleColor: WhiteColor)
        subscribeButton.pulseColor = WhiteColor
        subscribeButton.backgroundColor = RedColor
        subscribeButton.isUserInteractionEnabled = true
        subscribeButton.layer.zPosition = 1
        subscribeButton.layer.shadowOpacity = 0.0
        subscribeButton.layer.shadowColor = UIColor.clear.cgColor
        subscribeButton.titleLabel?.font = setFontDefault(size: 15)
        subscribeButton.addTarget(self, action: #selector(clickedSubscribe), for: .touchUpInside)
        
        self.view.addSubview(subscribeButton)
        
        subscribeButton.snp.makeConstraints { m in
            m.height.equalTo(56)
            m.width.equalTo(130)
            m.centerX.equalToSuperview()
            m.centerY.equalToSuperview().offset(-34)
        }
    }
    
    fileprivate func prepareClear() {
        clearButton = RaisedButton(title: "초기화 시키기", titleColor: WhiteColor)
        clearButton.pulseColor = WhiteColor
        clearButton.backgroundColor = RedColor
        clearButton.isUserInteractionEnabled = true
        clearButton.layer.zPosition = 1
        clearButton.layer.shadowOpacity = 0.0
        clearButton.layer.shadowColor = UIColor.clear.cgColor
        clearButton.titleLabel?.font = setFontDefault(size: 15)
        clearButton.addTarget(self, action: #selector(clickedClearBtn), for: .touchUpInside)
        
        self.view.addSubview(clearButton)
        
        clearButton.snp.makeConstraints { m in
            m.height.equalTo(56)
            m.width.equalTo(130)
            m.top.equalTo(subscribeButton.snp.bottom).offset(12)
            m.centerX.equalToSuperview()
        }
    }
    
    fileprivate func prepareRefund() {
        refundButton = RaisedButton(title: "환불 하기", titleColor: WhiteColor)
        refundButton.pulseColor = WhiteColor
        refundButton.backgroundColor = RedColor
        refundButton.isUserInteractionEnabled = true
        refundButton.layer.zPosition = 1
        refundButton.layer.shadowOpacity = 0.0
        refundButton.layer.shadowColor = UIColor.clear.cgColor
        refundButton.titleLabel?.font = setFontDefault(size: 15)
        refundButton.addTarget(self, action: #selector(clickedRefund), for: .touchUpInside)
        
        self.view.addSubview(refundButton)
        
        refundButton.snp.makeConstraints { m in
            m.top.equalTo(clearButton.snp.bottom).offset(12)
            m.height.equalTo(56)
            m.width.equalTo(130)
            m.centerX.equalToSuperview()
        }
    }
}

extension DisConnectAccountViewController {
    
    @objc
    fileprivate func clickedRefund() {
        let transferID = UserDefaults.UserData.string(forKey: .PaidTransferID)
        if(transferID.count > 3) {
            self.requestRefund(transferId: transferID)
        } else {
            SwiftToast.showSwiftToast(message: "결제를 먼저 하세요", duration: 1.0, vc: self)
        }
    }
    
    fileprivate func requestRefund(transferId:String) {
        NetworkManager.requestWithdrawCancel(transferRequest: transferId) {
            (successCode, data, isSuccess, errString) in
            
            if(isSuccess) {
                UserDefaults.isSet.set(false, forKey: .isPaid)
                UserDefaults.UserData.set("",forKey: .PaidTransferID)
                self.showAlertPresentAction(alertMessage: "환불이 완료 되었습니다.") { result in
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc
    fileprivate func clickedSubscribe() {
        if(UserDefaults.UserData.string(forKey: .UserToken).count > 0 && UserDefaults.UserData.string(forKey: .PaidTransferID).count > 3) {
            self.requestDisconnect()
        } else {
            SwiftToast.showSwiftToast(message: "먼저 connect를 실행 해야 합니다.", duration: 0.4, vc: self)
        }
    }
    
    
    @objc
    fileprivate func clickedClearButton() {
        if(UserDefaults.UserData.string(forKey: .UserToken).count > 0) {
            self.requestDisconnect()
        } else {
            SwiftToast.showSwiftToast(message: "먼저 connect를 실행 해야 합니다.", duration: 0.4, vc: self)
        }
    }
    
}

//Network
extension DisConnectAccountViewController{
    
    fileprivate func requestDisconnect() {
        NetworkManager.requestBitBerryDisConnet() {
            (successCode, data, isSuccess, ErrData) in
            
            if(isSuccess) {
                SwiftToast.showSwiftToast(message: "Disconnect", duration: 0.1, vc: self)
                UserDefaults.isSet.set(false, forKey: .isPaid)
                UserDefaults.isSet.set(false, forKey: .isConnected)
                
                UserDefaults.UserData.set("", forKey: .UserToken)
                UserDefaults.FreePlay.set(1, forKey: .RemainFreeUse)
                self.dismiss(animated: true)
            } else {
                SwiftToast.showSwiftToast(message: "Disconnect is Error", duration: 0.1, vc: self)
            }
            
        }
    }
    
    @objc
    fileprivate func clickedClearBtn() {

        
        if(UserDefaults.isSet.bool(forKey: .isConnected)) {
            NetworkManager.requestBitBerryDisConnet() {
                (successCode, data, isSuccess, ErrData) in
                
                if(isSuccess) {
                    UserDefaults.UserData.set("", forKey: .Uid)
                    UserDefaults.UserData.set("", forKey: .PhoneNumber)
                    UserDefaults.UserData.set("", forKey: .UserToken)
                    UserDefaults.isSet.set(false, forKey: .isPaid)
                    UserDefaults.isSet.set(false, forKey: .isConnected)
                    UserDefaults.FreePlay.set(1, forKey: .RemainFreeUse)
                    SwiftToast.showSwiftToast(message: "Disconnect", duration: 0.1, vc: self)
                    
                    UserDefaults.UserData.set("", forKey: .UserToken)
                    self.dismiss(animated: true)
                } else {
                    SwiftToast.showSwiftToast(message: "Disconnect is Error", duration: 0.1, vc: self)
                }
            }
        } else {
              SwiftToast.showSwiftToast(message: "초기화는 Connect 이후 가능 합니다.", duration: 0.1, vc: self)
        }
    }

    public func showAlertPresentAction(alertMessage: String, completion: @escaping ((Bool) -> ())) {
        
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: UIAlertAction.Style.cancel, handler: { action in
            completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }}
