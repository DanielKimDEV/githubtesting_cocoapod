//
//  WalletAddress.swift
//  WhatHa
//
//  Created by kim jason on 16/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletAddress:NSObject, Mappable {
    
    
    var currency_code:String?
    var address:String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        currency_code <- map["currency_code"]
        address <- map["address"]
    }
    
}


class TransferRequest:NSObject, Mappable {
    
    var id:String?
    var eventType: String?
    var status: String?
    var pendingAuthTypes:[String]?
    
    var currencyCode: String?
    
    var withdrawMinAmount: String?
    var withdrawMaxAmount: String?
    var withdrawLimitDes: String?
//    var fee: Fee?
    var feeTooltip: String?
    var feeInsufficient:String?
    
    var decimalPlace: Int?
    
    var exchangeRateCurrencyCode:String?
    var exchangeRate: String?
    
    var toUserNickName: String?
    var canRaiseSecurityLevel:Bool?
    
    // error
    var displayMessage:String?
    
    var deepLinkUrl:String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        id <- map["id"]
        eventType <- map["event_type"]
        status <- map["status"]
        pendingAuthTypes <- map["pending_auth_types"]
        currencyCode <- map["currency_code"]
        withdrawMinAmount <- map["withdraw_min_amount"]
        withdrawMaxAmount <- map["withdraw_max_amount"]
        withdrawLimitDes <- map["withdraw_limit_description"]
//        fee <- map["fee"]
        feeTooltip <- map["fee_tooltip"]
        feeInsufficient <- map["fee_insufficient"]
        decimalPlace <- map["decimal_places"]
        exchangeRateCurrencyCode <- map["exchange_rate_currency_code"]
        exchangeRate <- map["exchange_rate"]
        toUserNickName <- map["to_user_nickname"]
        canRaiseSecurityLevel <- map["can_raise_security_level"]
        displayMessage <- map["display_message"]
        deepLinkUrl <- map["deep_link_url"]
    }
}


class PartnerTranferRequest:NSObject, Mappable {
    
    var id:String?
    var eventType: String?
    var status: String?

    
    var currencyCode: String?
    var amount:String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //Mappable
    func mapping(map: Map) {
        id <- map["id"]
        eventType <- map["event_type"]
        status <- map["status"]

        currencyCode <- map["currency_code"]
        amount <- map["amount"]
    }
}
