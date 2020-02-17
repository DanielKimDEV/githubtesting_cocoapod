//
//  AirDrop.swift
//  WhatHa
//
//  Created by kim jason on 19/02/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import ObjectMapper

class AirDrop:NSObject, Mappable {
    
    var id:String?
    var status:String?
    var currencyCode:String?
    var amount:String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        self.id <- map["id"]
        self.status <- map["status"]
        self.currencyCode <- map["currency_code"]
        self.amount <- map["amount"]
    }
    
}
