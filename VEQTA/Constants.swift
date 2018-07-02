//
//  Constants.swift
//  VEQTA
//
//  Created by Cybermac002 on 28/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

struct Constants {
    
    //for dev
   static var MaterBaseUrl = "http://staging.multitvsolution.com:9004/automatorapi/v6/master/url_static/token/"
    
   // for production
  //   static var MaterBaseUrl = "http://veqta-api.multitvsolution.com/automatorapi/master/url_static/token/"
    
    static let APIV5 = "http://api.multitvsolution.com/automatorapi/v5/"
    static let SubscriptionBaseUrl =  "http://staging.multitvsolution.com:9002"

    
 
    

//    ////////////FOR PRODUCTION/////////////
   
   static let APP_Token = "58cfdeb8438eb/"
   static let APP_SOCIAL_Token = "58cfdeb8438eb"
   
    //////////FOR DEVLOPMENT/////////////
//  static let APP_Token = "584ab077cc9f8/"
//  static let APP_SOCIAL_Token = "584ab077cc9f8"
    
    static let widthBanner = "640"
    static let heightBanner = "360"
    static let widthOther = "480"
    static let heightOther = "270"
  
  //  static let widthBanner = "640"
  //  static let heightBanner = "360"
  //  static let qualityBanner = "50"
  //  static let widthDetail = "640"
  //  static let heightDetail = "360"
 //   static let width = "640"
  //  static let quality = "40"
  //  static let height = "360"
    //for development

    static let SkipDuration: Int = 300
     //for Live
    //58cfdeb8438eb  live
    static let APP_SECURE_SECERET_KEY = "mul123"
    static let APP_HEARTBEAt = "stream/applicationheartbeat/token/"
    
   //////for IAP/////////////
    static let appBundleId = "com.VeqtaLive"
   static let purchase1Suffix = RegisteredPurchase.purchase1
   static let purchase2Suffix = RegisteredPurchase.autoRenewablePurchase
    
}
