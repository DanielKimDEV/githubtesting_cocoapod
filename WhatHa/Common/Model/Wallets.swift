//
//  Wallets.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import ObjectMapper

class Wallets:NSObject, Mappable {
    
    var items:[Wallet]?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        items <- map["items"]
    }
    
}


class Wallet:NSObject, Mappable {
    
    var id:String?
    var address:String?
    var name:String?
    var currencyCode:String?
    var currencyDes:String?
    var imageUrl:String?
    var balance:String?
    var balanceInFiat:String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        id <- map["id"]
        address <- map["address"]
        name <- map["name"]
        currencyCode <- map["currency_code"]
        currencyDes <- map["currency_description"]
        imageUrl <- map["image_url"]
        balance <- map["balance"]
        balanceInFiat <- map["balance_in_fiat"]
    }
}
