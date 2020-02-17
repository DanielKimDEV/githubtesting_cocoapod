//
//  CheckAccountViewController.swft
//  WhatHa
//
//  Created by kim jason on 11/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation


import UIKit
import Material


class CheckAccountViewController: UIViewController {
    
    
    var checkWallet:RaisedButton!
    var checkAddress:RaisedButton!
    var callWithdraw:RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViews()
    }
    
    

}

extension CheckAccountViewController {
    
    fileprivate func prepareViews() {
        checkWallet = getRaisedButton(title: "지갑체크", color: RealBlackColor)
        checkWallet.addTarget(self, action: #selector(clickedCheckButton), for: .touchUpInside)

    }
    
    
}



extension CheckAccountViewController {
    
    @objc
    fileprivate func clickedCheckButton() {
        log?.debug( "checkClickedButton")
        
    }
    
    
    @objc
    fileprivate func clickedCalladdress() {
        log?.debug("check Address")
        
    }
}
