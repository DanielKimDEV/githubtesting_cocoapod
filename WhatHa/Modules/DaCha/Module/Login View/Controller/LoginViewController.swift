//
//  LoginViewController.swift
//  WhatHa
//
//  Created by kim jason on 20/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import Material
import UIKit
import SVProgressHUD

class LoginViewController : UIViewController {
    
    fileprivate var emailField: ErrorTextField!
//    fileprivate var passwordField: TextField!
    fileprivate var confirmButton: RaisedButton!
    

    /// A constant to layout the textFields.
    fileprivate let constant: CGFloat = 32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgView = UIView()
        let bgImg = UIImageView(image: UIImage(named:"bgLogin"))
        let upperView = UIView()
        upperView.backgroundColor = UIColor(hexString: "#363636")?.withAlphaComponent(0.7)
        bgImg.contentMode = .scaleAspectFill
        bgView.addSubview(bgImg)
        bgView.addSubview(upperView)
        
        bgImg.snp.makeConstraints{ m in
            m.edges.equalToSuperview()
        }
        upperView.snp.makeConstraints{ m in
            m.edges.equalToSuperview()
        }
        
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints{ m in
            m.edges.equalToSuperview()
        }
        
        view.backgroundColor = UIColor(hexString:"#363636")

//        self.navigationItem.title = "로그인 하세요"
//        self.navigationItem.titleLabel.text = "다챠에 어서 오세요 "
//           self.navigationItem.titleLabel.textColor = WhiteColor
//        self.navigationController?.navigationBar.backgroundColor =  UIColor(hexString:"#363636")

//        preparePasswordField()
        prepareEmailField()
        prepareResignResponderButton()
        prepareButtonView()
        setObserver()
        UserDefaults.FreePlay.set(1, forKey: .RemainFreeUse)
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public func setObserver() {

        
        log?.debug("setObserver!")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    public func removeObserver() {
        log?.debug("remove observer!!")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    
    /// Prepares the resign responder button.
    fileprivate func prepareResignResponderButton() {
//        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
//        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
//
//        view.layout(btn).width(100).height(constant).top(40).right(20)
//        btn.snp.makeConstraints{ m in
//            m.centerX.equalToSuperview()
//            m.bottom.equalTo(emailField.snp.top).offset(100)
//        }
        
        let serviceName = setLabel(title: "다챠월드에 어서 오세요", size: 26, textColor: WhiteColor.withAlphaComponent(0.6), textAlign: .center, numberOfLines: 0, isBold: true)
        view.addSubview(serviceName)
        serviceName.snp.makeConstraints{ m in
            m.bottom.equalTo(emailField.snp.top).offset(-48)
            m.centerX.equalToSuperview()
            m.width.equalTo(self.view.bounds.width - 108)
        }
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        emailField?.resignFirstResponder()
//        passwordField?.resignFirstResponder()
    }
    
    func keyboardIsHide(notification: Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    func keyboardWillChange(notification: Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    func keyboardIsShow(notification: Notification) {
        adjustingHeight(true, notification: notification)
    }
    
    func adjustingHeight(_ show: Bool, notification: Notification) {
        log?.debug("wow, adj!")
        var userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : 0)
        
        self.confirmButton.snp.updateConstraints { m in
            m.bottom.equalToSuperview().offset(-changeInHeight)
            if(DeviceManager.checkXDevice()) {
                if(show) {
                    m.height.equalTo(56)
                } else {
                    m.height.equalTo(56 + xBottomOffset)
                }
            }
        }
        
        if(DeviceManager.checkXDevice()) {
            if(show) {
                confirmButton.titleLabel?.snp.updateConstraints{ m in
                    m.centerX.equalToSuperview()
                    m.centerY.equalToSuperview()
                }
            } else {
                confirmButton.titleLabel?.snp.updateConstraints{ m in
                    m.centerX.equalToSuperview()
                    m.centerY.equalToSuperview().offset(-xBottomOffset / 2)
                }
            }
        }
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardIsShow(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.keyboardIsHide(notification: notification)
//        self.keyboardHideDelegate?.keyboardIsHide(notification: notification)
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        self.keyboardWillChange(notification: notification)
//        self.keyboardWillChangeDelegate?.keyboardWillChange(notification: notification)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObserver()
    }
    
}

extension LoginViewController {
    
    fileprivate func prepareButtonView() {
        confirmButton = RaisedButton(title: "확인", titleColor: WhiteColor)
        confirmButton.pulseColor = WhiteColor
        confirmButton.backgroundColor = BBGreenColor
        confirmButton.layer.cornerRadius = 0
        confirmButton.addTarget(self, action: #selector(clickedConfirmButton), for: .touchUpInside)
        
        self.view.addSubview(confirmButton)
        
        if(DeviceManager.checkXDevice()) {
            confirmButton.snp.makeConstraints { m in
                m.width.equalToSuperview()
                m.bottom.equalToSuperview()
                m.centerX.equalToSuperview()
                m.height.equalTo(56 + xBottomOffset)
            }
            confirmButton.titleLabel?.snp.updateConstraints{ m in
                m.centerX.equalToSuperview()
                m.centerY.equalToSuperview().offset(-xBottomOffset / 2)
            }
            
        } else {
            confirmButton.snp.makeConstraints { m in
                m.height.equalTo(56)
                m.width.equalToSuperview()
                m.bottom.equalToSuperview()
                m.centerX.equalToSuperview()
            }
        }
        
        self.confirmButtonDisabled()
        
    }
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.placeholder = "본인의 전화번호를 적어 주세요"
        emailField.detail = "핸드폰 번호를 - 없이 적어 주세요, 비트베리에 가입한 번호와 동일 해야 합니다."
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        emailField.isPlaceholderUppercasedWhenEditing = true
        emailField.placeholderAnimation = .default
        emailField.textColor = WhiteColor
        
        emailField.placeholderLabel.textColor = WhiteColor
        emailField.placeholderActiveColor = WhiteColor
        emailField.placeholderNormalColor = WhiteColor.withAlphaComponent(0.3)
        
        emailField.detailColor = WhiteColor
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        leftView.image?.tint(with: WhiteColor)
        
        
        self.view.addSubview(emailField)
        emailField.snp.makeConstraints{ m in
            m.centerX.centerY.equalToSuperview()
            m.width.equalTo(self.view.bounds.width - 108)
            m.height.equalTo(56)
        }
    }

    fileprivate func confirmButtonDisabled() {
        confirmButton.image = nil
        confirmButton.title = "확인"
        confirmButton.titleColor = WhiteColor
        confirmButton.pulseColor = WhiteColor
        confirmButton.backgroundColor = RealBlackColor
        confirmButton.removeTarget(self, action: nil, for: .allEvents)
    }
    
    fileprivate func confirmButtonEnabled() {
        confirmButton.title = "확인"
        confirmButton.titleColor = WhiteColor
        confirmButton.pulseColor = WhiteColor
        confirmButton.backgroundColor = BBGreenColor
        confirmButton.addTarget(self, action: #selector(clickedConfirmButton), for: .touchUpInside)
    }
    
}


extension LoginViewController: TextFieldDelegate {
    
    @objc
    func clickedConfirmButton() {
        
        self.view.endEditing(true)
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            SVProgressHUD.dismiss()
            let str = self.emailField.text
            if(str!.count > 4) {
                let phoneNumber = "+82\(self.emailField.text!)"
                UserDefaults.UserData.set(phoneNumber, forKey: .PhoneNumber)
                self.dismiss(animated: true)
            }
            
            var userId = "\(Int(arc4random_uniform(1000000)))"
            UserDefaults.UserData.set(userId, forKey: .Uid)
        }
    }
    
    public func textField(textField: TextField, didChange text: String?) {
       (textField as? ErrorTextField)?.isErrorRevealed = false
        var str = textField.text
        if(str!.count > 4) {
            self.confirmButtonEnabled()
        } else {
            self.confirmButtonDisabled()
        }
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
         self.view.endEditing(true)
        return true
    }
}
