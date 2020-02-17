//
//  NetworkManager.swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireObjectMapper

class NetworkManager {

    class func getHeaders() -> HTTPHeaders {
        return [
            "Authorization": "Bearer " + APIKEY,
        ]
      }
    
    class func getHeadersWithToken()  -> HTTPHeaders {
        let token = UserDefaults.UserData.string(forKey: .UserToken)
        log?.debug("token is:\(token)")
        return [
            "Authorization": "Bearer " + APIKEY,
            "X-Partner-User-Token": token,
        ]
    }
    
    
class func requestBitBerryConnect(thirdPartyID:String, completionCallBack:String, phoneNumber:String,
                            completion: @escaping (Int?, Connect?, Bool, String?) -> Void) {

        let loginApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/users/connect"
    log?.debug("phone number is \(phoneNumber)")
    var params = [:] as [String:String]
    if(phoneNumber.count > 0) {
        log?.debug("connect is with phone Number")
        params = [
            "third_party_uid":thirdPartyID,
            "completion_callback_url":completionCallBack,
            "phone_number":phoneNumber,
        ]
    } else {
        log?.debug("connect is with out phone Number")
        params = [
            "third_party_uid":thirdPartyID,
            "completion_callback_url":completionCallBack,
        ]
    }
    
    let headers = self.getHeaders()

        let method = HTTPMethod.post

        Alamofire.request(loginApiUrl,
            method: method,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseObject { (response: DataResponse<Connect>) in
                
                log?.debug("response: \n url : " + loginApiUrl)
                log?.debug("\n result: " + response.result.description)
                var errData: String = ""
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    log?.debug("Data: \(utf8Text)")
                }
                
                let statusCode = response.response?.statusCode
                let isSuccess = response.result.isSuccess
                let account = response.result.value
                if (isSuccess) {
                    if (account != nil) {
                        completion(statusCode, account!, true, errData)
                    }
                } else {
                    completion(statusCode, nil, false, errData)
                }
        }
    }
    
    class func requestBitBerryVerifyConnect(code:String,   completion: @escaping (Int?, Verify?, Bool, String?) -> Void) {
        let codeSplit = code.replacingOccurrences(of: "-", with: "")
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/users/connected?code=\(codeSplit)"
        let headers = self.getHeaders()
        
