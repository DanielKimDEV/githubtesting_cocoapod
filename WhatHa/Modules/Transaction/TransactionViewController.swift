//
//  TransactionViewController.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import UIKit
import Material
import SnapKit

class TransactionViewController: UIViewController {
    
    
    var topTitle:UILabel!
    var product1Button:ProductButton!
    var discountTitle:UILabel!
    var product2Button:ProductButton!
    var product3Button:ProductButton!
    
    var productClearButton:ProductButton!
    
    var refundButton:ProductButton!
    
    var orderId = "\(Int(arc4random_uniform(1000000)))"
    
    
    var desLabel:UILabel!
    var transferId:String = ""
    
    
    var desTexts = "- 영화 검색, 영화 시청 등의 모든 기능을 이용 히실 수 있습니다\n- AppStore의 결제 방식이 아닌, BitBerry에서 Support Token으로 이용 하실 수 있습니다.\n-인터넷 환경 혹은 저작권자의 조건에 따라. FullHD 재생이 제한 될 수 있습니다\n-실사용 도중 해지하는 경우 남은 기간에 대한 금액은 환불되지 않습니다\n-문제가 생긴다면 다니엘을 찾아가 커피를 한잔 사주세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLockScreenObserver()
        self.initViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func clickedClosebutton() {
        self.dismiss(animated: true)
    }
    
    public func setLockScreenObserver() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecome(notification:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        
        
    }
    
    @objc func applicationDidBecome(notification: NSNotification) {
        log?.debug("showVerfy")
        if(self.transferId.count > 0) {
            self.prepareRequestDone(tranferId: self.transferId)
        }
        
    }
}


