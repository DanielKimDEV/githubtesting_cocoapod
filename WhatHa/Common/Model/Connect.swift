//
//  Connect.swift
//  WhatHa
//
//  Created by kim jason on 10/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import ObjectMapper


class Connect:NSObject, Mappable {
    
    var code:String?
    var isMember:String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        code <- map["code"]
        isMember <- map["is_member"]
    }
    
}

class Verify:NSObject, Mappable {
    
    var status:String?
    var token:String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        status <- map["status"]
        token <- map["token"]
    }
    
}