        let method = HTTPMethod.get
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          encoding: JSONEncoding.default,
                          headers: headers).responseObject { (response: DataResponse<Verify>) in
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.result.description)
                            var errData: String = ""
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                            }
                            
                            let statusCode = response.response?.statusCode
                            let isSuccess = response.result.isSuccess
                            let account = response.result.value
                            if (isSuccess) {
                                if (account != nil) {
                                    completion(statusCode, account!, true, errData)
                                }
                            } else {
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    
    class func requestBitBerryDisConnet(completion: @escaping (Int?, String?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/users/disconnect"
        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.post
        
        Alamofire.request(verifyApiUrl,
            method: method,
            encoding: JSONEncoding.default,
            headers: headers).responseString {
                (response) in
                
                var errData: String = ""
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    log?.debug("Data: \(utf8Text)")
                    errData = utf8Text
                }
                
                log?.debug("response: \n url : " + verifyApiUrl)
                log?.debug("\n result: " + response.description)
                
                let statusCode = response.response?.statusCode
                log?.debug("status Code is \(statusCode)")
                if (response.description.contains("SUCCESS")) {
                    log?.debug("is Success")
                    let data = response.result.value
                    completion(statusCode, data, true, errData)
                } else {
                    log?.debug("is Failed")
                    completion(statusCode, nil, false, errData)
                }
        }
    }
    
    class func requestWallets(cursorID:String = "", count:String = "", completion: @escaping (Int?, Wallets?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/wallets"

        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.get
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          encoding: JSONEncoding.default,
                          headers: headers).responseObject { (response: DataResponse<Wallets>) in
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.result.description)
                            var errData: String = ""
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                            }
                            
                            let statusCode = response.response?.statusCode
                            let isSuccess = response.result.isSuccess
                            let account = response.result.value
                            if (isSuccess) {
                                if (account != nil) {
                                    completion(statusCode, account!, true, errData)
                                }
                            } else {
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    class func requestWalletAddress(walletId:String, completion: @escaping (Int?, WalletAddress?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/wallets/\(walletId)/address"
        
        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.post
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          encoding: JSONEncoding.default,
                          headers: headers).responseObject { (response: DataResponse<WalletAddress>) in
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.result.description)
                            var errData: String = ""
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                            }
                            
                            let statusCode = response.response?.statusCode
                            let isSuccess = response.result.isSuccess
                            let account = response.result.value
                            if (isSuccess) {
                                if (account != nil) {
                                    completion(statusCode, account!, true, errData)
                                }
                            } else {
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    
    class func requestTransferWithdraw(walletId:String,
                                       amount:Double,
                                       orderId:String,
                                       itemName:String,
                                       category:String,
                                       completion: @escaping (Int?, TransferRequest?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/wallets/\(walletId)/transfer_requests/withdraw"
        
        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.post
        
        let params = [
            "amount":amount,
            "order_id":orderId,
            "item_name":itemName,
            "order_type":category,
            ] as [String : Any]
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          parameters:params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseObject { (response: DataResponse<TransferRequest>) in
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.result.description)
                            var errData: String = ""
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                            }
                            
                            let statusCode = response.response?.statusCode
                            let isSuccess = response.result.isSuccess
                            let account = response.result.value
                            if (isSuccess) {
                                if (account != nil) {
                                    completion(statusCode, account!, true, errData)
                                }
                            } else {
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    
    class func requestBalance(completion: @escaping (Int?, String?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/wallets/balance"
        
        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.get
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          encoding: JSONEncoding.default,
                          headers: headers).responseString {
                            (response) in
                            
                            var errData: String = ""
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                                errData = utf8Text
                            }
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.description)
                            
                            let statusCode = response.response?.statusCode
                            log?.debug("status Code is \(statusCode)")
                            if (response.description.contains("SUCCESS")) {
                                log?.debug("is Success")
                                let data = response.result.value
                                completion(statusCode, data, true, errData)
                            } else {
                                log?.debug("is Failed")
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    
    
    class func requestWithdrawDone(transferRequest:String,
                                       completion: @escaping (Int?, PartnerTranferRequest?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/transfer_requests/\(transferRequest)"
        
 
        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.get
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          encoding: JSONEncoding.default,
                          headers: headers).responseObject { (response: DataResponse<PartnerTranferRequest>) in
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.result.description)
                            var errData: String = ""
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                            }
                            
                            let statusCode = response.response?.statusCode
                            let isSuccess = response.result.isSuccess
                            let account = response.result.value
                            if (isSuccess) {
                                if (account != nil) {
                                    completion(statusCode, account!, true, errData)
                                }
                            } else {
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    class func requestWithdrawCancel(transferRequest:String,
                                   completion: @escaping (Int?, String?, Bool, String?) -> Void) {
        
        let verifyApiUrl = "https://bitberry.alpha.rootone.com/partner_api/v2/transfer_requests/\(transferRequest)/cancel"
        
        
        let headers = self.getHeadersWithToken()
        
        let method = HTTPMethod.post
        
        Alamofire.request(verifyApiUrl,
                          method: method,
                          encoding: JSONEncoding.default,
                          headers: headers).responseString {
                            (response) in
                            
                            var errData: String = ""
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                                errData = utf8Text
                            }
                            
                            log?.debug("response: \n url : " + verifyApiUrl)
                            log?.debug("\n result: " + response.description)
                            
                            let statusCode = response.response?.statusCode
                            log?.debug("status Code is \(statusCode)")
                            if (response.description.contains("SUCCESS")) {
                                log?.debug("is Success")
                                let data = response.result.value
                                completion(statusCode, data, true, errData)
                            } else {
                                log?.debug("is Failed")
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
    
    class func requestAirdrop(walletId:String, amount:String, phoneNumber:String,
                                     completion: @escaping (Int?, AirDrop?, Bool, String?) -> Void) {
        
        let requestAirdrop = "https://bitberry.alpha.rootone.com/partner_api/v2/wallets/\(walletId)/airdrop"
        
        
        let headers = self.getHeaders()
        
        let method = HTTPMethod.post
        
        let params = [
            "amount":amount,
            "phone_number":phoneNumber,
            ] as [String : String]
        
        Alamofire.request(requestAirdrop,
                          method: method,
                          parameters:params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseObject { (response: DataResponse<AirDrop>) in
                            
                            log?.debug("response: \n url : " + requestAirdrop)
                            log?.debug("\n result: " + response.result.description)
                            var errData: String = ""
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                log?.debug("Data: \(utf8Text)")
                            }
                            
                            let statusCode = response.response?.statusCode
                            let isSuccess = response.result.isSuccess
                            let result = response.result.value
                            if (isSuccess) {
                                if (result != nil && result!.id != nil) {
                                    completion(statusCode, result!, true, errData)
                                }
                            } else {
                                completion(statusCode, nil, false, errData)
                            }
        }
    }
}