extension TransactionViewController {
    fileprivate func initViews() {
        self.prepareNavigation()
        self.prepareViews()
    }
    
    
    fileprivate func prepareNavigation() {
//        self.navigationItem.backgroundColor = MainBackGroundColor
        self.navigationItem.titleLabel.text = "다챠월드, 결제 하세요!"
        self.navigationItem.titleLabel.textColor = WhiteColor
        //        navigationController?.navigationBar.tintColor = RedColor
        //        navigationController?.navigationItem.title = "BitBerryConnect"
        self.view.backgroundColor = MainBackGroundColor
        self.navigationController?.navigationBar.backgroundColor = MainBackGroundColor
        self.navigationController?.navigationBar.tintColor = BBGreenColor
        var deleteButton: IconButton!
        
        deleteButton = IconButton(title: "닫기")
        deleteButton.titleColor = RedColor
        deleteButton.addTarget(self, action: #selector(clickedClosebutton), for: .touchUpInside)
        
        self.navigationItem.rightViews = [deleteButton]
    }
    
    
    fileprivate func prepareViews() {
        topTitle = setLabel(title: "추천 이용권", size: 16, textColor: WhiteColor, textAlign: .left)
        
        discountTitle = setLabel(title: "일반 이용권", size: 16, textColor: WhiteColor, textAlign: .left)
        
        product1Button = ProductButton(title:"3개월 2SPT", titleColor: WhiteColor)
        product1Button.discountTitle = "3개월 마다 1SPT 절약!"
        product1Button.desTitle = "3개월"
        //        product1Button.pulseColor = WhiteColor
        product1Button.prepare()
        product1Button.addTarget(self, action: #selector(clicked1), for: .touchUpInside)
        
        product2Button = ProductButton(title:"1개월 1SPT", titleColor: WhiteColor)
        product2Button.discountTitle = "1개월 마다 1SPT"
        product2Button.desTitle = "1개월"
        product2Button.bgColor = EmeraldColor
        //               product2Button.pulseColor = WhiteColor
        product2Button.prepare()
        product2Button.addTarget(self, action: #selector(clicked2), for: .touchUpInside)
        
        
        productClearButton = ProductButton(title:"구독 초기화", titleColor: WhiteColor)
        productClearButton.discountTitle = ""
        productClearButton.desTitle = ""
        productClearButton.bgColor = MainBackGroundColor
        productClearButton.prepare()
        productClearButton.addTarget(self, action: #selector(clicked3), for: .touchUpInside)
        
        
        refundButton = ProductButton(title:"환불 하기", titleColor: WhiteColor)
        refundButton.discountTitle = ""
        refundButton.desTitle = ""
        refundButton.bgColor = MainBackGroundColor
        refundButton.prepare()
        refundButton.addTarget(self, action: #selector(clickedRefund), for: .touchUpInside)
        
        
        desLabel =  setLabel(title: self.desTexts, size: 16, textColor: UIColor(hexString: "#203030")!, textAlign: .left, numberOfLines: 10)
        
        self.view.addSubview(topTitle)
        self.view.addSubview(discountTitle)
        self.view.addSubview(product1Button)
        self.view.addSubview(product2Button)
        self.view.addSubview(desLabel)
//        self.view.addSubview(productClearButton)
//        self.view.addSubview(refundButton)
        
        topTitle.snp.makeConstraints{ m in
            m.top.equalToSuperview().offset(xTopOffset + 88)
            m.width.equalTo(self.view.bounds.width - 32)
            m.centerX.equalToSuperview()
            //            m.height.equalTo(56)
        }
        
        product1Button.snp.makeConstraints{ m in
            m.top.equalTo(topTitle.snp.bottom).offset(16)
            m.width.equalTo(self.view.bounds.width - 32)
            m.centerX.equalToSuperview()
            m.height.equalTo(56)
        }
        
        discountTitle.snp.makeConstraints{ m in
            m.top.equalTo(product1Button.snp.bottom).offset(32)
            m.width.equalTo(self.view.bounds.width - 32)
            m.centerX.equalToSuperview()
            //            m.height.equalTo(56)
        }
        
        product2Button.snp.makeConstraints{ m in
            m.top.equalTo(discountTitle.snp.bottom).offset(16)
            m.width.equalTo(self.view.bounds.width - 32)
            m.centerX.equalToSuperview()
            m.height.equalTo(56)
        }
        
//        productClearButton.snp.makeConstraints{ m in
//            m.top.equalTo(product2Button.snp.bottom).offset(32)
//            m.width.equalTo(self.view.bounds.width - 128)
//            m.centerX.equalToSuperview()
//            m.height.equalTo(56)
//        }
        
//        refundButton.snp.makeConstraints{ m in
//            m.top.equalTo(productClearButton.snp.bottom).offset(32)
//            m.width.equalTo(self.view.bounds.width - 128)
//            m.centerX.equalToSuperview()
//            m.height.equalTo(56)
//        }
//
        desLabel.snp.makeConstraints{ m in
            m.bottom.equalToSuperview().offset(-56)
            m.width.equalTo(self.view.bounds.width - 32)
            m.centerX.equalToSuperview()
        }
    }
}

extension TransactionViewController {
    
    @objc
    fileprivate func clicked1() {
        log?.debug("clicked1")
        self.checkAndTransaction(message:"3개월 이용권을 구매하시겠습니까?", amount: 2.0, orderId: self.orderId, category: "withdraw", itemName: "3개월 이용권")
    }
    
    @objc
    fileprivate func clicked2() {
        log?.debug("cli cked2")
        self.checkAndTransaction(message:"1개월 이용권을 구매하시겠습니까?", amount: 1.0, orderId: self.orderId, category: "withdraw", itemName: "1개월 이용권")
    }
    
    @objc
    fileprivate func clicked3() {
        log?.debug("clicked3")
        self.checkAndTransaction(message:"구독을 초기화 합니다. (환불아님)",isUnSubscribe: true)
    }
    
    func checkAndTransaction(message:String,
                             amount:Double = 0.0,
                             orderId:String = "",
                             category:String = "",
                             itemName:String = "",
                             isUnSubscribe:Bool = false) {
        
        
        if(!checkConnect() && !isUnSubscribe) {
            self.showAlertPresentAction(alertMessage: "암호화폐 결제를 위해 먼저, 비트베리 커넥트를 수행 해야 합니다.") { result in
                if(result){
                self.goToBitberryConnect()
                }
            }
            return
        }
        
        self.showAlertPresentAction(alertMessage: message) { result in
            if(result) {
                if(isUnSubscribe) {
                    self.clearSubscribe()
                } else {
                    self.doItSubscribe(amount: amount,
                                       orderId: orderId,
                                       category:category,
                                       itemName:itemName)
                }
            } else {
                //nothing..
            }
        }
    }
    
    fileprivate func doItSubscribe(  amount:Double = 0.0,
                                     orderId:String = "",
                                     category:String = "",
                                     itemName:String = "") {
        
        if(UserDefaults.UserData.string(forKey: .SPTWalletID).count > 0) {
            self.requestTransaction(amount: amount,
                                    orderId: orderId,
                                    category:category,
                                    itemName:itemName)
        } else {
            self.requestWalletID(amount: amount,
                                 orderId: orderId,
                                 category:category,
                                 itemName:itemName)
        }
        
        
        //Network gogo~
    }
    
    fileprivate func clearSubscribe() {
        UserDefaults.isSet.set(false, forKey: .isPaid)
        UserDefaults.UserData.set("", forKey: .SPTWalletID)
        UserDefaults.UserData.set("", forKey: .SPTAddress)
        self.dismiss(animated:true)
    }
    
    fileprivate func checkConnect() -> Bool {
        return UserDefaults.isSet.bool(forKey: .isConnected)
    }
    
    fileprivate func goToBitberryConnect() {
        let vc = ConnectViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func requestWalletID(amount:Double = 0.0,
                                     orderId:String = "",
                                     category:String = "",
                                     itemName:String = "") {
        NetworkManager.requestWallets() {
            (successCode, data, isSuccess, errString) in
            if(isSuccess && data?.items! != nil && (data?.items!.count)! > 0) {
                var flag = false
                for(_, value) in (data?.items?.enumerated())! {
                    log?.debug("wallet id is \(value.id)")
                    if(value.currencyCode == "SPT2") {
                        log?.debug("wallet id is SPT22222222!!!")
                        if let walletID = value.id {
                            UserDefaults.UserData.set(walletID, forKey: .SPTWalletID)
                            
                            flag = true
                        }
                        
                        if let address = value.address {
                            UserDefaults.UserData.set(address, forKey: .SPTAddress)
                        }
                        
                        if let amount = value.balance {
                            UserDefaults.UserData.set(amount, forKey: .Amount)
                        }
                    }
                }
                if(flag) {
                    self.requestTransaction(amount: amount,
                                            orderId: orderId,
                                            category:category,
                                            itemName:itemName)
                } else {
                    SwiftToast.showSwiftToast(message: "Error", duration: 0.5, vc: self)
                }
            } else {
                SwiftToast.showSwiftToast(message: "Error", duration: 0.5, vc: self)
            }
        }
    }
    
    fileprivate func prepareRequestDone(tranferId:String) {
        NetworkManager.requestWithdrawDone(transferRequest: tranferId) {
            (successCode, data, isSuccess, errString) in
            
            if(data?.status == "success") {
                UserDefaults.isSet.set(true, forKey: .isPaid)
                self.showAlertPresentAction(alertMessage: "결제가 완료 되었습니다. 결제 해주셔서 감사 합니다.") { result in
                    UserDefaults.UserData.set(self.transferId, forKey: .PaidTransferID)
                    self.dismiss(animated: true)
                }
            }
        }
    }

    @objc
    fileprivate func clickedRefund() {
        if(self.transferId.count > 0) {
            self.requestRefund(transferId: self.transferId)
        } else {
            self.showAlertPresentAction(alertMessage: "먼저 결제를 수행 하셔야 합니다.") { result in
                
            }
        }

    }

    fileprivate func requestRefund(transferId:String) {
        NetworkManager.requestWithdrawCancel(transferRequest: transferId) {
            (successCode, data, isSuccess, errString) in
            
            if(isSuccess) {
                UserDefaults.isSet.set(false, forKey: .isPaid)
                self.showAlertPresentAction(alertMessage: "취소가 완료 되었습니다.") { result in
                    
                }
            }
        }
    }
    
    fileprivate func requestTransaction(amount:Double = 0.0,
                                        orderId:String = "",
                                        category:String = "",
                                        itemName:String = "") {
        let walletID = UserDefaults.UserData.string(forKey: .SPTWalletID)
        log?.debug("request Transaction..")
        NetworkManager.requestTransferWithdraw(walletId: walletID,
                                               amount: amount,
                                               orderId: orderId,
                                               itemName: itemName,
                                               category: category) {
                                                (successCode, data, isSuccess, errString) in
                                                if(isSuccess && data != nil && data?.id != nil) {
                                                    if let url = data?.deepLinkUrl, let id = data?.id {
                                                        self.transferId = (data?.id)!
                                                        self.goingToBitBerry(landingUrl: url)
                                                    } else {
                                                        SwiftToast.showSwiftToast(message: "Error - 다니엘에게 찾아가 이야기 하세요.", duration: 0.5, vc: self)
                                                    }
                                                } else {
                                                    if let errMessage = data?.displayMessage {
                                                        SwiftToast.showSwiftToast(message: "고객님 비트베리의 \(errMessage)", duration: 2.0, vc: self)
                                                    } else {
                                                        SwiftToast.showSwiftToast(message: "Error", duration: 0.5, vc: self)
                                                    }
                                                }
        }
    }
    
    fileprivate func goingToBitBerry(landingUrl:String) {
        DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                var repUrl = landingUrl.replacingOccurrences(of: "bitberry", with: "bitberryalpha")
                repUrl = repUrl + "&return_to=bittube://wow"
                
                log?.debug("req URL \(repUrl)")
                let urlstr:String = repUrl
                let url = URL.init(string: urlstr)
                UIApplication.shared.openURL(url!)
            }
        }
    }
}


extension TransactionViewController {
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
