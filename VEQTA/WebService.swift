//
//  WebService.swift
//  EPG
//
//  Created by SSCyberlinks on 13/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import CryptoSwift
import Foundation
class WebService: NSObject,URLSessionDataDelegate {
    
     /*
     
     */
    
    func postRequestAndGetResponse(urlString:NSString,param:NSDictionary,info:String)
    {
        let responseDict:NSMutableArray=NSMutableArray()
       // print(name)
        
        do {
            let url = NSURL(string: urlString as String)!
            //let request = NSMutableURLRequest(url: url as URL)
            //Create request with caching policy
             let jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            var request = URLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
           
            /*
             request.HTTPMethod = "POST"
             request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
             request.HTTPBody = jsonData
             */
            
            request.httpBody = jsonData
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            //Get cache response using request object
            print("request >>>>",request)
            let cacheResponse = URLCache.shared.cachedResponse(for: request as URLRequest)
            
            //check if cached response is available if nil then hit url for data
            if cacheResponse == nil
            {
                //default configuration
                let config = URLSessionConfiguration.default
                
                //Enable url cache in session configuration and assign capacity
                config.urlCache = URLCache.shared
                let cacheDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let dir = cacheDirectory.appendingFormat("URLCache")
                print("dir >>>",dir)
                let cacheSizeMemory = 20 * 1024 * 1024
                let cacheSizeDisk = 100 * 1024 * 1024
                config.urlCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: dir)
                
                //create session with configration
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                
                //create data task to download data and having completion handler
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    //below two lines will cache the data, request object as key
                    let cacheResponse = CachedURLResponse(response: response!, data: data!)
                    URLCache.shared.storeCachedResponse(cacheResponse, for: request as URLRequest)
                    self.completed(cachedURLResponse: cacheResponse)
                })
                
                task.resume()
            }
            else
            {
                //if cache response is not nil then print
               // let string = NSString(data: cacheResponse!.data, encoding: String.Encoding.utf8.rawValue)
            //    println(string)
                self.completed(cachedURLResponse: cacheResponse!)
                
            }
            
            
            
            
            
            
            // return task
            
            
            
        }
        catch {
            print(error)
        }
        
    }
    func completed(cachedURLResponse:CachedURLResponse)
   {
     let responseDict:NSMutableArray=NSMutableArray()
    do
    {
        let result = try JSONSerialization.jsonObject(with: (cachedURLResponse.data) as Data, options: []) as? NSDictionary
        let keyString = "0123456789abcdef0123456789abcdef"
        let message = result!["result"] as! String
        let encode =  message.aesDecrypt(key: keyString)
        let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        dictHome=jsonObject.mutableCopy() as! NSMutableDictionary
        //   print("result>>>>>>\(dictHome)")
        
        responseDict.add(dictHome)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getListDataResponse"), object: jsonObject)
    }
    catch
    {
        print("catch")
    }
    
    }
}
