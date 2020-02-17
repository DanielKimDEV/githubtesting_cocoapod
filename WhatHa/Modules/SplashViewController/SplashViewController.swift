//
//  SplashViewController.swift
//  WhatHa
//
//  Created by kim jason on 14/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import RevealingSplashView
import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color

    }
    
    fileprivate func showMain() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
        self.present(vc, animated: true)
    
    }
    
}
