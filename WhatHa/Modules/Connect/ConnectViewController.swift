//
//  ConnectViewController.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import SwiftHEXColors
import Foundation
import Material
import SnapKit
import UIKit
import SwiftyJSON
import SwiftDate
import SVProgressHUD
import Lottie

protocol kakaoPayisDoneDelegate: class {
    func kakaoPayDone(isSuccess: Bool)
    func verifyKakaoExpiredSession()
    
}

protocol connectDelegate: class {
    func connectDone()
}

class ConnectViewController: UIViewController {
    
    weak var delegate:connectDelegate?
    
    var transactionID: String?
    
    let timerSetting = 300
    var seconds = 0
    var startTime: Date?
    
    var isRegister: Bool = false
    
    var timer: Timer!
    var serverSettingTime: Int = 300
    
    var titleImg: IconButton!
    var titleLabel: UILabel!

    
    var timesUpLabel: UILabel!
    var reTryButton: RaisedButton!
    
    var bottomView: UIView!
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    
    var flag: Bool = false
    var backGroundFlag = false
    
    var code = ""
    //
    
    var BGView : UIView!
    var codeLabel: UILabel!
    var timeLabel: UILabel!
    var connectButton: RaisedButton!
    var pressLabel: UILabel!
    
    //title and des
    var title1Label:UILabel!
    var title1Des:UILabel!
    var title2Label:UILabel!
    var title2Des:UILabel!
    var isPhoneNumber:Bool = true
    //
    var checkWithPhoneNumberBtn:RaisedButton!
    var playstoreButton:RaisedButton!
    var tadaView: LOTAnimationView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = UserDefaults.UserData.string(forKey: .UserToken)
        
        log?.debug("token is \(token)")
        
        if(token.count > 0) {
            SwiftToast.showSwiftToast(message: "이미 비트베리 커넥트가 연결 되어 있습니다", duration: 1.0, vc:self)
            self.dismissView()
        }
        
        self.prepareView()

        
        self.setBackGroundListener()
        self.backGroundFlag = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkBitBerry()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeBackGroundListener()
        if(timer != nil) {
        self.timer.invalidate()
        }
    }
    
    fileprivate func setBackGroundListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willForeGround), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    fileprivate func removeBackGroundListener() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func willResignActive(_ notification: Notification) {
        //인증시에 잠시 앱이 백그라운드로 가있는 동안 타이머가 멈춰 있습니다.
        if(flag) {
            if(timer != nil) {
                self.timer.invalidate()
            }
        }
        self.backGroundFlag = true
    }
    
    @objc func willForeGround(_ notification: Notification) {

        //인증시에 앱이 포그라운드로 돌아 가면 타이머를 작동 시키고 차이를 계산하여 계속 돕니다.
        //잠시 1초 동안 프로그래스바 보여주고 다시 시작.
 
        DispatchQueue.global(qos: .default).async {
            // fake background loading task
            if (self.code.count > 0) {
                 self.requestBitBerryConnectStatus(code: self.code)
            }
            sleep(1)
            DispatchQueue.main.async {
                self.setDateForeGorund()
            }
        }
    }
    
    func setDateForeGorund() {
        if let startDate = self.startTime {
            //startTime은 타이머가 켜졌을 때만 동작 함.
            let nowDate = Date()
            
            var diff = nowDate - startDate

            let min = diff.minute
            let sec = diff.second
            let result = 60 - ((min! * 60) + sec!)
            
            if (result < 0) {
                self.startTime = nil
                if(timer != nil) {
                self.timer.invalidate()
                }
                self.hideRequest()
            } else {
                
                self.seconds = result
                if (self.backGroundFlag) {
                    self.runTimer()
                    self.backGroundFlag = false
                }
            }
        }
    }
}


//MARK - INITVIEWs
extension ConnectViewController {
    
    fileprivate func prepareView() {
        self.viewWidth = self.view.bounds.width
        self.initNavigationController()
        self.initTitleAndDes()
        self.prepareAuthViews()
        self.prepareConnectButton()
        self.prepareTimesUpLabel()
        self.prepareRetryButton()
    }
    
