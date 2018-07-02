//
//  AFNetworkingWebServices.swift
//  IntexTvApp
//
//  Created by Cybermac002 on 01/03/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AFNetworking
import CryptoSwift

class AFNetworkingWebServices: NSObject
{
    func cancelOperation()  {
        let manager = AFHTTPSessionManager()
        manager.operationQueue.cancelAllOperations()
    }
    func postRequestAndGetResponse(urlString:NSString,param:NSDictionary,info:String)
    {
        //print("param>>>",param)
        let startTime = NSDate()
        let responseDict:NSMutableArray=NSMutableArray()
        let defaults = UserDefaults.standard
        _ = defaults.value(forKey: info)
        
        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        [manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")]
        let params = param
        // print("param>>>",urlString,param)
        manager.post(urlString as String, parameters:params, success:
            {
                
                requestOperation, response in
                
                do
                {
                    let responseTime = NSDate().timeIntervalSince(startTime as Date)
                    print("\("Response time in sec > ")\(responseTime)\("URL is > ")\(urlString)\("Param is ")\(param)")
                    let result = try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as? NSDictionary
                    // print("result>>>",result)
                    do {
                        //        print("signUp >>>",result)
                        if(!Common.isNotNull(object: result))
                        {
                            return
                        }
                        if result!["code"] as! Int == 1
                        {
                            
                            //   print("signUp >>>",result)
                            if info == "getFavBtnResponse" || info == "getLikeButtonResponse" || info == "getSignUpResponse" || info == "getForgotResponse" || info == "getVerifyResponse" || info == "getPaymentResponse" || info == "getPaymentLoginResponse" || info == "getPaymentOtpResponse" || info == "getFavRemoveResponse" || info == "getAnalyticsResponse" || info == "getSearchSugestResponse" || info == "getContactUsResponse" || info == "getAnalyticsLiveResponse" || info == "getPaymentSignUpResponse" || info == "userappsession" || info == "getHeartBeatResponse"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
                                )
                            }
                            else
                            {
                                  if info == "getOtpResult" || info == "getForgotResult"
                                {
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: nil)
                                }
                                else
                                {
 
                                    if info == "getLoginResponse" || info == "getOtpResponse" || info == "getFBLoginResponse" || info == "getFBSignUpResponse"
                                    {
                                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                                    }
                                    else if  info == "getAppSessionResponse"
                                    {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                                       
                                    }
                                    else
                                    {
                                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                                    }
                                }
                            }
                        }
                        else
                        {
                            //   print("signUp >>>",result)
                             if info == "getFavBtnResponse" || info == "getLikeButtonResponse" || info == "getSignUpResponse" || info == "getForgotResponse" || info == "getVerifyResponse"  || info == "getLoginResponse" || info == "getPaymentResponse" || info == "getPaymentLoginResponse" || info == "getPaymentOtpResponse" || info == "getFavRemoveResponse" || info == "getHeartBeatResponse" || info == "getAppSessionResponse" || info == "getAnalyticsResponse" || info == "getSearchSugestResponse" || info == "getContactUsResponse" || info == "getAnalyticsLiveResponse" || info == "getPaymentSignUpResponse" || info == "getFBLoginResponse" || info == "getversionchekResponse" || info == "userappsession"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                            }
                            else
                            {
                                if info == "getOtpResult" || info == "getForgotResult"
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: nil)
                                }
                                else if info == "getUpdateEditProfileResponse"
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                                }
                                else
                                {
                                    if info == "getOtpResponse"
                                    {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                                    }
                                    else
                                    {
                                        
                                        
                                        
                                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                                    }
                                    
                                }
                            }
                            
                        }
                        
                        
                    }
                }
                catch
                {
                }
                
        },
                     failure:
            {
                requestOperation, error in
                print(error)
        })
        
    }
    func getRequestAndHeartResponse(urlString:NSString,param:NSDictionary,info:String)
    {
        let startTime = NSDate()
        //print("param>>>",param)
        let responseDict:NSMutableArray=NSMutableArray()
        let defaults = UserDefaults.standard
        _ = defaults.value(forKey: info)
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        [manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")]
        let params = param
        // print("param>>>",urlString,param)
        manager.get(urlString as String, parameters:params, success:
            {
                
                requestOperation, response in
                
                do
                {
                    
                    
                    let result = try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as? NSDictionary
                    do {
                        //  print("signUp >>>",result)
                        
                        
                        let responseTime = NSDate().timeIntervalSince(startTime as Date)
                        print("\("Response time in sec > ")\(responseTime)\("URL is > ")\(urlString)\("Param is ")\(param)")
                        
                        if result!["code"] as! Int == 1
                        {
                            if(info == "getSearchSugestResponse")
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary)
                            }
                                
                            else if(info == "getHomeResponse" || info == "getDetailMoreResponse" || info == "getVideosDataResponse" || info == "getHomeNewsDataResponse" || info == "getListDataResponse" || info == "getListDataResponse" || info == "getSearchResponse" || info == "getSportsMoreDataResponse" || info == "getSportsDataResponse" || info == "getcatListResponse" || info == "getsportsShowResponse")
                            {
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result?.value(forKey: "result") as! NSDictionary)
                                
                                //                                let keyString = "0123456789abcdef0123456789abcdef"
                                //                                let message = result!["result"] as! String
                                //                                 let encode =  message.aesDecrypt(key: keyString)
                                //                                let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
                                //                                var dictHome:NSMutableDictionary=NSMutableDictionary()
                                //                                dictHome=jsonObject.mutableCopy() as! NSMutableDictionary
                                //                                //print("result>>>>>>\(dictHome)")
                                //                                 responseDict.add(dictHome)
                                //                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: jsonObject)
                                
                            }
                            else
                            {
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result?.value(forKey: "result") as! NSDictionary)
                                
                                //
                                //                                let keyString = "0123456789abcdef0123456789abcdef"
                                //                                let message = result!["result"] as! String
                                //                                let encode =  message.aesDecrypt(key: keyString)
                                //                                let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
                                //                                let dictHome:NSMutableDictionary=NSMutableDictionary()
                                //                                dictHome.setObject(jsonObject.mutableCopy() as! NSMutableDictionary, forKey: "result" as NSCopying)
                                //                                dictHome.setObject(result!["code"], forKey: "code" as NSCopying)
                                //                                responseDict.add(dictHome)
                                //                            //   print("result>>>>>>\(dictHome)")
                                //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: dictHome)
                            }
                            
                        }
                        else
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
                            )
                        }
                        
                        
                    }
                }
                catch
                {
                }
                
        },
                    failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
        
        
        
    }
    func getRequestAndGetResponse(urlString:NSString,param:NSDictionary,info:String)
    {
        //print("param>>>",param)
        let responseDict:NSMutableArray=NSMutableArray()
        let defaults = UserDefaults.standard
        _ = defaults.value(forKey: info)
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        [manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")]
        let params = param
        // print("param>>>",urlString,param)
        manager.get(urlString as String, parameters:params, success:
            {
                
                requestOperation, response in
                
                do
                {
                    let result = try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as? NSDictionary
                    do {
                        //  print("signUp >>>",result)
                        if result!["code"] as! Int == 1
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
                            )
                            
                        }
                        else
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
                            )
                        }
                        
                        
                    }
                }
                catch
                {
                }
                
        },
                    failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
        
        
        
    }
    
    
}

