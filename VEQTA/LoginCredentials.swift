//
//  LoginCredentials.swift
//  Magento App
//
//  Created by unify on 3/16/16.
//  Copyright © 2016 unify. All rights reserved.
//

import UIKit

class LoginCredentials: NSObject {

    
   
     
    static var Videoid: String {
        get {
            
            if let videoid = UserDefaults.standard.object(forKey: "videoid") as? String {
                return videoid
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "videoid")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var PlayType: String {
        get {
            
            if let playType = UserDefaults.standard.object(forKey: "playType") as? String {
                return playType
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playType")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var Livebuffertime: Int {
        get {
            
            if let livebuffertime = UserDefaults.standard.object(forKey: "livebuffertime") as? Int {
                return livebuffertime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "livebuffertime")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var VideoPlayingtime: Int {
        get {
            
            if let videoPlayingtime = UserDefaults.standard.object(forKey: "videoPlayingtime") as? Int {
                return videoPlayingtime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "videoPlayingtime")
            UserDefaults.standard.synchronize()
        }
    }
  
    
    
    static var Issociallogin: Bool {
        get {
            
            if let issociallogin = UserDefaults.standard.object(forKey: "issociallogin") as? Bool
            {
                return  issociallogin
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "issociallogin")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var Usagrrement: Bool {
        get {
            
            if let usagrrement = UserDefaults.standard.object(forKey: "usagrrement") as? Bool
            {
                return  usagrrement
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "usagrrement")
            UserDefaults.standard.synchronize()
        }
    }

    
    
    
    
    
    
    
    
    static var BaseUrl: String {
        get {
            
            if let baseUrl = UserDefaults.standard.object(forKey: "BaseUrl") as? String {
                return baseUrl
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "BaseUrl")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var CDNBaseUrl: String {
        get {
            
            if let cdnBaseUrl = UserDefaults.standard.object(forKey: "CDNBaseUrl") as? String {
                return cdnBaseUrl
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CDNBaseUrl")
            UserDefaults.standard.synchronize()
        }
    }
    
  
    static var AnalyticsBaseUrl: String {
        get {
            
            if let analyticsBaseUrl = UserDefaults.standard.object(forKey: "AnalyticsBaseUrl") as? String {
                return analyticsBaseUrl
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AnalyticsBaseUrl")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var Notificationveryfyurl: String {
        get {
            
            if let notificationveryfyurl = UserDefaults.standard.object(forKey: "Notificationveryfyurl") as? String {
                return notificationveryfyurl
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Notificationveryfyurl")
            UserDefaults.standard.synchronize()
        }
    }
    static var Appversion: String {
        get {
            
            if let appversion = UserDefaults.standard.object(forKey: "Appversion") as? String {
                return appversion
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Appversion")
            UserDefaults.standard.synchronize()
        }
    }
    
  
    
    
    
    
    //////////////// ALL API LIST FROM API////////////////////////////////////////////
    
    
    //////////Udatedevice------ 1-----------/////////////
    
    static var Udatedeviceapi: String {
        get {
            
            if let udatedevice = UserDefaults.standard.object(forKey: "udatedevice") as? String {
                return udatedevice
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "udatedevice")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptUdatedeviceapi: Bool {
        get {
            
            if let isencriptUdatedeviceapi = UserDefaults.standard.object(forKey: "isencriptUdatedeviceapi") as? Bool
            {
                return  isencriptUdatedeviceapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptUdatedeviceapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Deviceinfoe------ 2-----------/////////////
    
    static var Deviceinfoapi: String {
        get {
            
            if let deviceinfo = UserDefaults.standard.object(forKey: "deviceinfo") as? String {
                return deviceinfo
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "deviceinfo")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptDeviceinfoapi: Bool {
        get {
            
            if let isencriptDeviceinfoapi = UserDefaults.standard.object(forKey: "isencriptDeviceinfoapi") as? Bool
            {
                return isencriptDeviceinfoapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptDeviceinfoapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    //////////Versione------ 3-----------/////////////
    
    static var AppVersionAPi: String {
        get {
            
            if let appVersionAPi = UserDefaults.standard.object(forKey: "appVersionAPi") as? String {
                return appVersionAPi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appVersionAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptAppVersionAPi: Bool {
        get {
            
            if let isencriptAppVersionAPi = UserDefaults.standard.object(forKey: "isencriptAppVersionAPi") as? Bool
            {
                return isencriptAppVersionAPi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptAppVersionAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    
    //////////Version_checke------ 4-----------/////////////
    
    static var Versioncheckapi: String {
        get {
            
            if let versioncheck = UserDefaults.standard.object(forKey: "versioncheck") as? String {
                return versioncheck
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "versioncheck")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptVersioncheckapi: Bool {
        get {
            
            if let isencriptVersioncheckapi = UserDefaults.standard.object(forKey: "isencriptVersioncheckapi") as? Bool
            {
                return isencriptVersioncheckapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptVersioncheckapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    //////////SocialAPIe------ 5-----------/////////////
    static var SocialAPI: String {
        get {
            
            if let socialAPI = UserDefaults.standard.object(forKey: "socialAPI") as? String {
                return socialAPI
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "socialAPI")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptSocialAPI: Bool {
        get {
            
            if let isencriptSocialAPI = UserDefaults.standard.object(forKey: "isencriptSocialAPI") as? Bool
            {
                return isencriptSocialAPI
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptSocialAPI")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    //////////LoginAPIe------ 6-----------/////////////
    static var LoginAPI: String {
        get {
            
            if let loginAPI = UserDefaults.standard.object(forKey: "loginAPI") as? String {
                return loginAPI
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "loginAPI")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    static var IsencriptLoginAPI: Bool {
        get {
            
            if let isencriptLoginAPI = UserDefaults.standard.object(forKey: "isencriptLoginAPI") as? Bool
            {
                return isencriptLoginAPI
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptLoginAPI")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////AddAPie------ 7-----------/////////////
    static var AddAPi: String {
        get {
            
            if let addAPi = UserDefaults.standard.object(forKey: "addAPi") as? String {
                return addAPi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "addAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptAddAPi: Bool {
        get {
            
            if let isencriptAddAPi = UserDefaults.standard.object(forKey: "isencriptAddAPi") as? Bool
            {
                return isencriptAddAPi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptAddAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    //////////Forgote------ 8-----------/////////////
    static var Forgotapi: String {
        get {
            
            if let forgotapi = UserDefaults.standard.object(forKey: "forgotapi") as? String {
                return forgotapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "forgotapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptForgotapi: Bool {
        get {
            
            if let isencriptForgotapi = UserDefaults.standard.object(forKey: "isencriptForgotapi") as? Bool
            {
                return isencriptForgotapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptForgotapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////otp_generatee------ 9-----------/////////////
    static var Otpgenerateapi: String {
        get {
            
            if let otpgenerate = UserDefaults.standard.object(forKey: "otpgenerate") as? String {
                return otpgenerate
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "otpgenerate")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptOtpgenerateapi: Bool {
        get {
            
            if let isencriptOtpgenerateapi = UserDefaults.standard.object(forKey: "isencriptOtpgenerateapi") as? Bool
            {
                return isencriptOtpgenerateapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptOtpgenerateapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Verify_otpe------ 10-----------/////////////
    static var Verifyotpapi: String {
        get {
            
            if let verifyotp = UserDefaults.standard.object(forKey: "verifyotp") as? String {
                return verifyotp
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "verifyotp")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptVerifyotpapi: Bool {
        get {
            
            if let isencriptVerifyotpapi = UserDefaults.standard.object(forKey: "isencriptVerifyotpapi") as? Bool
            {
                return isencriptVerifyotpapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptVerifyotpapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////MenuAPie------ 11-----------/////////////
    static var MenuAPi: String {
        get {
            
            if let menuAPi = UserDefaults.standard.object(forKey: "menuAPi") as? String {
                return menuAPi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "menuAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptMenuAPi: Bool {
        get {
            
            if let isencriptMenuAPi = UserDefaults.standard.object(forKey: "isencriptMenuAPi") as? Bool
            {
                return isencriptMenuAPi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptMenuAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Catliste------ 12-----------/////////////
    static var catlistapi: String {
        get {
            
            if let catlist = UserDefaults.standard.object(forKey: "catlist") as? String {
                return catlist
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "catlist")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var Isencriptcatlistapi: Bool {
        get {
            
            if let isencriptcatlistapi = UserDefaults.standard.object(forKey: "isencriptcatlistapi") as? Bool
            {
                return isencriptcatlistapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptcatlistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Homeapie------ 13-----------/////////////
    static var Homeapi: String {
        get {
            
            if let homeapi = UserDefaults.standard.object(forKey: "homeapi") as? String {
                return homeapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "homeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptHomeapi: Bool {
        get {
            
            if let isencriptHomeapi = UserDefaults.standard.object(forKey: "isencriptHomeapi") as? Bool
            {
                return isencriptHomeapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptHomeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Listapie------ 14-----------/////////////
    static var Listapi: String {
        get {
            
            if let listapi = UserDefaults.standard.object(forKey: "listapi") as? String {
                return listapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "listapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptListapi: Bool {
        get {
            
            if let isencriptListapi = UserDefaults.standard.object(forKey: "isencriptListapi") as? Bool
            {
                return isencriptListapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptListapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    //////////Detailapie------ 15-----------/////////////
    static var Detailapi: String {
        get {
            
            if let detailapi = UserDefaults.standard.object(forKey: "detailapi") as? String {
                return detailapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "detailapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptDetailapi: Bool {
        get {
            
            if let isencriptDetailapi = UserDefaults.standard.object(forKey: "isencriptDetailapi") as? Bool
            {
                return isencriptDetailapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptDetailapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Userbehaviorapie------ 16-----------/////////////
    static var Userbehaviorapi: String {
        get {
            
            if let userbehaviorapi = UserDefaults.standard.object(forKey: "userbehaviorapi") as? String {
                return userbehaviorapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userbehaviorapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptUserbehaviorapi: Bool {
        get {
            
            if let isencriptUserbehaviorapi = UserDefaults.standard.object(forKey: "isencriptUserbehaviorapi") as? Bool
            {
                return isencriptUserbehaviorapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptUserbehaviorapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Recomendedapie------ 17-----------/////////////
    static var Recomendedapi: String {
        get {
            
            if let recomendedapi = UserDefaults.standard.object(forKey: "recomendedapi") as? String {
                return recomendedapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "recomendedapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptRecomendedapi: Bool {
        get {
            
            if let isencriptRecomendedapi = UserDefaults.standard.object(forKey: "isencriptRecomendedapi") as? Bool
            {
                return isencriptRecomendedapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptRecomendedapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Likeapie------ 18-----------/////////////
    static var Likeapi: String {
        get {
            
            if let likeapi = UserDefaults.standard.object(forKey: "likeapi") as? String {
                return likeapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "likeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptLikeapi: Bool {
        get {
            
            if let isencriptLikeapi = UserDefaults.standard.object(forKey: "isencriptLikeapi") as? Bool
            {
                return isencriptLikeapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptLikeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Dislikeapie------ 19-----------/////////////
    static var Dislikeapi: String {
        get {
            
            if let dislikeapi = UserDefaults.standard.object(forKey: "dislikeapi") as? String {
                return dislikeapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dislikeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IsencriptDislikeapi: Bool {
        get {
            
            if let isencriptDislikeapi = UserDefaults.standard.object(forKey: "isencriptDislikeapi") as? Bool
            {
                return isencriptDislikeapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptDislikeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Subscribeapie------ 20-----------/////////////
    static var Subscribeapi: String {
        get {
            
            if let subscribeapi = UserDefaults.standard.object(forKey: "subscribeapi") as? String {
                return subscribeapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subscribeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptSubscribeapi: Bool {
        get {
            
            if let isencriptSubscribeapi = UserDefaults.standard.object(forKey: "isencriptSubscribeapi") as? Bool
            {
                return isencriptSubscribeapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptSubscribeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Unsubscribeapi------ 21-----------/////////////
    static var Unsubscribeapi: String {
        get {
            
            if let unsubscribeapi = UserDefaults.standard.object(forKey: "unsubscribeapi") as? String {
                return unsubscribeapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "unsubscribeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptUnsubscribeapi: Bool {
        get {
            
            if let isencriptUnsubscribeapi = UserDefaults.standard.object(forKey: "isencriptUnsubscribeapi") as? Bool
            {
                return isencriptUnsubscribeapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptUnsubscribeapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Commentlistapi------ 22-----------/////////////
    static var Commentlistapi: String {
        get {
            
            if let commentlistapi = UserDefaults.standard.object(forKey: "commentlistapi") as? String {
                return commentlistapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "commentlistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptCommentlistapi: Bool {
        get {
            
            if let isencriptCommentlistapi = UserDefaults.standard.object(forKey: "isencriptCommentlistapi") as? Bool
            {
                return isencriptCommentlistapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptCommentlistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    //////////CommentaddAPi------ 23-----------/////////////
    static var CommentaddAPi: String {
        get {
            
            if let commentaddAPi = UserDefaults.standard.object(forKey: "commentaddAPi") as? String {
                return commentaddAPi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "commentaddAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    static var IsencriptCommentaddAPi: Bool {
        get {
            
            if let isencriptCommentaddAPi = UserDefaults.standard.object(forKey: "isencriptCommentaddAPi") as? Bool
            {
                return isencriptCommentaddAPi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptCommentaddAPi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Ratingapi------ 24-----------/////////////
    static var Ratingapi: String {
        get {
            
            if let ratingapi = UserDefaults.standard.object(forKey: "ratingapi") as? String {
                return ratingapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ratingapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptRatingapi: Bool {
        get {
            
            if let isencriptRatingapi = UserDefaults.standard.object(forKey: "isencriptRatingapi") as? Bool
            {
                return isencriptRatingapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptRatingapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Playlistapi------ 25----------/////////////
    static var Playlistapi: String {
        get {
            
            if let playlistapi = UserDefaults.standard.object(forKey: "playlistapi") as? String {
                return playlistapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playlistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptPlaylistapi: Bool {
        get {
            
            if let isencriptPlaylistapi = UserDefaults.standard.object(forKey: "isencriptPlaylistapi") as? Bool
            {
                return isencriptPlaylistapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptPlaylistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    //////////Watchdurationapi------ 26-----------/////////////
    static var watchdurationapi: String {
        get {
            
            if let watchdurationapi = UserDefaults.standard.object(forKey: "watchdurationapi") as? String {
                return watchdurationapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "watchdurationapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var Isencriptwatchdurationapi: Bool {
        get {
            
            if let isencriptwatchdurationapi = UserDefaults.standard.object(forKey: "isencriptwatchdurationapi") as? Bool
            {
                return isencriptwatchdurationapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptwatchdurationapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Userrelatedapi------ 27-----------/////////////
    static var Userrelatedapi: String {
        get {
            
            if let userrelatedapi = UserDefaults.standard.object(forKey: "userrelatedapi") as? String {
                return userrelatedapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userrelatedapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    static var IsencriptUserrelatedapi: Bool {
        get {
            
            if let isencriptUserrelatedapi = UserDefaults.standard.object(forKey: "isencriptUserrelatedapi") as? Bool
            {
                return isencriptUserrelatedapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptUserrelatedapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    //////////Editapi------ 28-----------/////////////
    static var Editapi: String {
        get {
            
            if let editapi = UserDefaults.standard.object(forKey: "editapi") as? String {
                return editapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "editapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptEditapi: Bool {
        get {
            
            if let isencriptEditapi = UserDefaults.standard.object(forKey: "isencriptEditapi") as? Bool
            {
                return isencriptEditapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptEditapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Addetailapi------ 29-----------/////////////
    static var Addetailapi: String {
        get {
            
            if let addetailapi = UserDefaults.standard.object(forKey: "addetailapi") as? String {
                return addetailapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "addetailapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptAddetailapi: Bool {
        get {
            
            if let isencriptAddetailapi = UserDefaults.standard.object(forKey: "isencriptAddetailapi") as? Bool
            {
                return isencriptAddetailapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptAddetailapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Searchapi------ 30-----------/////////////
    static var Searchapi: String {
        get {
            
            if let searchapi = UserDefaults.standard.object(forKey: "searchapi") as? String {
                return searchapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "searchapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptSearchapi: Bool {
        get {
            
            if let isencriptSearchapi = UserDefaults.standard.object(forKey: "isencriptSearchapi") as? Bool
            {
                return isencriptSearchapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptSearchapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Channellistapi------ 31-----------/////////////
    static var Channellistapi: String {
        get {
            
            if let channellistapi = UserDefaults.standard.object(forKey: "channellistapi") as? String {
                return channellistapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "channellistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    static var IsencriptChannellistapi: Bool {
        get {
            
            if let isencriptChannellistapi = UserDefaults.standard.object(forKey: "isencriptChannellistapi") as? Bool
            {
                return isencriptChannellistapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptChannellistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    //////////Analyticsappapi------ 32-----------/////////////
    static var Analyticsappapi: String {
        get {
            
            if let analyticsappapi = UserDefaults.standard.object(forKey: "analyticsappapi") as? String {
                return analyticsappapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "analyticsappapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    static var IsencriptAnalyticsappapi: Bool {
        get {
            
            if let isencriptAnalyticsappapi = UserDefaults.standard.object(forKey: "isencriptAnalyticsappapi") as? Bool
            {
                return isencriptAnalyticsappapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptAnalyticsappapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    //////////Autosuggestapi------ 33-----------/////////////
    static var Autosuggestapi: String {
        get {
            
            if let autosuggestapi = UserDefaults.standard.object(forKey: "autosuggestapi") as? String {
                return autosuggestapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autosuggestapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptAutosuggestapi: Bool {
        get {
            
            if let isencriptAutosuggestapi = UserDefaults.standard.object(forKey: "isencriptAutosuggestapi") as? Bool
            {
                return isencriptAutosuggestapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptAutosuggestapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //////////Zonarapi------ 33-----------/////////////
    static var Zonarapi: String {
        get {
            
            if let zonarapi = UserDefaults.standard.object(forKey: "zonarapi") as? String {
                return zonarapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "zonarapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptZonarapi: Bool {
        get {
            
            if let isencriptZonarapi = UserDefaults.standard.object(forKey: "isencriptZonarapi") as? Bool
            {
                return isencriptZonarapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptZonarapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //////////Favriout------ 34-----------/////////////
    static var Favrioutapi: String {
        get {
            
            if let favrioutapi = UserDefaults.standard.object(forKey: "favrioutapi") as? String {
                return favrioutapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favrioutapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var IsencriptFavrioutapi: Bool {
        get {
            
            if let isencriptFavrioutapi = UserDefaults.standard.object(forKey: "isencriptFavrioutapi") as? Bool
            {
                return isencriptFavrioutapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptFavrioutapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    
    
    
    //////////Isplaybackallowed------ 35-----------/////////////
    static var Isplaybackallowedapi: String {
        get {
            
            if let isplaybackallowedapi = UserDefaults.standard.object(forKey: "isplaybackallowedapi") as? String {
                return isplaybackallowedapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isplaybackallowedapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var Isencriptplaybackallowedapi: Bool {
        get {
            
            if let isencriptplaybackallowedapi = UserDefaults.standard.object(forKey: "isencriptplaybackallowedapi") as? Bool
            {
                return isencriptplaybackallowedapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptplaybackallowedapi")
            UserDefaults.standard.synchronize()
        }
    }
    


    
    
    
    //////////Favriout------ 36-----------/////////////
    static var Subscriptionpaymentv2: String {
        get {
            
            if let subscriptionpaymentv2 = UserDefaults.standard.object(forKey: "subscriptionpaymentv2") as? String {
                return subscriptionpaymentv2
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subscriptionpaymentv2")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var Isencriptsubscriptionpaymentv2: Bool {
        get {
            
            if let isencriptsubscriptionpaymentv2 = UserDefaults.standard.object(forKey: "isencriptsubscriptionpaymentv2") as? Bool
            {
                return isencriptsubscriptionpaymentv2
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptsubscriptionpaymentv2")
            UserDefaults.standard.synchronize()
        }
    }

    
    
    //////////Favriout------ 37-----------/////////////
    static var Subscriptionpaymentv5: String {
        get {
            
            if let subscriptionpaymentv5 = UserDefaults.standard.object(forKey: "subscriptionpaymentv5") as? String {
                return subscriptionpaymentv5
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subscriptionpaymentv5")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var Isencriptsubscriptionpaymentv5: Bool {
        get {
            
            if let isencriptsubscriptionpaymentv5 = UserDefaults.standard.object(forKey: "isencriptsubscriptionpaymentv5") as? Bool
            {
                return isencriptsubscriptionpaymentv5
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptsubscriptionpaymentv5")
            UserDefaults.standard.synchronize()
        }
    }

    
    //////////subscription------ 37-----------/////////////
    static var Subscriptionapi: String {
        get {
            
            if let subscriptionapi = UserDefaults.standard.object(forKey: "subscriptionapi") as? String {
                return subscriptionapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subscriptionapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var Isencriptsubscriptionapi: Bool {
        get {
            
            if let isencriptsubscriptionapi = UserDefaults.standard.object(forKey: "isencriptsubscriptionapi") as? Bool
            {
                return isencriptsubscriptionapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptsubscriptionapi")
            UserDefaults.standard.synchronize()
        }
    }
    
       //////////subscription------ 37-----------/////////////
    
    static var Subscriptionapiv2: String {
        get {
            
            if let subscriptionapiv2 = UserDefaults.standard.object(forKey: "subscriptionapiv2") as? String {
                return subscriptionapiv2
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subscriptionapiv2")
            UserDefaults.standard.synchronize()
        }
    }
    
    
     //////////subscription------ 37-----------/////////////
    
    static var Ifallowedapi: String {
        get {
            
            if let ifallowedapiapi = UserDefaults.standard.object(forKey: "ifallowedapiapi") as? String
            {
                return ifallowedapiapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ifallowedapiapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var IsencriptIfallowedapi: Bool {
        get {
            
            if let isencriptIfallowedapi = UserDefaults.standard.object(forKey: "isencriptIfallowedapi") as? Bool
            {
                return isencriptIfallowedapi
            }
            return Bool()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isencriptIfallowedapi")
            UserDefaults.standard.synchronize()
        }
    }

    
    
    
    //////////contact_us------ 37-----------/////////////
    
    static var Contactusapi: String {
        get {
            
            if let contactusapi = UserDefaults.standard.object(forKey: "contactusapi") as? String
            {
                return contactusapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "contactusapi")
            UserDefaults.standard.synchronize()
        }
    }
    

    
    //////////favelist------ 37-----------/////////////
    
    static var Favelistapi: String {
        get {
            
            if let favelistapi = UserDefaults.standard.object(forKey: "favelistapi") as? String
            {
                return favelistapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favelistapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var Privactpolocyapi: String {
        get {
            
            if let privactpolocyapi = UserDefaults.standard.object(forKey: "Privactpolocyapi") as? String {
                return privactpolocyapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Privactpolocyapi")
            UserDefaults.standard.synchronize()
        }
    }
    static var Termsanduseapi: String {
        get {
            
            if let termsanduseapi = UserDefaults.standard.object(forKey: "Termsanduseapi") as? String {
                return termsanduseapi
            }
            return String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Termsanduseapi")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var UserSubscriptiondetail: NSArray {
        get {
            
            if let userSubscriptiondetail = UserDefaults.standard.object(forKey: "userSubscriptiondetail") as? NSArray {
                return userSubscriptiondetail
            }
            return NSArray()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userSubscriptiondetail")
            UserDefaults.standard.synchronize()
        }
    }
    
    
     }
