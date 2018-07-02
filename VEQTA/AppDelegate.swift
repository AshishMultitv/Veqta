 //
 //  AppDelegate.swift
 //  VEQTA
 //
 //  Created by SSCyberlinks on 12/01/17.
 //  Copyright © 2017 Multitv. All rights reserved.
 //
 
 import UIKit
 //import IQKeyboardManagerSwift
 import ReachabilitySwift
 import Foundation
 import UserNotifications
 import CoreData
 import SwiftMessages
 import Fabric
 import Crashlytics
 import ATAppUpdater
 import CoreTelephony
 import TPInAppReceipt
 import AFNetworking
 import GoogleCast
 import AVFoundation
 
 
 
 let kPrefPreloadTime = "preload_time_sec"
 let kPrefEnableAnalyticsLogging = "enable_analytics_logging"
 let kPrefEnableSDKLogging = "enable_sdk_logging"
 let kPrefAppVersion = "app_version"
 let kPrefSDKVersion = "sdk_version"
 let kPrefReceiverAppID = "receiver_app_id"
 let kPrefCustomReceiverSelectedValue = "use_custom_receiver_app_id"
 let kPrefCustomReceiverAppID = "custom_receiver_app_id"
 let kPrefEnableMediaNotifications = "enable_media_notifications"
 
 let kApplicationID: String? = nil
 let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
 
 
 @UIApplicationMain
 class AppDelegate: UIResponder,UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate
 {
    
    
    fileprivate var enableSDKLogging = false
    fileprivate var mediaNotificationsEnabled = false
    fileprivate var firstUserDefaultsSync = false
    fileprivate var useCastContainerViewController = false
    var mediaList: MediaListModel!
    
    var isCastControlBarsEnabled: Bool {
        get {
            if useCastContainerViewController {
                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                return castContainerVC!.miniMediaControlsItemEnabled
            } else {
                let rootContainerVC = (window?.rootViewController as? HomeViewController)
                return rootContainerVC!.miniMediaControlsViewEnabled
            }
        }
        set(notificationsEnabled) {
            if useCastContainerViewController {
                var castContainerVC: GCKUICastContainerViewController?
                castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = notificationsEnabled
            } else {
                var rootContainerVC: HomeViewController?
                rootContainerVC = (window?.rootViewController as? HomeViewController)
                rootContainerVC?.miniMediaControlsViewEnabled = notificationsEnabled
            }
        }
    }
    
    
    
    
    
    
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0
    var paymentOfSubscribe:NSString = NSString()
    var lastSelectedMenu:NSString = NSString()
    var detailLoadMore:NSString = NSString()
    var arraySideMenuKeys:NSMutableArray = NSMutableArray()
    var strFreeOrPaid:NSString = NSString()
    var strENterDetail:NSString = NSString()
    var dictPackageInfo:NSDictionary = NSDictionary()
    var orientationLock = UIInterfaceOrientationMask.all
    var window: UIWindow?
    var userViewTime:Int!
    var strSessionID:String!
    var strRedirstNotify:String!
    var bannerArrays:NSMutableArray=NSMutableArray()
    var subscribedItemArrays:NSMutableArray=NSMutableArray()
    var userIfo:NSDictionary=NSDictionary()
    var bannerDetailInfo:NSDictionary=NSDictionary()
    var reachability: Reachability?
    var objWeb = AFNetworkingWebServices()
    var timer:Timer!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        //For Google SignIn
    //    ATAppUpdater.init().showUpdateWithConfirmation()
        LoginCredentials.Livebuffertime = 0
        LoginCredentials.VideoPlayingtime = 0
        LoginCredentials.PlayType = ""
        Fabric.with([Crashlytics.self])
        UserDefaults.standard.set("", forKey: "lastSelectedSide")
        if UserDefaults.standard.value(forKey: "userCurrentPlay") != nil
        {
            userViewTime = UserDefaults.standard.value(forKey: "userCurrentPlay") as! Int!
        }
        else
        {
            userViewTime = 0
        }
        sleep(2)
        GIDSignIn.sharedInstance().clientID = "1018549572122-2cvv79rigu6jubj19vicf554t2t8njsc.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        if UserDefaults.standard.value(forKey: "UUID") as? String != nil {
            print("already uuid")
        }
        else
        {
            UserDefaults.standard.set(uuid as String, forKey: "UUID")
        }
        
        let reachability = Reachability()!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Message", message: "Check your network.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        do
        {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            application.registerForRemoteNotifications()
        } else {
            if #available(iOS 9, *) {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
            // Fallback on earlier versions
        }
        application.applicationIconBadgeNumber = 0
        UserDefaults.standard.set("relaunch", forKey: "splash")
        
        Getmasterurl()
        
        
        
        
        
        
        
        ///////CROME CAST
        
        populateRegistrationDomain()
        // Don't try to go on without a valid application ID - SDK will fail an
        // assert and app will crash.
        guard let applicationID = applicationIDFromUserDefaults(), applicationID != "" else {
            return true
        }
        
        
        useCastContainerViewController = false
        
        let options = GCKCastOptions(receiverApplicationID: applicationID)
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        window?.clipsToBounds = true
        setupCastLogging()
        
        // Set playback category mode to allow playing audio on the video files even
        // when the ringer mute switch is on.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let setCategoryError {
            print("Error setting audio category: \(setCategoryError.localizedDescription)")
        }
        
        
        
        if useCastContainerViewController {
            let appStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationController = appStoryboard.instantiateViewController(withIdentifier: "MainNavigation")
                as? UINavigationController else { return false }
            let castContainerVC = GCKCastContext.sharedInstance().createCastContainerController(for: navigationController)
                as GCKUICastContainerViewController
            castContainerVC.miniMediaControlsItemEnabled = true
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = castContainerVC
            window?.makeKeyAndVisible()
        } else {
            let rootContainerVC = (window?.rootViewController as? HomeViewController)
            rootContainerVC?.miniMediaControlsViewEnabled = true
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(syncWithUserDefaults),
                                               name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentExpandedMediaControls),
                                               name: NSNotification.Name.gckExpandedMediaControlsTriggered, object: nil)
        firstUserDefaultsSync = true
        syncWithUserDefaults()
        UIApplication.shared.statusBarStyle = .lightContent
        GCKCastContext.sharedInstance().sessionManager.add(self)
        GCKCastContext.sharedInstance().imagePicker = self
        
        
        
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
    }
    
    ///////getMasterurl Update
    
    func Getmasterurl()
    {

        let version=Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build=Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        print(version)
        print(build)
        var url = String(format: "%@%@device/ios",Constants.MaterBaseUrl,Constants.APP_Token)
        print(url)
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                }
                else
                {
                    let Catdata_dict = dict.value(forKey: "result") as! NSDictionary
                    print(Catdata_dict)
                    
                    ////////////////////////////////addapi 1  //////////////////////////
                    let addapi = Catdata_dict.value(forKey: "add") as! String
                    let addapiArr : [String] = addapi.components(separatedBy: "|,")
                    
                    LoginCredentials.AddAPi = addapiArr[1]
                    if((addapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAddAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAddAPi = false
                    }
                    
                    ////////////////////////////////addetail  2 /  /////////////////////////
                    let addetailapi = Catdata_dict.value(forKey: "addetail") as! String
                    let addetailapiArr : [String] = addetailapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Addetailapi = addetailapiArr[1]
                    if((addetailapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAddetailapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAddetailapi = false
                    }
        
                    
                    ////////////////////////////////analytics  3//////////////////////////
                    let analyticslapi = Catdata_dict.value(forKey: "analytics") as! String
                    let analyticslapiArr : [String] = analyticslapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Analyticsappapi = analyticslapiArr[1]
                    if((analyticslapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAnalyticsappapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAnalyticsappapi = false
                    }
                    
                    
                    ////////////////////////////////autosuggest  4//////////////////////////
                    let autosuggestapi = Catdata_dict.value(forKey: "autosuggest") as! String
                    let autosuggestapiArr : [String] = autosuggestapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Autosuggestapi = autosuggestapiArr[1]
                    if((autosuggestapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAutosuggestapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAutosuggestapi = false
                    }
                    
                    
                    
                    ////////////////////////////////catlist  5  //////////////////////////
                    let catlistapi = Catdata_dict.value(forKey: "catlist") as! String
                    let catlistapiArr : [String] = catlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.catlistapi = catlistapiArr[1]
                    if((catlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptcatlistapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptcatlistapi = false
                    }
                    
                    
                    ////////////////////////////////channel_list  6   //////////////////////////
                    let channellistapi = Catdata_dict.value(forKey: "channel_list") as! String
                    let channellistapiArr : [String] = channellistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Channellistapi = channellistapiArr[1]
                    if((channellistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptChannellistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptChannellistapi = false
                    }
                    
                    
                    ////////////////////////////////comment_add   7  //////////////////////////
                    let commentaddapi = Catdata_dict.value(forKey: "comment_add") as! String
                    let commentaddapiArr : [String] = commentaddapi.components(separatedBy: "|,")
                    
                    LoginCredentials.CommentaddAPi = commentaddapiArr[1]
                    if((commentaddapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptCommentaddAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptCommentaddAPi = false
                    }
                    
                    ////////////////////////////////commentlist  8  //////////////////////////
                    let commentlistapi = Catdata_dict.value(forKey: "comment_list") as! String
                    let commentlistapiArr : [String] = commentlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Commentlistapi = commentlistapiArr[1]
                    if((commentlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptCommentlistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptCommentlistapi = false
                    }
                    
                    ////////////////////////////////detail   9   //////////////////////////
                    let detailapi = Catdata_dict.value(forKey: "detail") as! String
                    let detailapiArr : [String] = detailapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Detailapi = detailapiArr[1]
                    if((detailapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDetailapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDetailapi = false
                    }
                    
                    
                    ////////////////////////////////deviceinfo   10  //////////////////////////
                    let deviceinfoapi = Catdata_dict.value(forKey: "deviceinfo") as! String
                    let deviceinfoapiArr : [String] = deviceinfoapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Deviceinfoapi = deviceinfoapiArr[1]
                    if((deviceinfoapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDeviceinfoapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDeviceinfoapi = false
                    }
                    
                    
                    ////////////////////////////////dislike   11   //////////////////////////
                    let dislikeapi = Catdata_dict.value(forKey: "dislike") as! String
                    let dislikeapiArr : [String] = dislikeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Dislikeapi = dislikeapiArr[1]
                    if((dislikeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDislikeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDislikeapi = false
                    }
                    
                    
                    ////////////////////////////////edit    12   //////////////////////////
                    let editapi = Catdata_dict.value(forKey: "edit") as! String
                    let editapiArr : [String] = editapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Editapi = editapiArr[1]
                    if((editapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptEditapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptEditapi = false
                    }
                    
                    ////////////////////////////////forgot   13   //////////////////////////
                    let forgotapi = Catdata_dict.value(forKey: "forgot") as! String
                    let forgotapiArr : [String] = forgotapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Forgotapi = forgotapiArr[1]
                    if((forgotapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptForgotapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptForgotapi = false
                    }
                    
                    ////////////////////////////////home    13    //////////////////////////
                    let homeapi = Catdata_dict.value(forKey: "home") as! String
                    let homeapiArr : [String] = homeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Homeapi = homeapiArr[1]
                    if((homeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptHomeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptHomeapi = false
                    }
                    
                    
                    
                    ////////////////////////////////like    14    //////////////////////////
                    let likeapi = Catdata_dict.value(forKey: "like") as! String
                    let likeapiArr : [String] = likeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Likeapi = likeapiArr[1]
                    if((likeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptLikeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptLikeapi = false
                    }
                    
                    
                    ////////////////////////////////list   15    //////////////////////////
                    let listapi = Catdata_dict.value(forKey: "list") as! String
                    let listapiArr : [String] = listapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Listapi = listapiArr[1]
                    if((listapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptListapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptListapi = false
                    }
                    
                    
                    ////////////////////////////////login  16   //////////////////////////
                    let loginapi = Catdata_dict.value(forKey: "login") as! String
                    let loginapiArr : [String] = loginapi.components(separatedBy: "|,")
                    
                    LoginCredentials.LoginAPI = loginapiArr[1]
                    if((loginapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptLoginAPI = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptLoginAPI = false
                    }
                    
                    ////////////////////////////////menu   17   //////////////////////////
                    let menuapi = Catdata_dict.value(forKey: "menu") as! String
                    let menuapiArr : [String] = menuapi.components(separatedBy: "|,")
                    
                    LoginCredentials.MenuAPi = menuapiArr[1]
                    if((menuapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptMenuAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptMenuAPi = false
                    }
                    
                    
                    ////////////////////////////////otp_generate  18    //////////////////////////
                    let otpgenerateapi = Catdata_dict.value(forKey: "otp_generate") as! String
                    let otpgenerateapiArr : [String] = otpgenerateapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Otpgenerateapi = otpgenerateapiArr[1]
                    if((otpgenerateapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptOtpgenerateapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptOtpgenerateapi = false
                    }
                    
                    ////////////////////////////////playlist    19   //////////////////////////
                    let playlistapi = Catdata_dict.value(forKey: "playlist") as! String
                    let playlistapiArr : [String] = playlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Playlistapi = playlistapiArr[1]
                    if((playlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptPlaylistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptPlaylistapi = false
                    }
                    
                    
                    ////////////////////////////////rating     20    //////////////////////////
                    let ratingapi = Catdata_dict.value(forKey: "rating") as! String
                    let ratingapiArr : [String] = ratingapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Ratingapi = ratingapiArr[1]
                    if((ratingapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptRatingapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptRatingapi = false
                    }
                    
                    ////////////////////////////////recomended    21   //////////////////////////
                    let recomendedapi = Catdata_dict.value(forKey: "recomended") as! String
                    let recomendedapiArr : [String] = recomendedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Recomendedapi = recomendedapiArr[1]
                    if((recomendedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptRecomendedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptRecomendedapi = false
                    }
                    
                    ////////////////////////////////search     22     //////////////////////////
                    let searchapi = Catdata_dict.value(forKey: "search") as! String
                    let searchapiArr : [String] = searchapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Searchapi = searchapiArr[1]
                    if((searchapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSearchapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSearchapi = false
                    }
                    
                    ////////////////////////////////social     23     //////////////////////////
                    let socialapi = Catdata_dict.value(forKey: "social") as! String
                    let socialapiArr : [String] = socialapi.components(separatedBy: "|,")
                    
                    LoginCredentials.SocialAPI = socialapiArr[1]
                    if((socialapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSocialAPI = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSocialAPI = false
                    }
                    
                    
                    
                    ////////////////////////////////subscribe     24     //////////////////////////
                    let subscribeapi = Catdata_dict.value(forKey: "subscribe") as! String
                    let subscribeapiArr : [String] = subscribeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Subscribeapi = subscribeapiArr[1]
                    if((subscribeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSubscribeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSubscribeapi = false
                    }
                    
                    ////////////////////////////////unsubscribe     25      //////////////////////////
                    let unsubscribeapi = Catdata_dict.value(forKey: "unsubscribe") as! String
                    let unsubscribeapiArr : [String] = unsubscribeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Unsubscribeapi = unsubscribeapiArr[1]
                    if((unsubscribeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUnsubscribeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUnsubscribeapi = false
                    }
                    
                    ////////////////////////////////udatedevice      26    //////////////////////////
                    let udatedeviceapi = Catdata_dict.value(forKey: "udatedevice") as! String
                    let udatedeviceapiArr : [String] = udatedeviceapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Udatedeviceapi = udatedeviceapiArr[1]
                    if((udatedeviceapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUdatedeviceapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUdatedeviceapi = false
                    }
                    
                    ////////////////////////////////user_behavior     27     //////////////////////////
                    let userbehaviorapi = Catdata_dict.value(forKey: "user_behavior") as! String
                    let userbehaviorapiArr : [String] = userbehaviorapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Userbehaviorapi = userbehaviorapiArr[1]
                    if((userbehaviorapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUserbehaviorapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUserbehaviorapi = false
                    }
                    
                    ////////////////////////////////userrelated    28     //////////////////////////
                    let userrelatedapi = Catdata_dict.value(forKey: "userrelated") as! String
                    let userrelatedapiArr : [String] = userrelatedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Userrelatedapi = userrelatedapiArr[1]
                    if((userrelatedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUserrelatedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUserrelatedapi = false
                    }
                    
                    
                    ////////////////////////////////verify_otp    29     //////////////////////////
                    let verifyotpapi = Catdata_dict.value(forKey: "verify_otp") as! String
                    let verifyotpapiArr : [String] = verifyotpapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Verifyotpapi = verifyotpapiArr[1]
                    if((verifyotpapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptVerifyotpapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptVerifyotpapi = false
                    }
                    
                    ////////////////////////////////version    30     //////////////////////////
                    let versionapi = Catdata_dict.value(forKey: "version") as! String
                    let versionapiArr : [String] = versionapi.components(separatedBy: "|,")
                    
                    LoginCredentials.AppVersionAPi = versionapiArr[1]
                    if((versionapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAppVersionAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAppVersionAPi = false
                    }
                    
                    ////////////////////////////////version_check      31    //////////////////////////
                    let versioncheckapi = Catdata_dict.value(forKey: "version_check") as! String
                    let versioncheckapiArr : [String] = versioncheckapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Versioncheckapi = versioncheckapiArr[1]
                    if((versioncheckapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptVersioncheckapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptVersioncheckapi = false
                    }
                    
                    ////////////////////////////////watchduration     32         //////////////////////////
                    let watchdurationapi = Catdata_dict.value(forKey: "watchduration") as! String
                    let watchdurationapiArr : [String] = watchdurationapi.components(separatedBy: "|,")
                    
                    LoginCredentials.watchdurationapi = watchdurationapiArr[1]
                    if((watchdurationapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptwatchdurationapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptwatchdurationapi = false
                    }
                    
                    
                    
                    
                    ////////////////////////////////Fauvout   33   //////////////////////////
                    let fauvoutapi = Catdata_dict.value(forKey: "favorite") as! String
                    let fauvoutapiArr : [String] = fauvoutapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Favrioutapi = fauvoutapiArr[1]
                    if((fauvoutapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptFavrioutapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptFavrioutapi = false
                    }
                    
                    
                    
                    
                    ////////////////////////////////isplaybackallowed     33         //////////////////////////
                    let isplaybackallowedapi = Catdata_dict.value(forKey: "isplaybackallowed") as! String
                    let isplaybackallowedapiArr : [String] = isplaybackallowedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Isplaybackallowedapi = isplaybackallowedapiArr[1]
                    if((isplaybackallowedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptplaybackallowedapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptplaybackallowedapi = false
                    }
                    
                    
                    
                    
                    
                    ////////////////////////////////subscription_payment_v2     33         //////////////////////////
                    let subscriptionpaymentv2api = Catdata_dict.value(forKey: "subscription_payment_v2_iap") as! String
                    let subscriptionpaymentv2apiArr : [String] = subscriptionpaymentv2api.components(separatedBy: "|,")
                    
                    LoginCredentials.Subscriptionpaymentv2 = subscriptionpaymentv2apiArr[1]
                    if((subscriptionpaymentv2apiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptsubscriptionpaymentv2 = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptsubscriptionpaymentv2 = false
                    }
                    
                    
                    
                    
                    
                    ////////////////////////////////subscription_payment_v5     33         //////////////////////////
                    let subscriptionpaymentv5api = Catdata_dict.value(forKey: "subscription_payment_v5") as! String
                    let subscriptionpaymentv5apiArr : [String] = subscriptionpaymentv5api.components(separatedBy: "|,")
                    
                    LoginCredentials.Subscriptionpaymentv5 = subscriptionpaymentv5apiArr[1]
                    if((subscriptionpaymentv5apiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptsubscriptionpaymentv5 = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptsubscriptionpaymentv5 = false
                    }
                    
                    
                    
                    
                    ////////////////////////////////subscription    33         //////////////////////////
                    let subscriptionapi = Catdata_dict.value(forKey: "subscription") as! String
                    let subscriptionapiArr : [String] = subscriptionapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Subscriptionapi = subscriptionapiArr[1]
                    if((subscriptionapiArr[0] as String) == "0")
                    {
                        
                        LoginCredentials.Isencriptsubscriptionapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptsubscriptionapi = false
                    }
                    
                    
                    ////////////////////////////////ifallowed    33         //////////////////////////
                    let ifallowedapi = Catdata_dict.value(forKey: "ifallowed") as! String
                    let ifallowedapiArr : [String] = ifallowedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Ifallowedapi = ifallowedapiArr[1]
                    if((ifallowedapiArr[0] as String) == "0")
                    {
                        
                        LoginCredentials.IsencriptIfallowedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptIfallowedapi = false
                    }
                    
                    
                    ////////////////////////////////contact_us    33         //////////////////////////
                    let contactusapi = Catdata_dict.value(forKey: "contact_us") as! String
                    let contactusapiArr : [String] = contactusapi.components(separatedBy: "|,")
                    LoginCredentials.Contactusapi = contactusapiArr[1]
                    
                    
                    
                    ////////////////////////////////subscription_v2  33        //////////////////////////
                    let subscriptionapiv2 = Catdata_dict.value(forKey: "subscription_v2_iap") as! String
                    let subscriptionapiv2Arr : [String] = subscriptionapiv2.components(separatedBy: "|,")
                    LoginCredentials.Subscriptionapiv2 = subscriptionapiv2Arr[1]
                    
                    
                    
                    
                    ////////////////////////////////favlist    33         //////////////////////////
                    let favlistapi = Catdata_dict.value(forKey: "favlist") as! String
                    let favlistapiArr : [String] = favlistapi.components(separatedBy: "|,")
                    LoginCredentials.Favelistapi = favlistapiArr[1]
                    
                    
                    
                    ////////////////////////////////favlist    34         //////////////////////////
                    let privacypolicy = Catdata_dict.value(forKey: "privacy_policy") as! String
                    let privacypolicyarr : [String] = privacypolicy.components(separatedBy: "|,")
                    LoginCredentials.Privactpolocyapi = privacypolicyarr[1]
                    
                    ////////////////////////////////favlist    33         //////////////////////////
                    let tcapi = Catdata_dict.value(forKey: "t_c") as! String
                    let tcapiArr : [String] = tcapi.components(separatedBy: "|,")
                    LoginCredentials.Termsanduseapi = tcapiArr[1]
                    
                    
                    self.callaftermasterurl()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reloadhome"), object: nil)
                    
                    
                    
                    
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    
    func callaftermasterurl()
    {
        NotificationCenter.default.addObserver(self,selector: #selector(getHeartBeatResponse),name: NSNotification.Name(rawValue: "getHeartBeatResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(signOutRemove),name: NSNotification.Name(rawValue: "signOutRemove"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(heartBeat),name: NSNotification.Name(rawValue: "callheartbeatapi"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(userappsession),name: NSNotification.Name(rawValue: "userappsession"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(activateUserappsession),name: NSNotification.Name(rawValue: "activateusersession"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(deActivateUserappsession),name: NSNotification.Name(rawValue: "deactivateusersession"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(logoutaction),name: NSNotification.Name(rawValue: "logoutaction"),object: nil)
        
        if(Common.isuserlogin())
        {
            
            verifyIAprecipt()
            self.deActivateUserappsession()
        }
        
        
        
    }
    
    
    
    
    
    
    
    func verifyIAprecipt()
    {
        
        
        
        do {
            let receipt = try InAppReceiptManager.shared.receipt()
            print(receipt.originalTransactionIdentifier(ofProductIdentifier: Constants.appBundleId))
            print(receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: Constants.appBundleId, forDate: Date()))
            print(receipt.purchases(ofProductIdentifier: Constants.appBundleId))
            print(receipt.hasActiveAutoRenewableSubscription(ofProductIdentifier: Constants.appBundleId, forDate: Date()))
            
            
            
            
            
            
        } catch {
            print(error)
        }
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    func signOutRemove()
    {
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString >>",deviceTokenString)
        UserDefaults.standard.set(deviceTokenString, forKey: "tokenID")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
        UserDefaults.standard.set("", forKey: "tokenID")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState == .active {
            //opened from a push notification when the app was on background
        }
        else
        {
            
        }
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)
        print("userInfo",userInfo)
        let typeStr = userInfo["type"] as! String
        if typeStr == "UPDATE" {
            print("Content updated")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backLiveVideo"), object: nil)
        }
         else if typeStr == "SESSION_EXPIRY" {
            print("Content updated")
            if(Common.isuserlogin())
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "poptologout"), object: nil)
               // self.logoutaction()
                
            }
        }
        else if typeStr == "SESSION_INACTIVE" {
            print("SESSION_INACTIVE")
            if(Common.isuserlogin())
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SESSIONINACTIVE"), object: nil)
                
            }
        }
    
        else
        {
            
            // let view = MessageView.viewFromNib(layout:.MessageView)
            // view.configureTheme(.info)
            //  view.configureDropShadow()
            //    view.configureContent(title: "Veqta", body: "", iconText:"")
            //  SwiftMessages.show(view: view)
        }
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        print("did receive")
        let body = response.notification.request.content.body
        print(body)
        completionHandler()
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
    }
    
    func logoutaction()
    {
        
        if(Common.isuserlogin())
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Userapplogout"), object: nil)
        }
    }
    
    
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    func heartBeat()
    {
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strDeviceName=UIDevice.current.model
        let strResolution=String(format: "%.f*%.f", self.window!.frame.size.width, (self.window?.frame.size.height)!)
        
        // Get carrier name
        let carrierName = carrier?.carrierName
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        
        var Pushtoken  = String()
        
        if(!Common.isNotNull(object: UserDefaults.standard.value(forKey: "tokenID") as AnyObject?))
        {
            Pushtoken = ""
        }
        else
        {
            Pushtoken = UserDefaults.standard.value(forKey: "tokenID") as! String
        }
        
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname = (carrier?.carrierName)! as String
        }
        
        
        print(Common.getnetworktype())
        
        
        let dictionaryOtherDetail: NSDictionary = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        let devicedetailss: NSDictionary = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "iOS",
            "device_unique_id" : UserDefaults.standard.value(forKey: "UUID") as! String,//token! as! String,
            "push_device_token" :  Pushtoken//token! as! String
        ]
        var type = String()
        if(LoginCredentials.PlayType == "LIVE")
        {
            type = "1"
        }
        else if(LoginCredentials.PlayType == "VOD")
        {
            type = "2"
        }
        
        var json = [String:Any]()
        var strID = String()
        
        if(Common.isuserlogin())
        {
            
            strID = UserDefaults.standard.value(forKey: "loginData") as! String
            
        }
        else
        {
            strID = "0"
        }
        
        
        if(type == "1")
        {
            json = ["device":"ios","u_id":strID as String,"c_id":LoginCredentials.Videoid ,"type": type,"buff_d":"0","dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"pd":LoginCredentials.VideoPlayingtime,"token":Constants.APP_SOCIAL_Token]
        }
        else
        {
            json = ["device":"ios","u_id":strID as String,"c_id":LoginCredentials.Videoid ,"type": type,"buff_d":"0","dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"pd":LoginCredentials.VideoPlayingtime,"token":Constants.APP_SOCIAL_Token]
        }
        
        
        
        
        print("applicationheartbeat json >>",json)
        
        let url = String(format: "%@%@", LoginCredentials.Analyticsappapi,Constants.APP_SOCIAL_Token)
        
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getHeartBeatResponse"), object: dict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
      //  objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getHeartBeatResponse" )
        
    }
    @objc func getHeartBeatResponse(notification: NSNotification)
    {
        
        let dictPayment=notification.object as! NSDictionary
        print(dictPayment)
        
        
    }
    
    
    
    
    
    
    
    
    
    func activateUserappsession()
    {
        if(Common.isuserlogin())
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = ["device":"ios","customer_id":strID as String,"content_id":"", "session_status":"active","device_unique_id" : UserDefaults.standard.value(forKey: "UUID") as! String] as [String : Any]
            
            print("CAll USER ACTIVE SESSION")
            print("Payment >>",json)
            
            var url = String(format: "%@%@", LoginCredentials.Ifallowedapi,Constants.APP_Token)
            print(url)
            url = url.trimmingCharacters(in: .whitespaces)
            
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userappsession"), object: dict)
                 }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
            
            
        //    objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"userappsession" )
        }
    }
    
    func deActivateUserappsession()
    {
        if(Common.isuserlogin())
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = ["device":"ios","customer_id":strID as String,"content_id":"", "session_status":"inactive","device_unique_id" : UserDefaults.standard.value(forKey: "UUID") as! String] as [String : Any]
            print("CAll DE USER ACTIVE SESSION")
            print("Payment >>",json)
            var url = String(format: "%@%@", LoginCredentials.Ifallowedapi,Constants.APP_Token)
            print(url)
            url = url.trimmingCharacters(in: .whitespaces)
            
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userappsession"), object: dict)
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
            
            
            
            //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"userappsession" )
        }
    }
    
    @objc func userappsession(notification: NSNotification)
    {
        
        let dictPayment=notification.object as! NSDictionary
        print(dictPayment)
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            }
            else {
                print("Reachable via Cellular")
            }
        } else {
            let alert = UIAlertController(title: "Message", message: "Check your network.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            // self.window(alert, animated: true, completion: nil)
        }
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    //MARK:- Google SignIn Delegate
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        //var shouldOpen :Bool
        //803219456496719
        if url.scheme == "fb1130790320360889" as? String
        {
            return FBSDKApplicationDelegate.sharedInstance()
                .application(app,
                             open: url as URL!,
                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        else
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        if (error == nil)
        {
            print("user>>>\(user)")
            //     let idToken = user.authentication.idToken
            //   print("idToken>>>\(idToken)")
            print("user>>>>\(user.userID)")
            print("user>>>>\(user.authentication.idToken)")
            print("user>>>>\(user.profile.name)")
            print("user>>>>\(user.profile.email)")
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
        Common.startlivebuffertime()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        Common.stoplivebuffertime()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiData"), object: nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //
        print("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
        self.deActivateUserappsession()
        
        if(LoginCredentials.PlayType == "VOD" || LoginCredentials.PlayType == "LIVE")
        {
            Common.callheartBeatapi()
        }
        
        Common.stoplivebuffertime()
        UserDefaults.standard.set("relaunch", forKey: "splash")
        
        //For Google Signout
        GIDSignIn.sharedInstance().signOut()
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.saveContext()
        
        
    }
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    
    
    func setupCastLogging() {
        let logFilter = GCKLoggerFilter()
        let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel",
                            "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
        logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
    }
    
    
    func presentExpandedMediaControls() {
        print("present expanded media controls")
        // Segue directly to the ExpandedViewController.
        let navigationController: UINavigationController?
        if useCastContainerViewController {
            let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
            navigationController = (castContainerVC?.contentViewController as? UINavigationController)
        } else {
            let rootContainerVC = (window?.rootViewController as? ViewController)
            navigationController = rootContainerVC?.navigationController
        }
        // NOTE: Why aren't we just setting this to nil?
        navigationController?.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let appDelegate = appDelegate, appDelegate.isCastControlBarsEnabled == true {
            appDelegate.isCastControlBarsEnabled = false
        }
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    
    
    
    
    
 }
 
 public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
 }
 
 
 
 
 // MARK: - Working with default values
 extension AppDelegate {
    
    func populateRegistrationDomain() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        var appDefaults = [String: Any]()
        if let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
            loadDefaults(&appDefaults, fromSettingsPage: "Root", inSettingsBundleAt: settingsBundleURL)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: appDefaults)
        userDefaults.setValue(appVersion, forKey: kPrefAppVersion)
        userDefaults.setValue(kGCKFrameworkVersion, forKey: kPrefSDKVersion)
        userDefaults.synchronize()
    }
    
    func loadDefaults(_ appDefaults: inout [String: Any], fromSettingsPage plistName: String,
                      inSettingsBundleAt settingsBundleURL: URL) {
        let plistFileName = plistName.appending(".plist")
        let settingsDict = NSDictionary(contentsOf: settingsBundleURL.appendingPathComponent(plistFileName))
        if let prefSpecifierArray = settingsDict?["PreferenceSpecifiers"] as? [[AnyHashable:Any]] {
            for prefItem in prefSpecifierArray {
                let prefItemType = prefItem["Type"] as? String
                let prefItemKey = prefItem["Key"] as? String
                let prefItemDefaultValue = prefItem["DefaultValue"] as? String
                if prefItemType == "PSChildPaneSpecifier" {
                    if let prefItemFile = prefItem["File"]  as? String {
                        loadDefaults(&appDefaults, fromSettingsPage: prefItemFile, inSettingsBundleAt: settingsBundleURL)
                    }
                } else if let prefItemKey = prefItemKey, let prefItemDefaultValue = prefItemDefaultValue {
                    appDefaults[prefItemKey] = prefItemDefaultValue
                }
            }
        }
    }
    
    func applicationIDFromUserDefaults() -> String? {
        let userDefaults = UserDefaults.standard
        var prefApplicationID = userDefaults.string(forKey: kPrefReceiverAppID)
        if prefApplicationID == kPrefCustomReceiverSelectedValue {
            prefApplicationID = userDefaults.string(forKey: kPrefCustomReceiverAppID)
        }
        if let prefApplicationID = prefApplicationID {
            let appIdRegex = try? NSRegularExpression(pattern: "\\b[0-9A-F]{8}\\b", options: [])
            let rangeToCheck = NSRange(location: 0, length: (prefApplicationID.characters.count))
            let numberOfMatches = appIdRegex?.numberOfMatches(in: prefApplicationID,
                                                              options: [],
                                                              range: rangeToCheck)
            if numberOfMatches == 0 {
                let message: String = "\"\(prefApplicationID)\" is not a valid application ID\n" +
                "Please fix the app settings (should be 8 hex digits, in CAPS)"
                // showAlert(withTitle: "Invalid Receiver Application ID", message: message)
                return nil
            }
        } else {
            let message: String = "You don't seem to have an application ID.\n" +
            "Please fix the app settings."
            // showAlert(withTitle: "Invalid Receiver Application ID", message: message)
            return nil
        }
        return prefApplicationID
    }
    
    func syncWithUserDefaults() {
        let userDefaults = UserDefaults.standard
        // Forcing no logging from the SDK
        enableSDKLogging = false
        let mediaNotificationsEnabled = userDefaults.bool(forKey: kPrefEnableMediaNotifications)
        GCKLogger.sharedInstance().delegate?.logMessage?("Notifications on? \(mediaNotificationsEnabled)",
            fromFunction: #function)
        if firstUserDefaultsSync || (self.mediaNotificationsEnabled != mediaNotificationsEnabled) {
            self.mediaNotificationsEnabled = mediaNotificationsEnabled
            if useCastContainerViewController {
                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = mediaNotificationsEnabled
            } else {
                let rootContainerVC = (window?.rootViewController as? HomeViewController)
                rootContainerVC?.miniMediaControlsViewEnabled = mediaNotificationsEnabled
            }
        }
        firstUserDefaultsSync = false
    }
 }
 
 // MARK: - GCKLoggerDelegate
 extension AppDelegate: GCKLoggerDelegate {
    func logMessage(_ message: String, fromFunction function: String) {
        if enableSDKLogging {
            // Send SDK's log messages directly to the console.
            print("\(function)  \(message)")
        }
    }
    
 }
 
 
 
 // MARK: - GCKSessionManagerListener
 extension AppDelegate: GCKSessionManagerListener {
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        if error == nil {
            if let view = window?.rootViewController?.view {
                Toast.displayMessage("Session ended", for: 3, in: view)
            }
        } else {
            let message = "Session ended unexpectedly:\n\(error?.localizedDescription ?? "")"
            //showAlert(withTitle: "Session error", message: message)
        }
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        let message = "Failed to start session:\n\(error.localizedDescription)"
        //showAlert(withTitle: "Session error", message: message)
    }
    
    func showAlert(withTitle title: String, message: String) {
        // TODO: Pull this out into a class that either shows an AlertVeiw or a AlertController
        let alert = UIAlertView(title: title, message: message,
                                delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }
    
 }
 
 // MARK: - GCKUIImagePicker
 extension AppDelegate: GCKUIImagePicker {
    func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
        let images = metadata.images
        guard !images().isEmpty else { print("No images available in media metadata."); return nil }
        if images().count > 1 && imageHints.imageType == .background {
            return images()[1] as? GCKImage
        } else {
            return images()[0] as? GCKImage
        }
    }
 }
 