    fileprivate func initNavigationController() {
        self.view.backgroundColor = WhiteColor
        navigationController?.navigationBar.backgroundColor = WhiteColor
        
        self.navigationController?.navigationBar.dividerColor = BBGreenColor
        
        navigationItem.titleLabel.textColor = BBGreenColor
        navigationItem.titleLabel.text = "BITBERRY Connect"
        navigationItem.backButton.tintColor = BBGreenColor
        
        var deleteButton: IconButton!
        
        deleteButton = IconButton(image: Icon.cm.close?.tint(with: RealBlackColor))
        deleteButton.addTarget(self, action: #selector(clickedClosebutton), for: .touchUpInside)
        
        self.navigationItem.rightViews = [deleteButton]
      
    }
    
    fileprivate func initTitleAndDes() {
        self.title1Label = setLabel(title: "1. 설치 및 가입", size: 20, textColor: BBGreenColor, textAlign: .left,isBold: true)
        
        self.title2Label = setLabel(title: "2. 서비스 연결", size: 20, textColor: BBGreenColor, textAlign: .left, isBold: true)

        self.title1Des = setLabel(title: "휴대폰에 비트베리 앱 설치가 필요합니다. 설치 및 가입 후 진행해 주세요.", size: 16, textColor: RealBlackColor, textAlign: .left,numberOfLines: 3)
        
        self.title2Des = setLabel(title: "[비트베리 앱 > 설정 > 서비스 연결] 에서 아래 인증 코드를 입력하세요.", size: 16, textColor: RealBlackColor, textAlign: .left,numberOfLines: 3)
        
        playstoreButton = RaisedButton(title: "설치 하러 가기", titleColor: WhiteColor)
        playstoreButton.titleLabel?.fontSize = 16
        playstoreButton.prepare()
        playstoreButton.pulseColor = UIColor.gray
        playstoreButton.backgroundColor = BBGreenColor
        playstoreButton.isUserInteractionEnabled = true
        playstoreButton.layer.zPosition = 1
        playstoreButton.layer.shadowOpacity = 0.0
        playstoreButton.layer.shadowColor = UIColor.clear.cgColor
        playstoreButton.addTarget(self, action: #selector(self.clickedGoToBitBerry), for: .touchUpInside)
        self.view.addSubview(playstoreButton)
        self.view.addSubview(title1Label)
        self.view.addSubview(title2Label)
        self.view.addSubview(title1Des)
        self.view.addSubview(title2Des)
        
        title1Label.snp.makeConstraints{ m in
            m.top.equalToSuperview().offset(xTopOffset + 80)
            m.left.equalToSuperview().offset(16)
        }
        
        playstoreButton.snp.makeConstraints { m in
            m.top.equalTo(title1Label.snp.top)
            m.left.equalTo(title1Label.snp.right).offset(8)
            m.height.equalTo(30)
            m.width.equalTo(120)
        }
        
        title1Des.snp.makeConstraints{ m in
            m.top.equalTo(title1Label.snp.bottom).offset(16)
            m.left.equalToSuperview().offset(16)
            m.right.equalToSuperview().offset(-16)
            m.centerX.equalToSuperview()
        }

        title2Label.snp.makeConstraints{ m in
            m.top.equalTo(title1Des.snp.bottom).offset(16)
            m.left.equalToSuperview().offset(16)
            m.right.equalToSuperview().offset(-16)
            m.centerX.equalToSuperview()
        }

        title2Des.snp.makeConstraints{ m in
            m.top.equalTo(title2Label.snp.bottom).offset(16)
            m.left.equalToSuperview().offset(16)
            m.right.equalToSuperview().offset(-16)
            m.centerX.equalToSuperview()
        }
        
    }
    
    @objc func clickedGoToBitBerry() {
        if let url = URL(string: "itms://itunes.apple.com/de/app/x-gift/id1411817291") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func clickedClosebutton() {
//           self.timer.invalidate()
        self.dismiss(animated: true)
    }
    
    fileprivate func prepareAuthViews() {
        BGView = UIView()
//        let desLabel = setLabel(title: "비트베리 앱 설치 및 가입 후 인증해주세요.", size: 15)
        
        BGView.backgroundColor = BBIvory3Color
        codeLabel = setLabel(title: "1234 5678 9000", size: 25, isBold : true)
        timeLabel = setLabel(title: "유효시간 5:00", size: 18, isLight : true)
        pressLabel = setLabel(title: "인증코드 발급", size: 20, textColor: RealBlackColor, textAlign: .center, numberOfLines: 0)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.connectBitBerry))
        pressLabel.isUserInteractionEnabled = true
        pressLabel.addGestureRecognizer(gesture)
        
        BGView.addSubview(codeLabel)
        BGView.addSubview(timeLabel)
        BGView.addSubview(pressLabel)
        
        pressLabel.snp.makeConstraints{ m in
            m.centerX.centerY.equalToSuperview()
        }
        
        codeLabel.snp.makeConstraints { m in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().offset(30)
            m.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints{ m in
            m.top.equalTo(codeLabel.snp.bottom).offset(16)
            m.centerX.equalToSuperview()
        }
        
        codeLabel.isHidden = true
        timeLabel.isHidden = true
        pressLabel.isHidden = false
        
        self.view.addSubview(BGView)
        
        BGView.snp.makeConstraints{ m in
            m.top.equalTo(title2Des.snp.bottom).offset(16)
            m.left.equalToSuperview().offset(16)
            m.right.equalToSuperview().offset(-16)
            m.height.equalTo(130)
        }
        
    }
    
    fileprivate func prepareConnectButton() {
        connectButton = RaisedButton(title: "비트베리 앱 열기", titleColor: WhiteColor)
        connectButton.pulseColor = WhiteColor
        connectButton.backgroundColor = BBGreenColor
        connectButton.isUserInteractionEnabled = true
        connectButton.layer.zPosition = 1
        connectButton.layer.shadowOpacity = 0.0
        connectButton.layer.shadowColor = UIColor.clear.cgColor
        connectButton.titleLabel?.font = setFontDefault(size: 15)
        connectButton.addTarget(self, action: #selector(clickedConnect), for: .touchUpInside)
        
        self.view.addSubview(connectButton)
        
        connectButton.snp.makeConstraints { m in
            m.height.equalTo(56)
            m.left.equalToSuperview().offset(32)
            m.right.equalToSuperview().offset(-32)
            m.centerX.equalToSuperview()
            m.top.equalTo(BGView.snp.bottom).offset(56)
        }
        connectButton.isHidden = true
    }
    
    
    fileprivate func prepareTimesUpLabel() {
        self.checkWithPhoneNumberBtn = RaisedButton(title:"앱투앱 모드 On/Off",
                                                    titleColor: WhiteColor)
        
        checkWithPhoneNumberBtn.pulseColor = WhiteColor
        checkWithPhoneNumberBtn.backgroundColor = BBGreenColor
        checkWithPhoneNumberBtn.isUserInteractionEnabled = true
        checkWithPhoneNumberBtn.layer.zPosition = 1
        checkWithPhoneNumberBtn.layer.shadowOpacity = 0.0
        checkWithPhoneNumberBtn.layer.shadowColor = UIColor.clear.cgColor
        checkWithPhoneNumberBtn.titleLabel?.font = setFontDefault(size: 15)
        
        checkWithPhoneNumberBtn.addTarget(self, action: #selector(clickedPhoneNumber), for: .touchUpInside)
        
        
//        self.view.addSubview(checkWithPhoneNumberBtn)
//        checkWithPhoneNumberBtn.snp.makeConstraints{ m in
//            m.height.equalTo(56)
//            m.width.equalTo(140)
//            m.top.equalTo(BGView.snp.bottom).offset(56)
//            m.centerX.equalToSuperview()
//        }
    }
    
    fileprivate func disableCheckWithPhone() {
                checkWithPhoneNumberBtn.backgroundColor = UIColor.darkGray
    }
    
    fileprivate func enableCheckWithPhone() {
                checkWithPhoneNumberBtn.backgroundColor = BBGreenColor
    }
    
    fileprivate func prepareRetryButton() {
//        reTryButton = RaisedButton(title: "재시도", titleColor: RealBlackColor)
//        reTryButton.pulseColor = WhiteColor
//        reTryButton.backgroundColor = MainBackGroundColor
//        reTryButton.fontSize = 15
//        reTryButton.layer.borderColor = RealBlackColor.cgColor
//        reTryButton.layer.borderWidth = 1
//        reTryButton.layer.cornerRadius = 2
//        reTryButton.layer.masksToBounds = false
//
//        self.view.layout(reTryButton).height(40).centerHorizontally()
//        reTryButton.snp.makeConstraints { m in
//            m.top.equalTo(timesUpLabel.snp.bottom).offset(0)
//            m.left.equalToSuperview().offset(16)
//            m.right.equalToSuperview().offset(-16)
//        }
//
//        reTryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
    }

    
    fileprivate func checkBitBerry() {
        if(AppChecker.checkBitBerry()) {
            playstoreButton.title = "비트베리 설치됨"
            playstoreButton.removeTarget(self, action: nil, for: .allEvents)
        } else {
            //nothing..
        }
    }
}

extension ConnectViewController {
    
    @objc
    fileprivate func clickedConnect() {
        DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                let urlstr:String = "bitberryalpha://connect?code=\(self.code)&return_to=bittube://wow"
                let url = URL.init(string: urlstr)
                UIApplication.shared.openURL(url!)
            }
        }
    }
}

//NetworkManager
extension ConnectViewController {
    //Retry시에 다시 트랜잭션 하고 -> 카카오 Request부르도록 한다.
    
    fileprivate func requestTransactionBitBerryConnect(isRetry: Bool = false) {
//        NetworkManager.requestBitBerryConnect(thirdPartyID: UserDefaults.UserData.string(forKey: .Uid), completionCallBack: "bittube://wow", phoneNumber: "+8201023877963") {
        NetworkManager.requestBitBerryConnect(thirdPartyID: UserDefaults.UserData.string(forKey: .Uid), completionCallBack: "bittube://wow", phoneNumber: UserDefaults.UserData.string(forKey: .PhoneNumber)) {
            (successCode, data, isSuccess, errString) in
            if (isSuccess && data != nil) {
                self.code = data?.code ?? ""
                self.codeLabel.text = self.code
                self.initTimer(time: 300)
                self.runTimer()
                isRetry ? self.setDateForeGorund() : nil
                self.showRequest()
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
//                self.Error(errorString: errString!)
            }
        }
    }
    
    fileprivate func requestBitBerryConnectStatus(code: String) {
        log?.debug("code is \(code)")
        NetworkManager.requestBitBerryVerifyConnect(code: code) {
            (successCode, data, isSuccess, errString) in
            
            if (isSuccess && data?.status == "connected") {
                log?.debug("geeeeet token is :\(data?.token ?? "")")
                self.timer.invalidate()
                
                UserDefaults.UserData.set((data?.token)!, forKey: .UserToken)
                UserDefaults.isSet.set(true, forKey: .isConnected)
                log?.debug("ta-ta!!")

                DispatchQueue.main.async {
                    self.tadaView = LOTAnimationView(name: "connect")
                    self.tadaView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                    self.tadaView.center = self.view.center
                    self.tadaView.contentMode = .scaleAspectFill
                    self.tadaView.layer.zPosition = 999
                    self.view.addSubview(self.tadaView)
                    self.tadaView.play() {
                        done in
                        if(self.navigationController?.viewControllers.count ?? 0 > 2) {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.dismiss(animated: true, completion: {
                                self.delegate?.connectDone()
                            })
                        }
                    }
                }
            } else {
//                SwiftToast.showSwiftToast(message:"error", duration: 0.2, vc: self)
            }
        }
    }

    
    fileprivate func showCompleteAlert() {
        let alertController = UIAlertController(title: nil, message: "kakao_pay_done", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "done", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            self.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}



//Clicked
extension ConnectViewController {
    
    fileprivate func successKakaoPay(requestId: String) {
        /// kakaoPay인증에 성공 하였을 경우. 보내기 완료 뷰를 띄우도록 한다.
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    @objc fileprivate func clickedPhoneNumber() {
        if(isPhoneNumber) {
            
            disableCheckWithPhone()
            isPhoneNumber = false
        } else {
            
            
            enableCheckWithPhone()
            isPhoneNumber = true
        }
    }
    
    @objc fileprivate func retry() {
        self.showRequest()
        self.runTimer()
        self.requestTransactionBitBerryConnect(isRetry: true)
    }
    
    
    @objc fileprivate func dismissView() {
        self.dismiss(animated: true)
    }
    
    
    @objc fileprivate func connectBitBerry() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
        self.requestTransactionBitBerryConnect()
    }
}

//Timer

extension ConnectViewController {
    
    fileprivate func showRequest() {
//        titleLabel.isHidden = false
        self.timeLabel.isHidden = false
        self.codeLabel.isHidden = false
        self.pressLabel.isHidden = true
        self.connectButton.isHidden = false
        self.checkWithPhoneNumberBtn.isHidden = true
    }
    
    fileprivate func hideRequest() {
//        titleLabel.isHidden = true
        self.timeLabel.isHidden = true
        self.codeLabel.isHidden = true
        self.pressLabel.isHidden = false
        self.connectButton.isHidden = true
        self.checkWithPhoneNumberBtn.isHidden = false
    }
    
    fileprivate func initTimer(time: Int) {
        startTime = Date()
        seconds = time
        flag = false
    }
    
    fileprivate func runTimer() {
        //Todo - 잠시 끔..
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(self.updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc fileprivate func updateTimer() {
        if seconds < 1 {
            if(timer != nil) {
            timer.invalidate()
            }
            self.isTimeUp()
        } else {
            self.tictoc()
        }
    }
    
    fileprivate func isTimeUp() {
        hideRequest()
    }
    
    fileprivate func tictoc() {
        seconds -= 1
        let minStr = "0\(seconds / 60)"
        let sec = seconds % 60
        var secStr = ""
        if sec < 10 {
            secStr = "0\(sec)"
        } else {
            secStr = "\(sec)"
        }
        
        let timeStr = minStr + ":" + secStr
        timeLabel.text = timeStr
        //카카오 스테이터스를 계속 트래킹 하도록 합시다.
    }
    
    public func showAlertPresentActionWithTitle(titleMessage:String, alertMessage: String, completion: @escaping ((Bool) -> ())) {
        
        let alert = UIAlertController(title: titleMessage, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: UIAlertAction.Style.cancel, handler: { action in
            completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
