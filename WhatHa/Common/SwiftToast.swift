//
//  SwiftToast.swift
//  WhatHa
//
//  Created by kim jason on 11/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import Toast_Swift

//@Deprecated
//BaseViewConmponent로 옮겼으므로 더이상 하용 하지 않습니다.
class SwiftToast {
    
    //Default Bottom
    public class func showSwiftToast(message:String,duration:Double,vc:UIViewController) {
        vc.self.view.makeToast(message,duration:duration,position:.bottom)
    }
    
    
    public class func showSwiftToastTop(message:String,duration:Double,vc:UIViewController) {
        vc.self.view.makeToast(message,duration:duration,position:.top)
    }
    
    public class func showSwiftToastImage(message:String,duration:Double,vc:UIViewController, image:UIImage) {
        vc.self.view.makeToast(message,duration:duration,position:.top,image:image)
    }
    
}
