//
//  WKPlayWebViewController.swift
//  Bitberry
//
//  Created by Daniel Kim on 2018. 6. 8..
//  Copyright © 2018년 rootone. All rights reserved.
//

import Foundation
import Material
import UIKit
import WebKit
import SnapKit
import Motion
import Localize_Swift
import SVProgressHUD

class PlayWebViewController: UIViewController {
    
    fileprivate var webView = WKWebView()
    
    var titleStr = ""
    var url = ""
    var isWhite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isMotionEnabled = true
        motionTransitionType = .autoReverse(presenting: .cover(direction: .up))
        prepareWebView()
        
//        if (isWhite) {
//            log?.debug("isWhite!!!")
//            self.navigationController?.navigationBar.backgroundColor = WhiteColor
//            self.navigationController?.navigationBar.dividerColor = .none
//        }
    
        initView()
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (isWhite) {
            log?.debug("isWhite!!!")
            self.navigationController?.navigationBar.dividerColor = .none
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
}


extension PlayWebViewController {
    
    fileprivate func initView() {
        self.view.addSubview(webView)
        self.prepareNavigation()
        webView.snp.makeConstraints { m in
            m.bottom.left.right.equalToSuperview()
            m.top.equalToSuperview().offset(xTopOffset)
        }
        self.loadUrl(url: self.url)
    }
    
    fileprivate func prepareNavigation() {
        var deleteButton: IconButton!
        
        navigationController?.navigationBar.backgroundColor = MainBackGroundColor
        navigationController?.navigationBar.tintColor = RedColor
        navigationController?.navigationItem.title = "BitBerryConnect"
        self.view.backgroundColor = MainBackGroundColor
        
        deleteButton = IconButton(image: UIImage(named: "titlebar_close_24x24_"))
        deleteButton.addTarget(self, action: #selector(clickedClosebutton), for: .touchUpInside)
        
        self.navigationItem.titleLabel.textColor = WhiteColor
        self.navigationItem.titleLabel.text = "예고편 & Clips"
        self.navigationItem.rightViews = [deleteButton]
    }
    
    @objc func clickedClosebutton() {
        self.dismiss(animated: true)
    }
    
    
    fileprivate func prepareWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.uiDelegate = self
        webView.scrollView.contentInset = .zero
        automaticallyAdjustsScrollViewInsets = true
    }
    
    
    fileprivate func loadUrl(url: String) {
        var request = URLRequest(url: URL(string: url)!)
        self.webView.load(request)
    }
    
}

extension PlayWebViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //후에 JSBridge 여기기다가 만들것 :)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        log?.debug("navigation title: \(String(describing: navigationAction.request.url?.absoluteString))")
        decisionHandler(.allow)
//        if navigationAction.request.url?.scheme == "bitberry" {
//            self.navigationController?.popViewController(animated: true)
//            decisionHandler(.cancel)
//        } else {
//            log?.debug("url is... : \(navigationAction.request.url!)")
//            if (navigationAction.request.url?.scheme == "app") {
//                if navigationAction.request.url?.host == "navigation" {
//                    let url = navigationAction.request.url
//                    let title = self.getQueryStringParameter(url: (url?.absoluteString)!, param: "title")
//                    if (title != nil) {
//                        log?.debug("wow navigation is Changed!!")
//                    }
//                    decisionHandler(.cancel)
//                }
//            } else {
//                if let url = navigationAction.request.url?.absoluteString {
//                    if(self.isOutPage(url: url)) {
//                        decisionHandler(.cancel)
//                        guard let url = URL(string: url) else { return }
//                        UIApplication.shared.open(url)
//                    } else {
//                        decisionHandler(.allow)
//                    }
//                }
//                log?.debug("wow navigation is not Changed!!")
//                //                decisionHandler(.allow)
//            }
//        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
             SVProgressHUD.dismiss()
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else {
            return nil
        }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}


extension PlayWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "cancel".localized(), style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isOutPage(url:String) -> Bool {
        //다날 페이지 / 비트베리 / 루트원 페이지는 우리 앱에서 떠야 합니다.
        return true
    }
}


