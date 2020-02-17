//
// Created by kim jason on 2018. 10. 2..
// Copyright (c) 2018 rootone. All rights reserved.
//

import Foundation
import Material

class DeviceManager {
    
    
    class func checkSmallDevice() -> Bool {
        //5s, 5, SE의 등의 스크린이 작은 단말일때 true를 보냅니다.
        let deviceModel = Devices.model
        switch deviceModel {
        case DeviceModels.iPhone4s,
             DeviceModels.iPhone5,
             DeviceModels.iPhone5c,
             DeviceModels.iPhone5s,
             DeviceModels.iPhoneSE:
            return true
            
        default:
            return false
        }
    }
    
    class func checkXDevice() -> Bool {
        //놋치 디자인의 X시리즈들 일경우 True를 보내줍니다
        let deviceModel = Devices.model
        switch deviceModel {
        case DeviceModels.iPhoneX,
             DeviceModels.iPhoneXs,
             DeviceModels.iPhoneXsMax,
             DeviceModels.iPhoneXR:
            return true
        default:
            return false
        }
    }
    
    class func checkHapticDevice() -> Bool {
        let deviceModel = Devices.model
        switch deviceModel {
        case DeviceModels.iPhone4s,
             DeviceModels.iPhone5,
             DeviceModels.iPhone5c,
             DeviceModels.iPhone5s,
             DeviceModels.iPhoneSE,
             DeviceModels.iPhone6s,
             DeviceModels.iPhone6,
             DeviceModels.iPhone6Plus,
             DeviceModels.iPhone6sPlus:
            return false
            
        default:
            return true
        }
    }
}
