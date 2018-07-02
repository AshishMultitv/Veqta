//
//  HomeViewController.swift
//  VEQTA
//
//  Created by SSCyberlinks on 13/01/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage
import REFrostedViewController
import SystemConfiguration
import Kingfisher
import Nuke
import CoreData
import MediaPlayer
import GoogleCast
import AFNetworking
let kCastControlBarsAnimationDuration: TimeInterval = 0.20


class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,GCKUIMiniMediaControlsViewControllerDelegate {
    var bannerArray:NSMutableArray = NSMutableArray()
    var isNewDataNewsLoading:Bool = Bool()
    var sendListCount:Int!
    
    
    var spinner:UIActivityIndicatorView!
    var newsContentArray:NSMutableArray = NSMutableArray()
    var reloadArray:NSMutableArray = NSMutableArray()
    var sportsIconContentArray:NSMutableArray = NSMutableArray()
    var homeListArray:NSMutableArray = NSMutableArray()
    var sideMenuArray:NSMutableArray = NSMutableArray()
    var recomendedArray:NSMutableArray = NSMutableArray()
    var homeAllData:NSMutableDictionary = NSMutableDictionary()
    var liveCollectionCell:LiveCollectionViewCell = LiveCollectionViewCell()
    var higLightCell:HighlightTableViewCell = HighlightTableViewCell()
    var allkeyArray:NSMutableArray=NSMutableArray()
    var playerItem:AVPlayerItem!
    var subCatIndexScroll:Int!
    var arrayLiveData:NSMutableArray=NSMutableArray()
    var localeStr:NSString = NSString()
    var liveContentIDStr:NSString = NSString()
    var livePlayerUrl:URL!
    var Playerurl_secure = String()
    var liveBG:UIView = UIView()
    var bEnlarge:Bool = Bool()
    var sportsDict:NSMutableDictionary=NSMutableDictionary()
    var showsDict:NSMutableDictionary=NSMutableDictionary()
    var playerController = AVPlayerViewController()
    //var videoBg:UIView = UIView()
    var objWeb = AFNetworkingWebServices()
    
    var detailContentArray:NSMutableArray = NSMutableArray()
    var upcominnB:Bool!
    var timer:Timer!
    var playerTime:Int!
    var objLoader : LoaderView = LoaderView()
    var objSplash : SplashAnimationView = SplashAnimationView()
    var strLiveVersion:NSString=NSString()
    
    var avPlayersLayer:AVPlayerLayer!
    var listArray:NSArray=NSArray()
    var videoBgPlayer:AVPlayer!
    var strID:NSString!
    var strMoreID:NSString!
    var strDetailType:NSString!
    var strHeading:NSString!
    var strLoginType:NSString = NSString()
    var strType:NSString!
    var lblLeft:UILabel = UILabel()
    var lblRight:UILabel = UILabel()
    var playbackSlider:UISlider!
    var homeDetailDict:NSDictionary=NSDictionary()
    var moreBtnTag = NSInteger()
    var countCat:Int!
    var arrayPackage:NSMutableArray = NSMutableArray()
    var countVod:Int!
    
    @IBOutlet var tblHomeData: UITableView!
    var arrBannerData:NSMutableArray = ["images_a.jpeg","images_b.jpeg","images_c.jpeg","images_d.jpeg","images_e.jpeg","images_f.jpeg"]
    
    var cellBanner:BannerTblViewCell = BannerTblViewCell()
    let cellReuseIdentifier = "sportsTblCell"
    let sportsCollCellIdentifier = "SportsCollectionCell"
    let newsCollCellIdentifier = "NewsCollectionCell"
    let bannerTblCellIdentifier = "bannerTblCell"
    let newsTblCellIdentifier = "NewsTblCell"
    let liveTblCellIdentifier = "liveTblCell"
    let liveCollCellIdentifier = "liveTblCell"
    var datadict: [NSManagedObject] = []
    var dashversion:String!
    var liveversion:String!
    var catVersionList:String!
    var contantversion:String!
    var dict:NSMutableArray=NSMutableArray()
    var sport_id:String!
    let playerVC = AVPlayerViewController()
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var currentplayertime:Double!
    
    
    
    
    private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    
    var miniMediaControlsViewEnabled = false {
        didSet {
            if self.isViewLoaded {
                self.updateControlBarsVisibility()
            }
        }
    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        subCatIndexScroll = 0
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            localeStr = "us"//countryCode as NSString
        }
        else
        {
            localeStr = "us"
        }
        
        self.playerTime = 0
        let arrayOfVCs = navigationController!.viewControllers as Array
        //print("view ?????>>>>",arrayOfVCs)
        let window :UIWindow = UIApplication.shared.keyWindow!
        let subViewArray:NSArray = (window.subviews as NSArray)
        AppUtility.lockOrientation([.portrait])
        self.frostedViewController.panGestureEnabled = true
        self.tblHomeData.register(UINib(nibName: "BannerTblViewCell", bundle: nil), forCellReuseIdentifier: bannerTblCellIdentifier)
        self.tblHomeData!.register(UINib(nibName: "NewsTblViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        self.tblHomeData!.register(UINib(nibName: "LiveTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveCell")
        self.tblHomeData!.register(UINib(nibName: "HighlightTableViewCell", bundle: nil), forCellReuseIdentifier: "highlightTblCell")
        self.tblHomeData!.register(UINib(nibName: "ShowsTableViewCell", bundle: nil), forCellReuseIdentifier: "showTblCell")
        self.tblHomeData!.register(UINib(nibName: "SubLiveTableViewCell", bundle: nil), forCellReuseIdentifier: "subLive")
        self.tblHomeData!.register(UINib(nibName: "TrendingTableViewCell", bundle: nil), forCellReuseIdentifier: "trendingCell")
        self.checkAPi()
        
        
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.updateControlBarsVisibility()
        if(LoginCredentials.Homeapi == "")
        {
            NotificationCenter.default.addObserver(self,selector: #selector(reloadhome),name: NSNotification.Name(rawValue: "Reloadhome"),object: nil)
        }
        
    }
    
    func willResignActive(_ notification: Notification) {
        chekforceupgraorsoftupgrateapi()
     }
    

    
    
    func chekforceupgraorsoftupgrateapi()
    {
    var url = String(format: "%@%@device/ios", LoginCredentials.Versioncheckapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            let dict = responseObject as! NSDictionary
            print(dict)
            let resultCode = dict.object(forKey: "code") as! Int
            if resultCode == 1
            {
                let type = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "type") as! String
                let messege = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "message") as! String
                var apiversion = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "version") as! NSString
                var currentappvesrion = Bundle.main.releaseVersionNumber
                print(apiversion.floatValue)
                print(currentappvesrion!.floatValue)
                if(currentappvesrion!.floatValue<apiversion.floatValue)
                {
                if(type == "soft")
                {
                  self.softupdatealert(message: messege)
                }
                else if(type == "force")
                {
                    self.forceupdatealert(message: messege)
                }
                }
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
        })
    }
    
    
    func softupdatealert(message:String)
   {
    let alert = UIAlertController(title: "Veqta", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (action) in
        
        self.goToappstore()
 
     }))
     self.present(alert, animated: true, completion: nil)
    
    
    }
    func forceupdatealert(message:String)
    {
        let alert = UIAlertController(title: "Veqta", message: message, preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (action) in
            self.goToappstore()

          }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToappstore()
    {
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/in/app/veqta/id1044161618?mt=8")! as URL)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        chekforceupgraorsoftupgrateapi()
         let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionLogin"
        AppUtility.lockOrientation(.portrait)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(showBannerDetail),name: NSNotification.Name(rawValue: "showBannerDetail"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(checkAPi),name: NSNotification.Name(rawValue: "loadApiData"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(checkAPi),name: NSNotification.Name(rawValue: "backLiveVideo"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(get_Response),name: NSNotification.Name(rawValue: "getHomeResponse"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionLogin"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(getHomeNewsDataResponse),name: NSNotification.Name(rawValue: "getHomeNewsDataResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getHomePackageList),name: NSNotification.Name(rawValue: "getHomePackageList"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getcatListResponse),name: NSNotification.Name(rawValue: "getcatListResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getversionchekResponse),name: NSNotification.Name(rawValue: "getversionchekResponse"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(loginRedirect),name: NSNotification.Name(rawValue: "loginScreen"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(redirectLoginScreen),name: NSNotification.Name(rawValue: "redirectLoginScreen"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(Userapplogout),name: NSNotification.Name(rawValue: "Userapplogout"),object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        
        
        
    }
    
    func reloadhome()
    {
        checkAPi()
    }
    
    func removevideoplayer()
    {
        self.frostedViewController.panGestureEnabled = true
        self.view.isUserInteractionEnabled = true
        playerLayer.removeFromSuperlayer()
        playerVC.view.removeFromSuperview()
        
        
    }
    
    
    
    func Userapplogout()
    {
        
        
        
        let alert = UIAlertController(title: "", message: "Your password has been reset.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.backaction()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
        
        
        Common.DeActivateUsersession()
        UserDefaults.standard.set("", forKey: "sessionID")
        UserDefaults.standard.set(nil, forKey: "loginData")
        UserDefaults.standard.set(nil, forKey: "UserID")
        UserDefaults.standard.set("slider", forKey: "screenFrom")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginScreen"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        view.addSubview(controller.view)
    }
    
    
    func backaction()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Getdatabaseresponse
    
    
    func getdatabaseresponse()
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataDict")
            do {
                
                datadict = try managedContext.fetch(fetchRequest)
                
                if (datadict.count>0)
                {
                    let person = datadict[0]
                    
                    let data = person.value(forKeyPath: "dict") as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    dict = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject") as! NSMutableArray
                    print(dict)
                    let decoded  = UserDefaults.standard.object(forKey: "version") as! Data
                    let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
                    
                    dashversion = (decodedTeams.value(forKey: "dash_version") as! String)
                    liveversion = (decodedTeams.value(forKey: "live_version") as! String)
                    catVersionList = (UserDefaults.standard.object(forKey: "versionCatList") as? String)
                    print("catVersionList >>",catVersionList)
                    print("dashversion >>",dashversion)
                    print("liveversion >>",liveversion)
                    unarchiver.finishDecoding()
                    self.getappversion(str: dashversion)
                    
                }
                else
                {
                    dashversion = "0.0"
                    liveversion = "0.0"
                    contantversion = "0.0"
                    catVersionList = "0.0"
                    self.getappversion(str: dashversion)
                }
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    // MARK: - Check_App_version
    
    
    func getappversion(str:String)
    {
        let json:[String:String] = [:]
       var url = String(format: "%@%@device/ios", LoginCredentials.AppVersionAPi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        self.objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getversionchekResponse")
        // self.objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getversionchekResponse" )
    }
    
    @objc func getversionchekResponse(notification: NSNotification)
    {
        var responseDict:NSDictionary=NSDictionary()
        
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        print(responseDict)
        dictHome=responseDict.mutableCopy() as! NSMutableDictionary
        print("dashversion >>",dashversion)
        print("liveversion >>",liveversion)
        print("catVersionList >>",catVersionList)
        if let _ = dictHome.value(forKey: "code")
      {
        if(dictHome.value(forKey: "code") as! NSNumber == 0)
        {
            self.deleteAllData(entity: "SportData")
            self.get_CatList()
            return
        }
        }
        let contentVer = (dictHome.object(forKey: "content_version") as? NSNumber)?.stringValue
        let dashVer = (dictHome.object(forKey: "dash_version") as? NSNumber)?.stringValue
        let liveVer = (dictHome.object(forKey: "live_version") as? NSNumber)?.stringValue
        let catListVer = (dictHome.object(forKey: "category_version") as? NSNumber)?.stringValue
        // dictHome.object(forKey: "versionCatList") as? String
        print("dashVer >>",dashVer)
        print("catListVer >>",catListVer)
        print("liveVer >>",liveVer)
        //Due to crash closed
        if  dashVer == dashversion && liveVer == liveversion && catListVer == catVersionList {
            self.removeLoader()
            self.fetchFromDB()
        }
        else
        {
            self.deleteAllData(entity: "SportData")
            self.get_CatList()
        }
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            fetchRequest.returnsObjectsAsFaults = false
            
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            }
            
            
        } else {
        }
    }
    
    func removeSplashFromHome()
    {
        self.objSplash.removeFromSuperview()
    }
    func createSplash() {
        
        self.objSplash.frame=CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.objSplash.createLoader()
        UIApplication.shared.delegate!.window!?.addSubview(self.objSplash)
        UIApplication.shared.delegate!.window!?.bringSubview(toFront:self.objSplash)
    }
    func removeSplash() {
        self.objSplash.removeFromSuperview()
    }
    func afterSessionLogin()
    {
        self.performSegue(withIdentifier: "showLoginSession", sender: self)
    }
    func redirectLoginScreen()  {
    }
    func createLoader() {
        
        self.objLoader.frame=CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.objLoader.createLoader()
        UIApplication.shared.delegate!.window!?.addSubview(self.objLoader)
        UIApplication.shared.delegate!.window!?.bringSubview(toFront:self.objLoader)
    }
    func removeLoader() {
        self.objLoader.removeFromSuperview()
    }
    func loginRedirect()
    {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkAPi()  {
        let strLaunch = UserDefaults.standard.value(forKey: "splash") as! String
        if strLaunch == "relaunch"
        {
            self.createLoader()
            // self.playMovie()
            self.getdatabaseresponse()
        }
        else
        {
            //self.createLoader()
            UserDefaults.standard.set("again", forKey: "splash")
            //self.fetchFromDB()
            self.fetchFromDB()
            self.getdatabaseresponse()
            
        }
    }
    @objc func showBannerDetail(notification: NSNotification)
    {
        detailContentArray = notification.object as! NSMutableArray
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        homeDetailDict = appDelegate.bannerDetailInfo
        strDetailType = "banner"
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    func rotated()
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            let rectBg = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            if self.avPlayersLayer != nil
            {
                bEnlarge = true
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                self.avPlayersLayer.frame = (appDelegate.window?.bounds)!
                self.view.layer.addSublayer(self.avPlayersLayer)
                
                let doesContain = self.view.subviews.contains(liveBG)
                if doesContain == true
                {
                    liveBG.removeFromSuperview()
                }
                liveBG = UIView(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height))
                liveBG.backgroundColor=UIColor.clear
                self.view.addSubview(liveBG)
                self.view.bringSubview(toFront: liveBG)
                self.createLandscapePlayerControl(viewBg: liveBG)
            }
            
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width-20, height: 160))
            if self.avPlayersLayer != nil
            {
                bEnlarge = false
                self.avPlayersLayer.frame = rect
                
                self.liveCollectionCell.layer.addSublayer(self.avPlayersLayer)
                self.view.bringSubview(toFront: self.playbackSlider)
                
                let doesContain = self.view.subviews.contains(liveBG)
                if doesContain == true
                {
                    liveBG.removeFromSuperview()
                }
                liveBG = UIView(frame:CGRect(x:0, y:0, width:self.view.frame.size.width-20, height:160))
                liveBG.backgroundColor=UIColor.clear
                self.liveCollectionCell.addSubview(liveBG)
                self.liveCollectionCell.bringSubview(toFront: liveBG)
                self.createPlayerControl(viewBg: liveBG)
                
            }
        }
    }
    @IBAction func menuAction(_ sender: Any) {
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    @IBAction func sideMenuAction(_ sender: Any) {
    }
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width-20, height: 160))
        self.avPlayersLayer.frame = rect
        AppUtility.lockOrientation(.portrait)
        self.perform(#selector(changeOrientation), with: nil, afterDelay: 5.0)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        self.performSegue(withIdentifier: "searchPush", sender: self)
    }
    @IBAction func searchIconAction(_ sender: Any) {
        self.performSegue(withIdentifier: "searchPush", sender: self)
    }
    func changeOrientation()
    {
        AppUtility.lockOrientation(.portrait)
    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    func get_CatList()
    {
        let bNetwork = self.isInternetAvailable() as Bool
        if bNetwork == true {
            
        }
        else
        {
            let alertController : UIAlertController = UIAlertController(title: "Network error", message: "Please check your network", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as [String:String]
            var url = String(format: "%@%@device/ios", LoginCredentials.catlistapi,Constants.APP_Token)
            print(url)
            url = url.trimmingCharacters(in: .whitespaces)
            
            self.objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getcatListResponse" )
            // self.objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getcatListResponse" )
        }
        else
        {
            let json = [:] as [String:String]
            
            
            
            // var url = String(format: "%@%@device_unique_id/dfsfdfd/device/ios/display_offset/0/display_limit/4/user_id/0/current_version/0.0", LoginCredentials.catlistapi,Constants.APP_Token)
            var url = String(format: "%@%@device/ios", LoginCredentials.catlistapi,Constants.APP_Token)
            print(url)
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
            self.objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getcatListResponse" )
            //self.objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getcatListResponse" )
        }
        
    }
    @objc func getcatListResponse(notification: NSNotification)
    {
        var responseDict:NSDictionary=NSDictionary()
        
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictHome=responseDict.mutableCopy() as! NSMutableDictionary
        print(dictHome)
        let archiveHome = NSKeyedArchiver.archivedData(withRootObject: dictHome)
        UserDefaults.standard.setValue(archiveHome, forKey: "catHome")
        var arrayVod:NSArray=NSArray()
        UserDefaults.standard.setValue((dictHome.value(forKey: "version") as AnyObject) as! NSString, forKey: "versionCatList")
        arrayVod = (dictHome.value(forKey: "cat") as! NSDictionary).value(forKey: "vod")  as! NSArray
        let archiveVod = NSKeyedArchiver.archivedData(withRootObject: arrayVod)
        UserDefaults.standard.set(archiveVod, forKey: "vodArray")
        self.catListDataSave()
         self.get_Home_Date()
    }
    func catListDataSave()  {
        
        let decodedHome  = UserDefaults.standard.object(forKey: "catHome") as! Data
        let dictHome = NSKeyedUnarchiver.unarchiveObject(with: decodedHome) as! NSMutableDictionary
        let decodedVod  = UserDefaults.standard.object(forKey: "vodArray") as! Data
        let arrayVod = NSKeyedUnarchiver.unarchiveObject(with: decodedVod) as! NSArray
        
        countVod=0
        sideMenuArray.removeAllObjects()
        
//        if arrayVod.count == 0
//        {
//            let array = NSArray()
//           sportsDict.setObject(array, forKey: "sports" as NSCopying)
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.arraySideMenuKeys = ["sports"]
//            UserDefaults.standard.set(appDelegate.arraySideMenuKeys, forKey: "sideKeys")
//            sideMenuArray.add(sportsDict)
//        }
        
        if arrayVod.count > 0
        {
            var arraySports:NSArray=NSArray()
            if let val = (((dictHome.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: 0) as AnyObject).object(forKey: "children")
            {
                countVod = countVod+1
                arraySports = (((dictHome.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as AnyObject).object(at: 0) as AnyObject).object(forKey: "children") as! NSArray
                sportsDict.setObject(arraySports, forKey: "sports" as NSCopying)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.arraySideMenuKeys = ["sports"]
                UserDefaults.standard.set(appDelegate.arraySideMenuKeys, forKey: "sideKeys")
                 sideMenuArray.add(sportsDict)
            }
        }
        
        if arrayVod.count == 2
        {
            var arrayShows:NSArray=NSArray()
            if let val = (((dictHome.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as AnyObject).object(at: 1) as AnyObject).object(forKey: "children")
            {
                countVod = countVod+1
                arrayShows = (((dictHome.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as AnyObject).object(at: 1) as AnyObject).object(forKey: "children") as! NSArray
                showsDict.setObject(arrayShows, forKey: "shows" as NSCopying)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.arraySideMenuKeys.removeAllObjects()
                appDelegate.arraySideMenuKeys = ["sports","shows"]
                UserDefaults.standard.set(appDelegate.arraySideMenuKeys, forKey: "sideKeys")
                sideMenuArray.add(showsDict)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sideMenu"), object: sideMenuArray)
    }
    func get_Home_Date()
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            
            let json = [:] as! [String:String]
            print("json >>>",json)
            var url = String(format: "%@%@device/ios/display_offset/0/display_limit/20/content_count/20", LoginCredentials.Homeapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
            
            print("url >>>",url)
            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info: "getHomeResponse")
            // objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getHomeResponse" )
        }
        else
        {
            let json = [:] as! [String:String]
            print("json >>>",json)
            var url = String(format: "%@%@device/ios/display_offset/0/display_limit/20/content_count/20", LoginCredentials.Homeapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
            
            print("url >>>",url)
            //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getHomeResponse" )
            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info: "getHomeResponse")
        }
    }
    
    // MARK:-
    func fetchFromDB()
    {
        self.catListDataSave()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        homeListArray.removeAllObjects()
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataDict")
            do
            {
                datadict = try managedContext.fetch(fetchRequest)
                if (datadict.count>0)
                {
                    let person = datadict[0]
                    
                    //dictpropertyinmanagedobject
                    
                    let data = person.value(forKeyPath: "dict") as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    dict = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject") as! NSMutableArray
                    homeListArray.removeAllObjects()
                    homeListArray = dict
                    upcominnB = UserDefaults.standard.value(forKey: "boolUpcoming") as! Bool
                    countCat = UserDefaults.standard.value(forKey: "countCat") as! Int
                    allkeyArray = (UserDefaults.standard.value(forKey: "allkeyArray") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    let bannerDecode  = UserDefaults.standard.object(forKey: "BannerArray") as! Data
                    bannerArray = NSKeyedUnarchiver.unarchiveObject(with: bannerDecode) as! NSMutableArray
                    
                    let decoded  = UserDefaults.standard.object(forKey: "version") as! Data
                    let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
                    dashversion = (decodedTeams.value(forKey: "dash_version") as! String)
                    liveversion = (decodedTeams.value(forKey: "live_version") as! String)
                    
                    unarchiver.finishDecoding()
                    let strLaunch = UserDefaults.standard.value(forKey: "splash") as! String
                    if strLaunch == "relaunch"
                    {
                        UserDefaults.standard.set("again", forKey: "splash")
                        //                        if isvideonplayingmorethan4sec() {
                        //                            self.removevideoplayer()
                        //                        }
                        //                        else
                        //                        {
                        //                            let delaytime = 6.0 - currentplayertime
                        //                            self.perform(#selector(removevideoplayer), with: nil, afterDelay: delaytime)
                        //                        }
                    }
                    else
                    {
                        //self.removevideoplayer()
                    }
                    // self.getappversion(str: dashversion)
                    
                }
                else
                {
                    dashversion = "0.0"
                    liveversion = "0.0"
                    // self.getappversion(str: dashversion)
                }
                
            }
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        }
        else {
            // Fallback on earlier versions
        }
        
        self.getSubscribePlans()
    }
    @objc func get_Response(notification: NSNotification)
    {
        //Core data save objects
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        homeListArray.removeAllObjects()
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictHome=responseDict.mutableCopy() as! NSMutableDictionary
        let versionDict = NSKeyedArchiver.archivedData(withRootObject: dictHome.value(forKey: "version") as! NSDictionary)
        
        UserDefaults.standard.set(versionDict, forKey: "version")
        var arrayBanner:NSArray=NSArray()
        arrayBanner = (dictHome.value(forKey: "dashboard") as AnyObject).object(forKey: "feature_banner") as! NSArray
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.bannerArrays=arrayBanner.mutableCopy() as! NSMutableArray
        bannerArray=arrayBanner.mutableCopy() as! NSMutableArray
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: bannerArray)
        UserDefaults.standard.setValue(encodedData, forKey: "BannerArray")
        print(dictHome)
        let tempDict:NSMutableDictionary=NSMutableDictionary()
        tempDict.setObject((dictHome.value(forKey: "recomended")! as AnyObject), forKey: "recomended" as NSCopying)
        homeListArray.add(tempDict)
        
        homeListArray.add(sportsDict)
        
        // sideMenuArray.add(sportsDict)
      
        let arrayLiveTemp = dictHome.value(forKey: "live") as! NSArray
        let liveListArry:NSMutableArray = NSMutableArray()
        if arrayLiveTemp.count > 0 {
            liveListArry.add(arrayLiveTemp.object(at: 0))
        }
        else
        {
            
        }
        let tempDict1:NSMutableDictionary=NSMutableDictionary()
        tempDict1.setObject(liveListArry, forKey: "live" as NSCopying)
        homeListArray.add(tempDict1)
          let liveArry:NSMutableArray = NSMutableArray()
        for index in 0..<arrayLiveTemp.count
        {
            if index == 0
            {}
            else
            {
                liveArry.add(arrayLiveTemp.object(at: index))
            }
        }
        let tempDict2:NSMutableDictionary=NSMutableDictionary()
        tempDict2.setObject(liveArry, forKey: "liveUpcoming" as NSCopying)
        if liveArry.count>0 {
            upcominnB = true
            homeListArray.add(tempDict2)
            allkeyArray = ["recomended","sports","live","liveUpcoming"]

//            allkeyArray = ["recomended"]
//            if(sportsDict.count>0)
//            {
//              allkeyArray.add("sports")
//            }
//            else if(arrayLiveTemp.count>0)
//            {
//               allkeyArray.add("live")
//            }
//          //allkeyArray.add("liveUpcoming")
  
        }
        else
        {
            upcominnB = false
            allkeyArray = ["recomended","sports","live"]

//            allkeyArray = ["recomended"]
//
//
//            if(sportsDict.count>0)
//            {
//                allkeyArray.add("sports")
//            }
//            else if(arrayLiveTemp.count>0)
//            {
//                allkeyArray.add("live")
//            }
            
        
        }
        
        var versionDic = NSDictionary()
        versionDic = dictHome.value(forKey: "version") as! NSDictionary
        strLiveVersion = (versionDic.value(forKey: "live_version") as! NSString) 
        
        var homeArrayCat:NSArray=NSArray()
        homeArrayCat = (dictHome.value(forKey: "dashboard") as AnyObject).object(forKey: "home_category") as! NSArray
        var homeCat:NSMutableArray=NSMutableArray()
        homeCat = homeArrayCat.mutableCopy() as! NSMutableArray
        countCat=homeCat.count
        countCat=countCat+4
        for items in 0..<homeCat.count
        {
            let strCatName = (homeCat.object(at: items) as AnyObject).object(forKey:"cat_name") as! String
            var homeArrayCat:NSArray=NSArray()
            homeArrayCat = (homeCat.object(at: items) as AnyObject).object(forKey:"cat_cntn") as! NSArray
            homeListArray.add(homeArrayCat.mutableCopy() as! NSMutableArray)
            //Anamika
            allkeyArray.add(strCatName)
        }
        if countVod == 2
        {
            homeListArray.add(showsDict)
            allkeyArray.add("shows")
        }
        else
        {
            
        }
        homeAllData = dictHome
        UserDefaults.standard.set(countCat, forKey: "countCat")
        UserDefaults.standard.set(upcominnB, forKey: "boolUpcoming")
        UserDefaults.standard.set(allkeyArray, forKey: "allkeyArray")
        self.deleteAllData(entity: "DataDict")
        savedata(dict: homeListArray)
        self.tblHomeData.reloadData()
        self.getSubscribePlans()
        let strLaunch = UserDefaults.standard.value(forKey: "splash") as! String
        if strLaunch == "relaunch"
        {
            UserDefaults.standard.set("again", forKey: "splash")
            //            if isvideonplayingmorethan4sec() {
            //                self.removevideoplayer()
            //            }
            //            else
            //            {
            //                let delaytime = 6.0 - currentplayertime
            //                self.perform(#selector(removevideoplayer), with: nil, afterDelay: delaytime)
            //            }
        }
        //print("homeListArray >>>>>",homeListArray)
        
    }
    
    // MARK: - Save Data in database
    
    
    
    func savedata(dict: NSMutableArray)
    {
        
        
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(dict, forKey: "dictpropertyinmanagedobject")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "DataDict",
                                                    in: managedContext)!
            
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data, forKeyPath: "dict")
            
            do {
                try managedContext.save()
                datadict.append(person)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        else
        {
        }
    }
    func home_cList(startInexing:String)
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as! [String:String]
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getHomeNewsDataResponse")
            
            
           // http://staging.multitvsolution.com:9001/automatorapi/v6/content/list/token/58cfdeb8438eb/device/ios/current_offset/10/max_counter/10/cat_id/1767
            var url = String(format: "%@%@device/ios/current_offset/%@/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Constants.APP_Token,startInexing as String,strMoreID as String)
            url = url.trimmingCharacters(in: .whitespaces)
            
            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getHomeNewsDataResponse")
            // objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getHomeNewsDataResponse" )
        }
        else
        {
            let json = [:] as! [String:String]
             let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getHomeNewsDataResponse")
          var url = String(format: "%@%@device/ios/current_offset/%@/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Constants.APP_Token,startInexing as String,strMoreID as String)
            url = url.trimmingCharacters(in: .whitespaces)
            
            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getHomeNewsDataResponse")
        }
    }
    @objc func getHomeNewsDataResponse(notification: NSNotification)
    {
        var responseDict:NSDictionary=NSDictionary()
        var dictContent:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictContent=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        
        
        if let _ = dictContent.object(forKey: "code")
        {
            if(dictContent.object(forKey: "code") as! Int == 0)
            {
                return
            }
            
        }

        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        if spinner != nil
        {
            spinner.isHidden = false
        }
        else
        {
            
        }
        if arrayTempContent.count > 0
        {
            var homeReCat:NSMutableArray=NSMutableArray()
            homeReCat = arrayTempContent.mutableCopy() as! NSMutableArray
            isNewDataNewsLoading = false
            var temp:NSMutableArray=NSMutableArray()
            temp  = NSKeyedUnarchiver.unarchiveObject(
                with: NSKeyedArchiver.archivedData(withRootObject: self.homeListArray.object(at: subCatIndexScroll))) as! NSMutableArray
            temp.addObjects(from: homeReCat as [AnyObject])
            self.homeListArray.removeObject(at: subCatIndexScroll)
            
            self.homeListArray.insert(temp, at: subCatIndexScroll)
            
            self.deleteAllData(entity: "DataDict")
            savedata(dict: self.homeListArray)
            self.tblHomeData.reloadData()
            higLightCell.highlightCollectionView.reloadData()
        }
        else
        {
            isNewDataNewsLoading = true
        }
    }
    func getSubscribePlans()
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            var json = ["uid":strID,"device":"ios"]
            json = [:]
            print("subscribe json >>",json)
            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
            url = "\(Constants.SubscriptionBaseUrl)/subscriptionapi/v6/spackage/subscription/token/\(Constants.APP_Token)device/ios/uid/\(strID)"
            url = url.trimmingCharacters(in: .whitespaces)
            print("subscribe url >>",url)
            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getHomePackageList")
        }
        else
        {
            var json = ["device":"ios"]
            json = [:]
            //print("json >>",json)
            print("subscribe json >>",json)
            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
            url = "\(Constants.SubscriptionBaseUrl)/subscriptionapi/v6/spackage/subscription/token/\(Constants.APP_Token)device/ios"
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getHomePackageList")
        }
        
        
        
//        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//        {
//            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
//            let json = ["uid":strID]
//            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
//            url = url.trimmingCharacters(in: .whitespaces)
//
//            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getHomePackageList")
//        }
//        else
//        {
//            let json = ["device":"ios"]
//            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
//            url = url.trimmingCharacters(in: .whitespaces)
//
//            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getHomePackageList")
//        }
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    @objc func getHomePackageList(notification: NSNotification)
    {
        
        
        
        
        
        var responseDict:NSDictionary=NSDictionary()
        // print("notification>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        
        if(responseDict.value(forKey: "code") as! Int == 0)
        {
         LoginCredentials.UserSubscriptiondetail = NSArray()
        }
        
        else
        {
        let subscribeDict=(responseDict.object(forKey:"result") as AnyObject) as! NSDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        dictResponse = subscribeDict.mutableCopy() as! NSMutableDictionary
        print("sub scribe list >>%@",dictResponse)
          LoginCredentials.UserSubscriptiondetail = (dictResponse.value(forKey: "package_list") as AnyObject) as! NSArray
        }
         self.removeLoader()
        self.tblHomeData .reloadData()
        
        
//        var responseDict:NSDictionary=NSDictionary()
//        // print("notification>>>>",notification.object)
//        var dictResponse:NSMutableDictionary=NSMutableDictionary()
//        responseDict=notification.object as! NSDictionary
//        let subscribeDict=(responseDict.object(forKey:"result") as AnyObject) as! NSDictionary// as! NSMutableDictionary//as! NSMutableDictionary
//        let susubscription_mode = nullToNil(value: subscribeDict.object(forKey: "subscription_mode") as AnyObject)
//        UserDefaults.standard.set(susubscription_mode as! String, forKey: "susubscription_mode")
//
//
//        dictResponse = subscribeDict.mutableCopy() as! NSMutableDictionary
//        var arraySubscribe:NSArray=NSArray()
//        arraySubscribe = (dictResponse.value(forKey: "subscription_list") as AnyObject) as! NSArray
//        var arraySubscribed:NSArray=NSArray()
//        arraySubscribed = (dictResponse.value(forKey: "subscribed_item") as AnyObject) as! NSArray
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.subscribedItemArrays = arraySubscribed.mutableCopy() as! NSMutableArray
//        //subscribedItemArrays
//        arrayPackage.removeAllObjects()
//        for item in 0..<arraySubscribe.count
//        {
//            let subListDict = arraySubscribe.object(at: item) as! NSDictionary
//            var tempDict:NSMutableDictionary=NSMutableDictionary()
//            tempDict.setObject(subListDict.object(forKey: "s_id"), forKey: "s_id" as NSCopying)
//            tempDict.setObject(subListDict.object(forKey: "s_name"), forKey: "s_name" as NSCopying)
//            tempDict.setObject(subListDict.object(forKey: "s_subscription_validity"), forKey: "s_subscription_validity" as NSCopying)
//
//            let arraySub = subListDict.object(forKey: "s_pakcage") as! NSArray
//            for index in 0..<1 {
//                //    print("212")
//                let subListDict = arraySub.object(at: index) as! NSDictionary
//                tempDict.setObject(subListDict.object(forKey: "circle"), forKey: "circle" as NSCopying)
//                tempDict.setObject(subListDict.object(forKey: "end_date"), forKey: "end_date" as NSCopying)
//                tempDict.setObject(subListDict.object(forKey: "p_currency"), forKey: "p_currency" as NSCopying)
//                tempDict.setObject(subListDict.object(forKey: "p_name"), forKey: "p_name" as NSCopying)
//                tempDict.setObject(subListDict.object(forKey: "p_price"), forKey: "p_price" as NSCopying)
//                tempDict.setObject(subListDict.object(forKey: "package_id"), forKey: "package_id" as NSCopying)
//                tempDict.setObject(subListDict.object(forKey: "start_date"), forKey: "start_date" as NSCopying)
//                arrayPackage.add(tempDict)
//            }
//        }
 //       self.removeLoader()
    //    self.tblHomeData .reloadData()
    }
    func moreBtnAction(sender:UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
        UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
        if (videoBgPlayer != nil) {
            videoBgPlayer.pause()
        }
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        moreBtnTag = sender.tag
        
        if upcominnB == true
        {
            if (sender.tag==0)
            {
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"recomended") as! NSArray
            }
            else if (sender.tag==1)
            {
                if let _ = (homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"sports")
                {
                    
                }
                else
                {
                    return
                }
                
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"sports") as! NSArray
                sportsIconContentArray = listArray.mutableCopy() as! NSMutableArray
                strType="sports"
                self.performSegue(withIdentifier: "showSports", sender: self)
            }
            else if(sender.tag==2)
            {
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"live") as! NSArray
            }
            else if(sender.tag==3)
            {
                
                if let _ = (homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"liveUpcoming")
                {
                    
                }
                else
                {
                    return
                }
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"liveUpcoming") as! NSArray
                strHeading = "Live"
                let liveArray=(homeListArray.object(at:2) as AnyObject).object(forKey:"live") as! NSArray
                let liveArrayOne = liveArray as! NSMutableArray
                let liveArrayTwo = listArray as! NSMutableArray
                let mergedArray = liveArrayOne.addingObjects(from: liveArrayTwo as [AnyObject])
                print(mergedArray)
                arrayLiveData = (mergedArray  as NSArray).mutableCopy() as! NSMutableArray
                
                strID  = "0230230203023" as NSString!
                self.performSegue(withIdentifier: "liveListShow", sender: self)
            }
            else if(sender.tag==countCat)
            {
                
                if let _ = (homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"shows")
                {
                    
                }
                else
                {
                    return
                }
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"shows") as! NSArray
                sportsIconContentArray = listArray.mutableCopy() as! NSMutableArray
                strType="shows"
                self.performSegue(withIdentifier: "showSports", sender: self)
            }
            else
            {
                listArray = homeListArray.object(at:sender.tag) as! NSArray
                newsContentArray = listArray.mutableCopy() as! NSMutableArray
                homeDetailDict = listArray.object(at:0) as! NSDictionary
                sendListCount = listArray.count
                strID  = homeDetailDict.object(forKey: "category_id") as! NSString!
                strHeading = homeDetailDict.object(forKey: "category") as! NSString!
                self.performSegue(withIdentifier: "newsPush", sender: self)
            }
        }
        else
        {
            if (sender.tag==0)
            {
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"recomended") as! NSArray
            }
            else if (sender.tag==1)
            {
                
                if let _ = (homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"sports")
                {
                    
                }
                else
                {
                    return
                }
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"sports") as! NSArray
                strType="sports"
                sportsIconContentArray = listArray.mutableCopy() as! NSMutableArray
                self.performSegue(withIdentifier: "showSports", sender: self)
            }
            else if(sender.tag==2)
            {
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"live") as! NSArray
            }
            else if(sender.tag==countCat)
            {
                if let _ = (homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"shows")
                {
                    
                }
                else
                {
                    return
                }
                listArray=(homeListArray.object(at:sender.tag) as AnyObject).object(forKey:"shows") as! NSArray
                strType="shows"
                sportsIconContentArray = listArray.mutableCopy() as! NSMutableArray
                self.performSegue(withIdentifier: "showSports", sender: self)
            }
            else
            {
                listArray=homeListArray.object(at:sender.tag)  as! NSArray
                homeDetailDict = listArray.object(at:0) as! NSDictionary
                sendListCount = listArray.count
                newsContentArray = listArray.mutableCopy() as! NSMutableArray
                strID  = homeDetailDict.object(forKey: "category_id") as! NSString!
                strHeading = homeDetailDict.object(forKey: "category") as! NSString!
                self.performSegue(withIdentifier: "newsPush", sender: self)
            }
        }
    }
    
    //TableView View Delegates and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if(section == 0)
       {
        if(bannerArray.count == 0)
        {
          return 0;
        }
        }
        
        return 1;
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
      
        return homeListArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var celld:UITableViewCell = UITableViewCell()
        
        if(indexPath.section == 0)
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: bannerTblCellIdentifier) as? BannerTblViewCell
            if cell == nil
            {
                cell = BannerTblViewCell(style: UITableViewCellStyle.default, reuseIdentifier: bannerTblCellIdentifier)
            }
            cell?.showSlider.delegate = self
            cell?.pageControl.currentPage = 0
            cell?.pageControl.tintColor = UIColor.red
            cell?.pageControl.pageIndicatorTintColor = UIColor.white
            cell?.pageControl.currentPageIndicatorTintColor = UIColor.red
            cell?.strType = "homeBanner"
            let bannerDecode  = UserDefaults.standard.object(forKey: "BannerArray") as! Data
            bannerArray = NSKeyedUnarchiver.unarchiveObject(with: bannerDecode) as! NSMutableArray
            cell?.call_UI(bannerArray: bannerArray)
            // cell?.backgroundColor = UIColor.red
            return cell!
        }
        else if(indexPath.section==2)
        {
            let cell:LiveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LiveCell") as! LiveTableViewCell
            cell.liveCollectionView.reloadData()
            cell.liveCollectionView!.register(UINib(nibName: "LiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveCollectionCell")
            cell.liveCollectionView.tag = indexPath.section
            cell.liveCollectionView.delegate = self
            cell.liveCollectionView.dataSource = self
            // cell.backgroundColor = UIColor.green
            return cell
        }
        else if(indexPath.section==3)
        {
            if upcominnB == true
            {
                let cell:SubLiveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "subLive") as! SubLiveTableViewCell
                cell.subLiveCollectionView!.register(UINib(nibName: "SubLiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubLiveCollectionViewCell")
                cell.subLiveCollectionView.tag = indexPath.section
                cell.subLiveCollectionView.delegate = self
                cell.subLiveCollectionView.dataSource = self
                //  cell.backgroundColor = UIColor.yellow
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "highlightTblCell", for: indexPath) as! HighlightTableViewCell
                cell.highlightCollectionView.reloadData()
                cell.highlightCollectionView!.register(UINib(nibName: "HighlightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HighlightCollectionViewCell")
                cell.highlightCollectionView.tag = indexPath.section
                cell.highlightCollectionView.delegate = self
                cell.highlightCollectionView.dataSource = self
                //  cell.backgroundColor = UIColor.blue
                return cell
            }
            
        }
        else if (indexPath.section == countCat)
        {
            let cell:TrendingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "trendingCell") as! TrendingTableViewCell
            cell.trendingCollectionView.reloadData()
            cell.trendingCollectionView!.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
            cell.trendingCollectionView.tag = indexPath.section
            cell.trendingCollectionView.delegate = self
            cell.trendingCollectionView.dataSource = self
            
            return cell
        }
        else if (indexPath.section == 1)
        {
            let cell:ShowsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "showTblCell") as! ShowsTableViewCell
            cell.showsCollectionView!.register(UINib(nibName: "ShowsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowsCollectionViewCell")
            cell.showsCollectionView.tag = indexPath.section
            cell.showsCollectionView.delegate = self
            cell.showsCollectionView.dataSource = self
            // cell.backgroundColor = UIColor.purple
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightTblCell", for: indexPath) as! HighlightTableViewCell
            cell.highlightCollectionView.reloadData()
            cell.highlightCollectionView!.register(UINib(nibName: "HighlightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HighlightCollectionViewCell")
            cell.highlightCollectionView.tag = indexPath.section
            cell.highlightCollectionView.delegate = self
            cell.highlightCollectionView.dataSource = self
            // cell.backgroundColor = UIColor.orange
            return cell
        }
        
    }
    func refreshBottom()
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if upcominnB == true
        {
            if (section==0)
            {
                return 1
            }
            else if (section==3)
            {
                return 20
            }
            else
            {
                return 30
            }
        }
        else
        {
            if (section==0)
            {
                return 1
            }
            else
            {
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var viewForHeader:UIView  =  UIView()
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 30))
        viewForHeader  =  UIView.init(frame: rect)
        //viewForHeader.backgroundColor = UIColor.red
        if section == 0
        {
            
        }
        else
        {
            var lblHeaderView:UILabel = UILabel()
            let rectLbl:CGRect;
            if section == 1 {
                rectLbl = CGRect(origin: CGPoint(x: 10,y :2), size: CGSize(width: self.view.frame.size.width - 90, height: 40))
            }
            else
            {
                rectLbl = CGRect(origin: CGPoint(x: 10,y :2), size: CGSize(width: self.view.frame.size.width - 90, height: 40))
            }
            
            lblHeaderView  =  UILabel.init(frame: rectLbl)
            lblHeaderView.text = (allkeyArray.object(at: section) as AnyObject).uppercased
            lblHeaderView.numberOfLines = 2
            lblHeaderView.font =  UIFont (name: "Ubuntu-Bold", size: 16)
            lblHeaderView.textColor = UIColor.white
            viewForHeader.backgroundColor = UIColor.clear//(colorLiteralRed: 240.0, green: 241.0, blue: 241.0, alpha: 1.0)
            
            let moreBtn = UIButton()
            
            moreBtn.setTitle("SEE ALL>", for: .normal)
            
            //moreBtn.titleLabel?.text = "SEE ALL>"
            
            moreBtn.titleLabel!.font =  UIFont (name: "Ubuntu", size: 10)//UIFont(name: "Montserrat", size: 10)
            // moreBtn.backgroundColor=UIColor.init(colorLiteralRed: 24.0/255.0, green: 40.0/255.0, blue: 78.0/255.0, alpha: 1.0)
            moreBtn.setTitleColor(UIColor.lightText, for: .normal)
            // moreBtn.layer.cornerRadius=2.0
            moreBtn.tag=section
            
            moreBtn.addTarget(self, action: #selector(moreBtnAction), for: .touchUpInside)
            if upcominnB == true
            {
                if section == 2
                {
                    viewForHeader.addSubview(lblHeaderView)
                }
                else if (section==3)
                {
                    let rectMore = CGRect(origin: CGPoint(x: viewForHeader.frame.size.width-70,y :2), size: CGSize(width: 60, height: 20))
                    moreBtn.frame = rectMore//CGRectMake(viewForHeader.frame.size.width-70, 5, 60, 20)
                    viewForHeader.addSubview(moreBtn)
                }
                else
                {
                    let rectMore:CGRect;
                    if section == 1
                    {
                        rectMore = CGRect(origin: CGPoint(x: viewForHeader.frame.size.width-70,y :13), size: CGSize(width: 60, height: 20))
                    }
                    else
                    {
                        rectMore = CGRect(origin: CGPoint(x: viewForHeader.frame.size.width-70,y :13), size: CGSize(width: 60, height: 25))
                    }
                    
                    moreBtn.frame = rectMore//CGRectMake(viewForHeader.frame.size.width-70, 5, 60, 20)
                    viewForHeader.addSubview(moreBtn)
                    viewForHeader.addSubview(lblHeaderView)
                }
            }
            else
            {
                if section == 2
                {
                    viewForHeader.addSubview(lblHeaderView)
                }
                else
                {
                    let rectMore:CGRect;
                    if section == 1 {
                        rectMore = CGRect(origin: CGPoint(x: viewForHeader.frame.size.width-70,y :13), size: CGSize(width: 60, height: 20))
                    }
                    else
                    {
                        rectMore = CGRect(origin: CGPoint(x: viewForHeader.frame.size.width-70,y :13), size: CGSize(width: 60, height: 25))
                    }
                    
                    
                    moreBtn.frame = rectMore//CGRectMake(viewForHeader.frame.size.width-70, 5, 60, 20)
                    viewForHeader.addSubview(moreBtn)
                    viewForHeader.addSubview(lblHeaderView)
                }
            }
            viewForHeader.backgroundColor=UIColor.clear
            
        }
        // tableView.tableHeaderView = viewForHeader
        // tableView.contentInset = UIEdgeInsetsMake(CGFloat(30), 0, 0, 0)
        if(section == 2)
        {
            if(((homeListArray.object(at: 2) as! NSDictionary).value(forKey: "live") as! NSArray).count == 0)
            {
              return nil
            }
        }
        
        return viewForHeader
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if upcominnB == true
        {
            if (indexPath.section == 0)
            {
                if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                    return 260
                }
                else if self.view.frame.size.width > 380 {
                    return 280
                }
                else
                {
                    return 220
                }
            }
            else if (indexPath.section == 2)
            {
                
                if(((homeListArray.object(at: 2) as! NSDictionary).value(forKey: "live") as! NSArray).count == 0)
                {
                  return 0
                }
                let screenSize = self.view.frame.size.width
                if screenSize < 330
                {
                    return 240
                }
                else if screenSize > 330 &&  screenSize < 380
                {
                    return 275
                }
                else
                {
                    return 290
                }
                
                
                
            }
            else if (indexPath.section == 3)
            {
                let screenSize = self.view.frame.size.width
                if screenSize < 330
                {
                    return 125
                }
                else if screenSize > 330 &&  screenSize < 380
                {
                    return 135
                }
                else
                {
                    return 145
                }
                // return 115
            }
            else if (indexPath.section == countCat)
            {
                return 200
            }
            else if (indexPath.section == 1)
            {
                let screenSize = self.view.frame.size.width
                if screenSize < 330
                {
                    return 155
                }
                else if screenSize > 330 && screenSize < 380
                {
                    return 190
                }
                else
                {
                    return 200
                }
            }
            else
            {
                // return 220
                if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                    return 260
                }
                else if self.view.frame.size.width > 380 {
                    return 280
                }
                else
                {
                    return 220
                }
            }
        }
        else
        {
            if (indexPath.section == 0)
            {
                if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                    return 260
                }
                else if self.view.frame.size.width > 380 {
                    return 280
                }
                else
                {
                    return 220
                }
                
            }
            else if (indexPath.section == 2)
            {
                
                if(((homeListArray.object(at: 2) as! NSDictionary).value(forKey: "live") as! NSArray).count == 0)
                {
                    return 0
                }
                
                let screenSize = self.view.frame.size.width
                if screenSize < 330
                {
                    return 240
                }
                else if screenSize > 330 &&  screenSize < 380
                {
                    return 275
                }
                else
                {
                    return 300
                }
            }
            else if (indexPath.section == countCat)
            {
                return 200
            }
            else if (indexPath.section == 1)
            {
                let screenSize = self.view.frame.size.width
                if screenSize < 330
                {
                    return 155
                }
                else if screenSize > 330 && screenSize < 380
                {
                    return 190
                }
                else
                {
                    return 200
                }
            }
            else
            {
                // return 220
                if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                    return 260
                }
                else if self.view.frame.size.width > 380 {
                    return 280
                }
                else
                {
                    return 220
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if(tableView.indexPathsForVisibleRows?.index(of: indexPath) != nil)
        {
            if indexPath.section == 2
            {
            }
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if(tableView.indexPathsForVisibleRows?.index(of: indexPath) == nil)
        {
            
            if indexPath.section == 2
            {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if collectionView.tag == 1
        {
            var sizeCalculate = self.view.frame.size.width / 3
            //   print("collectionView.frame.size.height>>>",sizeCalculate)
            sizeCalculate = sizeCalculate - 15
            let screenSize = self.view.frame.size.width
            
            if screenSize < 330
            {
                return CGSize(width: sizeCalculate+10, height: 150)
            }
            else
            {
                return CGSize(width: sizeCalculate+10, height: collectionView.frame.size.height)
            }
        }
        else if collectionView.tag == 2
        {
            return CGSize(width: self.view.frame.size.width, height: collectionView.frame.size.height)
        }
        else if collectionView.tag == 3
        {
            if upcominnB == true
            {
                return CGSize(width: (self.view.frame.size.width/2)-13, height: collectionView.frame.size.height)
            }
            else
            {
                return CGSize(width: self.view.frame.size.width-25, height: collectionView.frame.size.height)
            }
        }
        else
        {
            return CGSize(width: self.view.frame.size.width-25, height: collectionView.frame.size.height)
        }
        
    }
    
    //    func collectionView(collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    //        return 1.0
    //    }
    //
    //    func collectionView(collectionView: UICollectionView, layout
    //        collectionViewLayout: UICollectionViewLayout,
    //                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    //        return 1.0
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //  print("collectionView.tag in rows>>>",countCat)
        if upcominnB == true
        {
            if (collectionView.tag==0)
            {
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"recomended")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"recomended") as! NSArray
                return listArray.count
                }
                else
                {
                  return 0
                }
            }
            if (collectionView.tag==1)
            {
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"sports")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"sports") as! NSArray
                return listArray.count
                }
                else
                {
                  return 0
                }
            }
            if (collectionView.tag==countCat)
            {
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"shows")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"shows") as! NSArray
                return listArray.count
                }
                else
                {
                  return 0
                }
            }
            else if(collectionView.tag==2)
            {
                
                // listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"live") as! NSArray
                return 1
                
               
                
            }
            else if(collectionView.tag==3)
            {
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"liveUpcoming")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"liveUpcoming") as! NSArray
                return listArray.count
                }
                else
                {
                  return 0
                }
            }
            else
            {
                //   print("homeListArray.objectAtIndex(collectionView.tag) >>>>",homeListArray.object(at: collectionView.tag))
                
                //  if let val = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"cat_cntn")
                //{
                listArray=homeListArray.object(at: collectionView.tag) as! NSArray
                //    }
                return listArray.count
            }
        }
        else
        {
            if (collectionView.tag==0)
            {
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"recomended")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"recomended") as! NSArray
                return listArray.count
                }
                else
                {
                    return 0
                }
            }
            if (collectionView.tag==1)
            {
               
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"sports")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"sports") as! NSArray
                 return listArray.count
                }
                else
                {
                    return 0
                }
            }
            if (collectionView.tag==countCat)
            {
                if let _ = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"shows")
                {
                listArray=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"shows") as! NSArray
                return listArray.count
                }
                else
                {
                    return 0
                }
            }
            else if(collectionView.tag==2)
            {
                return 1
            }
                
            else
            {
                //     print("homeListArray.objectAtIndex(collectionView.tag) >>>>",homeListArray.objectAtIndex(collectionView.tag))
                //   if let val = (homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"cat_cntn")
                // {
                listArray=homeListArray.object(at: collectionView.tag)  as! NSArray
                //}
                return listArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        AppUtility.lockOrientation(.portrait)
        //   NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        // self.navigationController?.pushViewController(detailedVC!, animated: true)
        if (videoBgPlayer != nil) {
            videoBgPlayer.pause()
        }
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        self.loadMore()
        self.playerController.removeFromParentViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
        UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
        // print("appDelegate.userViewTime ",UserDefaults.standard.value(forKey: "userCurrentPlay") )
        if upcominnB == true
        {
            //       print("collectionView.tag print >>>",collectionView.tag)
            if (collectionView.tag==0)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"recomended") as! NSArray
            }
            else if (collectionView.tag==1)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"sports") as! NSArray
                
                sport_id = (listArray.object(at:indexPath.item) as AnyObject).value(forKey:"id") as? String
                
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                //         print("homeDetailDict >>>>",homeDetailDict)
                self.performSegue(withIdentifier: "showSportsList", sender: self)
            }
            else if(collectionView.tag==2)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"live") as! NSArray
            }
            else if(collectionView.tag==3)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"liveUpcoming") as! NSArray
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                
                if((homeDetailDict.value(forKey: "status") as! String) == "1")
                {
                    liveContentIDStr = homeDetailDict.value(forKey: "id") as! String as NSString
                    livePlayerUrl = URL(string:homeDetailDict.value(forKey: "url") as! String)
                    self.performSegue(withIdentifier: "livePlayerShow", sender: self)
                 }
                
                
            }
            else if (collectionView.tag==countCat)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"shows") as! NSArray
                sport_id = (listArray.object(at:indexPath.item) as AnyObject).value(forKey:"id") as? String
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                self.performSegue(withIdentifier: "showSportsList", sender: self)
            }
            else
            {
                listArray=homeListArray.object(at:collectionView.tag)  as! NSArray
                detailContentArray = listArray.mutableCopy() as! NSMutableArray
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                strDetailType = "home"
                self.performSegue(withIdentifier: "showDetail", sender: self)
            }
        }
        else
        {
            if (collectionView.tag==0)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"recomended") as! NSArray
            }
            else if (collectionView.tag==1)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"sports") as! NSArray
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                sport_id = (listArray.object(at:indexPath.item) as AnyObject).value(forKey:"id") as? String
                self.performSegue(withIdentifier: "showSportsList", sender: self)
            }
            else if(collectionView.tag==2)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"live") as! NSArray
            }
            else if (collectionView.tag==countCat)
            {
                listArray=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"shows") as! NSArray
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                sport_id = (listArray.object(at:indexPath.item) as AnyObject).value(forKey:"id") as? String
                self.performSegue(withIdentifier: "showSportsList", sender: self)
            }
            else
            {
                listArray=homeListArray.object(at:collectionView.tag) as! NSArray
                detailContentArray = listArray.mutableCopy() as! NSMutableArray
                homeDetailDict = listArray.object(at:indexPath.item) as! NSDictionary
                strDetailType = "home"
                self.performSegue(withIdentifier: "showDetail", sender: self)
            }
        }
    }
    func loadMore()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "load"
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        //  print("called live",collectionView.tag)
        if upcominnB == true {
            if collectionView.tag == 1 || collectionView.tag == 2 || collectionView.tag == 3 || collectionView.tag == countCat
            {
                
                
            }
            else
            {
                
            }
        }
        else
        {
            if collectionView.tag == 1 || collectionView.tag == 2 || collectionView.tag == countCat
            {
                
                
            }
            else
            {
                
            }
        }
        
    }
    func clearCell(cell:HighlightCollectionViewCell){
        if let iv = cell.logoImgVw
        {
            iv.animationImages = nil
            iv.image = nil
            
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView.tag > 3// || collectionView.tag == 5
        {
            let lastSectionIndex = collectionView.numberOfSections - 1
            let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex
            {
                
                //                self.objLoader.frame=CGRect(x: CGFloat(cell.contentView.frame.size.width - 44), y: CGFloat(70), width: 44, height: CGFloat(44))
                //                self.objLoader.createLoader()
                //                cell.addSubview(self.objLoader)
                //                cell.addSubview.bringSubview(toFront:self.objLoader)
                
                spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
                spinner.color = UIColor.red
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(cell.contentView.frame.size.width - 44), y: CGFloat(70), width: 44, height: CGFloat(44))
                cell.addSubview(spinner)
                spinner.isHidden = true
                
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath)
    {
    }
    
  
    func scrollToNearestVisibleCollectionViewCell()
    {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let headerView: UIView = scrollView.superview!
        
        if (scrollView.subviews[0] as? UICollectionViewCell != nil)
        {
            let xYsis:Int = Int(scrollView.frame.origin.x)
            let yXsis:Int = Int(scrollView.frame.origin.y)
            let height:Int = Int(scrollView.frame.size.height)
            
            let bottomEdge:CGFloat = scrollView.contentOffset.x + scrollView.frame.size.width
            if (bottomEdge >= scrollView.contentSize.width) {
                // we are at the end
                
                print("height = ",height)
                if xYsis == 5 && yXsis == 10 && (height == 201 || height == 231 || height == 241 || height == 261)
                {
                    
                    let tableviewcell: HighlightTableViewCell = headerView.superview as! HighlightTableViewCell
                    higLightCell = tableviewcell
                    listArray=homeListArray.object(at:tableviewcell.highlightCollectionView.tag) as! NSArray
                    if subCatIndexScroll == tableviewcell.highlightCollectionView.tag
                    {
                        
                    }
                    else
                    {
                        isNewDataNewsLoading = false
                    }
                    if isNewDataNewsLoading == true
                    {
                        
                    }
                    else
                    {
                        isNewDataNewsLoading = true
                        
                        homeDetailDict = listArray.object(at:0) as! NSDictionary
                        
                        let cat_ID = nullToNil(value: homeDetailDict.object(forKey: "category_id") as AnyObject) as! NSString
                        if cat_ID == ""
                        {
                            let arrayID  = homeDetailDict.object(forKey: "category_ids") as! NSArray
                            if arrayID.count > 0 {
                                strMoreID = arrayID.object(at: 0) as! NSString
                            }
                        }
                        else
                        {
                            strMoreID  = homeDetailDict.object(forKey: "category_id") as! NSString!
                        }
                        
                        if spinner != nil {
                            spinner.isHidden = false
                        }
                        else
                        {
                            
                        }
                        subCatIndexScroll = tableviewcell.highlightCollectionView.tag
                        let count:Int = listArray.count
                        let strIndex = String(count)
                        print(strIndex)
                        self.home_cList(startInexing: strIndex)
                    }
                }
                else
                {
                }
            }
        }
        else
        {
            let xYsis:Int = Int(scrollView.frame.origin.x)
            let yXsis:Int = Int(scrollView.frame.origin.y)
            let height:Int = Int(scrollView.frame.size.height)
            if xYsis == 0 && yXsis == 0 && height == 220
            {
                let pageWidth:CGFloat = scrollView.frame.width
                let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
                let Count = Int(currentPage)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrolling"), object: Count as Int)
            }
        }
    }
    
    func createLandscapePlayerControl(viewBg: UIView)
    {
        self.playbackSlider = UISlider(frame:CGRect(x:40, y:viewBg.frame.size.height - 20, width:self.view.frame.size.width-100, height:5))
        let leftTrackImage = UIImage(named: "sliderThumb")
        let minImage = UIImage(named: "lineRed")
        let maxImage = UIImage(named: "lineGray")
        self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
        self.playbackSlider.minimumValue = 0
        self.playbackSlider.setValue(0, animated: true)
        self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
        self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
        let duration : CMTime = self.playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        self.playbackSlider.maximumValue = 100000
        self.playbackSlider.isContinuous = true
        self.playbackSlider.tintColor = UIColor.green
        viewBg.addSubview(self.playbackSlider)
        
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        let rectLeft = CGRect(origin: CGPoint(x: 5,y :viewBg.frame.size.height - 25), size: CGSize(width: 30, height: 10))
        self.lblLeft.backgroundColor = UIColor.clear
        self.lblLeft.font = UIFont.systemFont(ofSize: 8)
        self.lblLeft.textColor = UIColor.white
        self.lblLeft.text = "00:00"
        
        self.lblLeft.frame = rectLeft
        viewBg.addSubview(self.lblLeft)
        
        let lblEnd:UILabel = UILabel()
        let rectRight = CGRect(origin: CGPoint(x: viewBg.frame.size.width-49,y :viewBg.frame.size.height - 25), size: CGSize(width: 30, height: 10))
        lblEnd.backgroundColor = UIColor.clear
        lblEnd.font = UIFont.systemFont(ofSize: 8)
        lblEnd.text = "Live"
        lblEnd.frame = rectRight
        lblEnd.textColor = UIColor.red
        viewBg.addSubview(lblEnd)
        
        let expandImage = UIImage(named: "expandPlayer")
        let expandBtn = UIButton()
        expandBtn.setImage(expandImage, for: .normal)
        let rectMore = CGRect(origin: CGPoint(x: viewBg.frame.size.width-40,y :viewBg.frame.size.height - 40), size: CGSize(width: 40, height: 40))
        expandBtn.frame = rectMore
        expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
        viewBg.addSubview(expandBtn)
        
        viewBg.bringSubview(toFront: self.lblLeft)
        viewBg.bringSubview(toFront: lblEnd)
        viewBg.bringSubview(toFront: expandBtn)
        viewBg.bringSubview(toFront: self.playbackSlider)
    }
    
    func createPlayerControl(viewBg: UIView)
    {
        self.playbackSlider = UISlider(frame:CGRect(x:30, y:142, width:self.view.frame.size.width-100, height:5))
        let leftTrackImage = UIImage(named: "sliderThumb")
        let minImage = UIImage(named: "lineRed")
        let maxImage = UIImage(named: "lineGray")
        self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
        self.playbackSlider.minimumValue = 0
        self.playbackSlider.setValue(0, animated: true)
        self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
        self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
        let duration : CMTime = self.playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        self.playbackSlider.maximumValue = 100000
        self.playbackSlider.isContinuous = true
        self.playbackSlider.tintColor = UIColor.green
        viewBg.addSubview(self.playbackSlider)
        
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        let rectLeft = CGRect(origin: CGPoint(x: 1,y :140), size: CGSize(width: 30, height: 10))
        self.lblLeft.backgroundColor = UIColor.clear
        self.lblLeft.font = UIFont.systemFont(ofSize: 8)
        self.lblLeft.textColor = UIColor.white
        self.lblLeft.text = "00:00"
        
        self.lblLeft.frame = rectLeft
        viewBg.addSubview(self.lblLeft)
        
        let lblEnd:UILabel = UILabel()
        let rectRight = CGRect(origin: CGPoint(x: viewBg.frame.size.width-49,y :140), size: CGSize(width: 30, height: 10))
        lblEnd.backgroundColor = UIColor.clear
        lblEnd.font = UIFont.systemFont(ofSize: 8)
        lblEnd.text = "Live"
        lblEnd.frame = rectRight
        lblEnd.textColor = UIColor.red
        viewBg.addSubview(lblEnd)
        
        let expandImage = UIImage(named: "expandPlayer")
        let expandBtn = UIButton()
        expandBtn.setImage(expandImage, for: .normal)
        let rectMore = CGRect(origin: CGPoint(x: viewBg.frame.size.width-40,y :125), size: CGSize(width: 40, height: 40))
        expandBtn.frame = rectMore
        expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
        viewBg.addSubview(expandBtn)
        
        viewBg.bringSubview(toFront: self.lblLeft)
        viewBg.bringSubview(toFront: lblEnd)
        viewBg.bringSubview(toFront: expandBtn)
        viewBg.bringSubview(toFront: self.playbackSlider)
    }
    
    func createLiveImg(liveCell:LiveCollectionViewCell,indexPath: IndexPath , detailDec:NSArray)
    {
        liveCell.logoImgView.isHidden = false
        liveCell.timeBgView.isHidden = false
        liveCell.timeLbl.isHidden = false
        liveCell.titleLbl.isHidden = false
        
        
        if let val = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail"))
        {
            
            if(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as! NSDictionary).count > 0)
            {
                
                let imgThumbUrl = ((detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
                
                
                var imgUrlwithsplit = String()
                if(imgThumbUrl.contains("jpg"))
                {
                    let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                    imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".jpg")"
                }
                else
                {
                    let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                    imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".png")"
                }
                
                
                let urlImg = URL(string:imgUrlwithsplit)
                liveCell.logoImgView.sd_setImage(with: urlImg, placeholderImage: UIImage(named: ""))
                
            }
        }
        
        
        
        
        // let imgBaseUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as //AnyObject).object(forKey:"base_path") as? String)!
        // let imgThumbUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
        // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
        //let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
        //print("downloadUrl >>>",downloadUrl)
        // let urlImg = URL(string:imgThumbUrl)
        
        //  liveCell.logoImgView.sd_setImage(with: URL(string: (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!), placeholderImage: UIImage(named: ""))
        //  liveCell.logoImgView.sd_setImage(with: urlImg, placeholderImage: UIImage(named: ""))
        let datePublishedString = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"publish_date") as! String
        let datePublishedFormatter = DateFormatter()
        datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datePublishedFormatter.locale = NSLocale(localeIdentifier: self.localeStr as String) as Locale!
        let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
        datePublishedFormatter.dateFormat = "dd, MMMM-h:mm a"
        datePublishedFormatter.amSymbol = "AM"
        datePublishedFormatter.pmSymbol = "PM"
        let dateTimeFromPublishedString = convertDateFormate(date: dateFromPublishedString)//datePublishedFormatter.string(from: dateFromPublishedString)
        let strFormat = dateTimeFromPublishedString
        //strFormat = strFormat.replacingOccurrences(of: ",", with: "st")
        let timeEnd = String(format: "%@", strFormat)
        liveCell.timeLbl.text = timeEnd as? String
        liveCell.titleLbl.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"des") as? String
        liveCell.upcomingHeading.isHidden = false
        liveCell.upcomingHeading.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
    }
    
    func btnPlayAction(sender:UIButton)
    {
        self.performSegue(withIdentifier: "livePlayerShow", sender: self)
    }
    
    func createLivePlayerImg(liveCell:LiveCollectionViewCell,indexPath: IndexPath, videoURL: URL , detailDec:NSArray)
    {
        liveCell.logoImgView.isHidden = false
        liveCell.timeBgView.isHidden = false
        liveCell.timeLbl.isHidden = false
        liveCell.titleLbl.isHidden = false
        liveCell.btnPlay.isHidden = false
        liveCell.titleLbl.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"des") as? String
        liveCell.btnPlay.addTarget(self, action: #selector(btnPlayAction), for: .touchUpInside)
        
        if let val = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail"))
        {
            if(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as! NSDictionary).count > 0)
            {
                
                let imgThumbUrl = ((detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
                var imgUrlwithsplit = String()
                if(imgThumbUrl.contains("jpg"))
                {
                    let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                    imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".jpg")"
                }
                else
                {
                    let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                    imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".png")"
                }
                
                let urlImg = URL(string:imgUrlwithsplit)
                liveCell.logoImgView.sd_setImage(with: urlImg, placeholderImage: UIImage(named: ""))
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        // let imgBaseUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
        // let imgThumbUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
        // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
        //let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
        //print("downloadUrl >>>",downloadUrl)
        //let urlImg = URL(string:imgThumbUrl)
        //  liveCell.logoImgView.sd_setImage(with: urlImg, placeholderImage: UIImage(named: ""))
        // liveCell.logoImgView.sd_setImage(with: URL(string: (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!), placeholderImage: UIImage(named: ""))
        let datePublishedString = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"publish_date") as! String
        let datePublishedFormatter = DateFormatter()
        datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datePublishedFormatter.locale = NSLocale(localeIdentifier: self.localeStr as String) as Locale!
        let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
        datePublishedFormatter.dateFormat = "dd, MMMM-h:mm a"
        datePublishedFormatter.amSymbol = "AM"
        datePublishedFormatter.pmSymbol = "PM"
        let dateTimeFromPublishedString = convertDateFormate(date: dateFromPublishedString)//datePublishedFormatter.string(from: dateFromPublishedString)
        let strFormat = dateTimeFromPublishedString
        //strFormat = strFormat.replacingOccurrences(of: ",", with: "st")
        let timeEnd = String(format: "%@", strFormat)
        liveCell.timeLbl.text = timeEnd as? String
        liveCell.upcomingHeading.isHidden = false
        liveCell.upcomingHeading.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        livePlayerUrl = videoURL
        liveContentIDStr = (detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "id") as! NSString
        self.playerItem = AVPlayerItem(url: videoURL as URL)
        liveCell.videoPlayer = AVPlayer(playerItem: self.playerItem)
        liveCell.avLayer = AVPlayerLayer(player: liveCell.videoPlayer)
        liveCell.avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        liveCell.videoPlayer.actionAtItemEnd = .none
        self.avPlayersLayer = liveCell.avLayer
        liveCell.playerViewController.showsPlaybackControls = false
        liveCell.upcomingHeading.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        self.liveCollectionCell = liveCell
        
        liveCell.layer.addSublayer(liveCell.avLayer)
        self.videoBgPlayer=liveCell.videoPlayer
        
    }
    func createAvplayer(liveCell:LiveCollectionViewCell,indexPath: IndexPath, videoURL: URL , detailDec:NSArray)
    {
        liveCell.timeBgView.isHidden = true
        liveCell.timeLbl.isHidden = true
        liveCell.upcomingHeading.isHidden = false
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width-20, height: 160))
        self.playerItem = AVPlayerItem(url: videoURL as URL)
        liveCell.videoPlayer = AVPlayer(playerItem: self.playerItem)
        liveCell.avLayer = AVPlayerLayer(player: liveCell.videoPlayer)
        liveCell.avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        liveCell.avLayer.frame = rect
        liveCell.videoPlayer.actionAtItemEnd = .none
        self.avPlayersLayer = liveCell.avLayer
        liveCell.playerViewController.showsPlaybackControls = false
        
        self.liveCollectionCell = liveCell
        
        liveCell.layer.addSublayer(liveCell.avLayer)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
        UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
        
        
        self.videoBgPlayer=liveCell.videoPlayer
        liveCell.upcomingHeading.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        
        let tempView = UIView(frame:CGRect(x:0, y:0, width:self.view.frame.size.width-20, height:160))
        tempView.backgroundColor=UIColor.clear
        liveCell.addSubview(tempView)
        liveCell.bringSubview(toFront: tempView)
        self.createPlayerControl(viewBg: tempView)
    }
    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer)
    {
        if (keyPath == "status") {
        }
    }
    //Collection View Delegates and DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var detailDec:NSArray=NSArray()
        if (collectionView.tag==0)
        {
            detailDec=(homeListArray.object(at: collectionView.tag) as AnyObject).object(forKey:"recomended") as! NSArray
        }
        else if(collectionView.tag==1)
        {
            detailDec=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"sports") as! NSArray
        }
        else if(collectionView.tag==countCat)
        {
            detailDec=(
                homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"shows") as! NSArray
        }
        else if(collectionView.tag==2)
        {
         
            detailDec=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"live") as! NSArray
           
        }
        else if(collectionView.tag==3)
        {
            if upcominnB == true
            {
                detailDec=(homeListArray.object(at:collectionView.tag) as AnyObject).object(forKey:"liveUpcoming") as! NSArray
            }
            else
            {
                
                detailDec=homeListArray.object(at:collectionView.tag) as! NSArray
                
            }
        }
        else
        {
            detailDec = homeListArray.object(at:collectionView.tag) as! NSArray
            
        }
        if(collectionView.tag == 2)
        {
            let liveCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionCell", for: indexPath) as! LiveCollectionViewCell
            // print("detail live >>>>",detailDec)
            if detailDec.count > 0
            {
                let strVideoUrl =  nullToNil(value: (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"url") as AnyObject)
                let videoURL = URL(string: strVideoUrl as! String)
                //http://49.40.0.136:8080/live/aajtak/playlist.m3u8
                let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width-20, height: 160))
                
                
                let dateString = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"current_date") as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                dateFormatter.locale = NSLocale(localeIdentifier: localeStr as String) as Locale!
                let dateFromString = dateFormatter.date(from: dateString)! as Date
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateTimeFromString = dateFormatter.string(from: dateFromString)
                let datePublishedString = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"publish_date") as! String
                let datePublishedFormatter = DateFormatter()
                datePublishedFormatter.locale = NSLocale(localeIdentifier: localeStr as String) as Locale!
                datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
                datePublishedFormatter.dateFormat = "yyyy-MM-dd"
                let dateTimeFromPublishedString = datePublishedFormatter.string(from: dateFromPublishedString)
                let status = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"status") as! String
                print("status app >>",status)
                if status == "1" {
                    liveCell.logoImgView.isHidden = true
                    liveCell.upcomingBg.isHidden = true
                    liveCell.lblUpcoming.isHidden = true
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    DispatchQueue.main.async { () -> Void in
                        AppUtility.lockOrientation(.portrait)
                        if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
                        {
                            let subMode = UserDefaults.standard.value(forKey: "susubscription_mode") as! String
                            if subMode == "free" || subMode == ""
                            {
                                if UserDefaults.standard.value(forKey: "userCurrentPlay") != nil
                                {
                                    let time = UserDefaults.standard.value(forKey: "userCurrentPlay") as! Int
                                    let countTime = time
                                    if countTime == 120 || countTime > 120
                                    {
                                        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                                        {
                                            self.createLivePlayerImg(liveCell: liveCell, indexPath: indexPath, videoURL: videoURL!, detailDec: detailDec)
                                        }
                                        else
                                        {
                                            self.createLiveImg(liveCell: liveCell, indexPath: indexPath, detailDec: detailDec)
                                        }
                                    }
                                    else
                                    {
                                        self.createLivePlayerImg(liveCell: liveCell, indexPath: indexPath, videoURL: videoURL!, detailDec: detailDec)
                                    }
                                    
                                }
                                else
                                {
                                    self.createLivePlayerImg(liveCell: liveCell, indexPath: indexPath, videoURL: videoURL!, detailDec: detailDec)
                                }
                                
                                
                                
                            }
                            else
                            {
                                
                                if appDelegate.subscribedItemArrays.count > 0
                                {
                                    self.createLivePlayerImg(liveCell: liveCell, indexPath: indexPath, videoURL: videoURL!, detailDec: detailDec)
                                }
                                else
                                {
                                    self.createLiveImg(liveCell: liveCell, indexPath: indexPath, detailDec: detailDec)
                                }
                                
                            }
                        }
                        else
                        {
                            self.createLivePlayerImg(liveCell: liveCell, indexPath: indexPath, videoURL: videoURL!, detailDec: detailDec)
                        }
                        
                    }
                }
                else
                {
                    AppUtility.lockOrientation([.portrait])
                    liveCell.upcomingHeading.isHidden = false
                    liveCell.timeLbl.isHidden = false
                    self.createLiveImg(liveCell: liveCell, indexPath: indexPath, detailDec: detailDec)
                }
                
                
            }
            else
            {
                
            }
            
            
            return liveCell
        }
        else if(collectionView.tag == 3)
        {
            if upcominnB == true
            {
                let subLiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubLiveCollectionViewCell", for: indexPath) as! SubLiveCollectionViewCell
                subLiveCell.headingLbl.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
                
                
                
                if let val = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail"))
                {
                    
                    if(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as! NSDictionary).count > 0)
                    {
                        
                        let imgThumbUrl = ((detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
                        
                        
                        var imgUrlwithsplit = String()
                        if(imgThumbUrl.contains("jpg"))
                        {
                            let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                            imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".jpg")"
                        }
                        else
                        {
                            let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                            imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".png")"
                        }
                        
                        
                        let urlImg = URL(string:imgUrlwithsplit)
                        subLiveCell.logoImgView.kf.setImage(with: urlImg,
                                                            placeholder: nil,
                                                            options: [.transition(ImageTransition.fade(1))],
                                                            progressBlock: { receivedSize, totalSize in
                        },
                                                            completionHandler: { image, error, cacheType, imageURL in
                        })
                    }
                    
                }
                
                
                
                
                
                
                
                
                // let imgBaseUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
                //  let imgThumbUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
                // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
                //let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
                //print("downloadUrl >>>",downloadUrl)
                //   let urlImg = URL(string:imgThumbUrl)
                
                //let urlImg = URL(string: (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!)
                
                //       subLiveCell.logoImgView.kf.setImage(with: urlImg,
                //                                         placeholder: nil,
                //                                         options: [.transition(ImageTransition.fade(1))],
                //                                           progressBlock: { receivedSize, totalSize in
                //     },
                //                                         completionHandler: { image, error, cacheType, imageURL in
                //     })
                
                let datePublishedString = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"publish_date") as! String
                let datePublishedFormatter = DateFormatter()
                datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                datePublishedFormatter.locale = NSLocale(localeIdentifier: self.localeStr as String) as Locale!
                let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
                datePublishedFormatter.dateFormat = "dd, MMMM-h:mm a"
                datePublishedFormatter.amSymbol = "AM"
                datePublishedFormatter.pmSymbol = "PM"
                let dateTimeFromPublishedString = convertDateFormate(date: dateFromPublishedString)//datePublishedFormatter.string(from: dateFromPublishedString)
                let strFormat = dateTimeFromPublishedString
                //strFormat = strFormat.replacingOccurrences(of: ",", with: "st")
                let timeEnd = String(format: "%@", strFormat)
                
                subLiveCell.timeLbl.text = timeEnd as? String
                //publish_date
                subLiveCell.bgView.layer.cornerRadius = 2
                subLiveCell.timeBgView.layer.cornerRadius = 2
                
                let status = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"status") as? String
                if status == "1" {
                    subLiveCell.Upcominglabel.text = "Live"
                }
                else
                {
                    subLiveCell.Upcominglabel.text = "Upcoming"
                }
                
                return subLiveCell
            }
            else
            {
                let highlightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightCollectionViewCell", for: indexPath) as! HighlightCollectionViewCell
                //  let urlImg = URL(string:(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!)
                
                if let val = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
                {
                    
                    if(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
                    {
                        let imgThumbUrl = ((((detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                        
                        
                        var imgUrlwithsplit = String()
                        if(imgThumbUrl.contains("jpg"))
                        {
                            let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                            imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".jpg")"
                        }
                        else
                        {
                            let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                            imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".png")"
                        }
                        
                        
                        let urlImg = URL(string:imgUrlwithsplit)
                        highlightCell.logoImgVw.image = nil
                        highlightCell.logoImgVw.kf.setImage(with: urlImg,
                                                            placeholder: nil,
                                                            options: [.transition(ImageTransition.fade(1))],
                                                            progressBlock: { receivedSize, totalSize in
                        },
                                                            completionHandler: { image, error, cacheType, imageURL in
                        })
                    }
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                //  let imgBaseUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
                //  let imgThumbUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
                // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
                // let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
                // print("downloadUrl >>>",downloadUrl)
                //  let urlImg = URL(string:imgThumbUrl)
                //    highlightCell.logoImgVw.image = nil
                //    let img = UIImage(named: "likeActive")
                //    highlightCell.logoImgVw.kf.setImage(with: urlImg,
                //                                        placeholder: nil,
                //                                        options: [.transition(ImageTransition.fade(1))],
                //                                        progressBlock: { receivedSize, totalSize in
                //     },
                //                                           completionHandler: { image, error, cacheType, imageURL in
                //        })
                
                var durationStr = String(format: "%@", ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"duration") as? String)!)
                let arrayTime = durationStr.components(separatedBy: ":") as NSArray
                if arrayTime.count > 0 {
                    let strFirst = arrayTime.object(at: 0) as! String
                    if strFirst == "00"
                    {
                        durationStr =  String(format: "%@:%@",arrayTime.object(at: 1) as! CVarArg,arrayTime.object(at: 2) as! CVarArg)
                    }
                    else
                    {
                        
                    }
                }
                highlightCell.timeLbl.text = durationStr
                highlightCell.titleLbl.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
                
                return highlightCell
            }
        }
        else if(collectionView.tag == 1)
        {
            let showsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowsCollectionViewCell", for: indexPath) as! ShowsCollectionViewCell
            showsCell.titleLbl.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"name") as? String
            
            
            let strUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnails")! as AnyObject).object(at: 0) as? String)
            
            showsCell.logoImgVw.sd_setImage(with: URL(string:strUrl!)) { (image, error, imageCacheType, imageUrl) in
                if image != nil {
                    showsCell.logoImgVw.image = image!//self.cropToBounds(image: image!, width: 90, height: 120)
                }else
                {
                }
            }
            
            var sizeCalculate = self.view.frame.size.width / 3
            
            
            sizeCalculate = sizeCalculate - 20
            let screenSize = self.view.frame.size.width
            
            if screenSize < 330
            {
                let rect = CGRect(origin: CGPoint(x: 0,y : 0), size: CGSize(width: sizeCalculate+5, height: 125))
                
                showsCell.logoImgVw.frame = rect
                let rectLbl = CGRect(origin: CGPoint(x: 0,y :125), size: CGSize(width: sizeCalculate, height: 21))
                showsCell.titleLbl.frame = rectLbl
                
            }
            else if screenSize > 380
            {
                let rect = CGRect(origin: CGPoint(x: 0,y : 0), size: CGSize(width: sizeCalculate+10, height: 157))
                
                showsCell.logoImgVw.frame = rect
                let rectLbl = CGRect(origin: CGPoint(x: 0,y :157), size: CGSize(width: sizeCalculate, height: 21))
                showsCell.titleLbl.frame = rectLbl
                
            }
            else
            {
                
            }
            return showsCell
        }
        else if(collectionView.tag == countCat)
        {
            let trendingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
            trendingCell.lblTitle.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"name") as? String
            trendingCell.logoImgView.sd_setImage(with: URL(string: (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnails")! as AnyObject).object(at: 0) as? String)!), placeholderImage: UIImage(named: ""))
            
            return trendingCell
        }
        else
        {
            let highlightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightCollectionViewCell", for: indexPath) as! HighlightCollectionViewCell
            
    
            // let imgBaseUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
            //  let imgThumbUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
            // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
            // let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
            // print("downloadUrl >>>",downloadUrl)
            //    let urlImg = URL(string:imgThumbUrl)
            //  let urlImg = URL(string:(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!)
            var durationStr = String(format: "%@", ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"duration") as? String)!)
            
            let arrayTime = durationStr.components(separatedBy: ":") as NSArray
            if arrayTime.count > 0 {
                let strFirst = arrayTime.object(at: 0) as! String
                if strFirst == "00"
                {
                    durationStr =  String(format: "%@:%@",arrayTime.object(at: 1) as! CVarArg,arrayTime.object(at: 2) as! CVarArg)
                }
                else
                {
                    
                }
            }
            highlightCell.timeLbl.text = durationStr
            highlightCell.logoImgVw.image = nil
            
            
            if let val = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
            {
                
                if(Common.isNotNull(object: (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs") as AnyObject))
                {
                
                if(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
                {
                    let imgThumbUrl = ((((detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    var imgUrlwithsplit = String()
                    if(imgThumbUrl.contains("jpg"))
                    {
                        let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                        imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".jpg")"
                    }
                    else
                    {
                        let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                        imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".png")"
                    }
                    
                    
                    let urlImg = URL(string:imgUrlwithsplit)
                    highlightCell.logoImgVw.kf.setImage(with: urlImg,
                                                        placeholder: nil,
                                                        options: [.transition(ImageTransition.fade(1))],
                                                        progressBlock: { receivedSize, totalSize in
                    },
                                                        completionHandler: { image, error, cacheType, imageURL in
                    })
                    
                }
            }
        }
    
            highlightCell.titleLbl.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
            
            
            return highlightCell
        }
    }
    func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM-h:mm a"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func _resizeWithAspect_doResize(image: UIImage,size: CGSize)->UIImage{
        
        if  UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        //
        
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height)));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!;
    }
    
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight);
        
        return self._resizeWithAspect_doResize(image: image, size: newSize);
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail"
        {
            let vc = segue.destination as! DetailViewController
            vc.dictDetail = homeDetailDict
            vc.contentArray = detailContentArray
            if strDetailType == "banner"
            {
                let arrayIds = homeDetailDict.object(forKey: "category_ids") as! NSArray
                vc.strCatID = arrayIds.object(at: 0) as! NSString
            }
            else
            {
                let cat_ID = nullToNil(value: homeDetailDict.object(forKey: "category_id") as AnyObject) as! NSString
                if cat_ID == ""
                {
                    let arrayID  = homeDetailDict.object(forKey: "category_ids") as! NSArray
                    if arrayID.count > 0 {
                        vc.strCatID = arrayID.object(at: 0) as! NSString
                    }
                    // strID  = homeDetailDict.object(forKey: "category_id") as! NSString!
                }
                else
                {
                    vc.strCatID  = homeDetailDict.object(forKey: "category_id") as! NSString!
                }
                //  vc.strCatID = homeDetailDict.object(forKey: "category_id") as! NSString
            }
            
        }
        else if segue.identifier == "livePlayerShow"
        {
            let vc = segue.destination as! LivePlayerViewController
            vc.livePlayerUrl = livePlayerUrl
            vc.Secure_url = ""
            vc.strLiveContentID = liveContentIDStr
        }
        else if segue.identifier == "showSportsList"
        {
            let vc = segue.destination as! SportsListViewController
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: homeDetailDict)
            UserDefaults.standard.setValue(encodedData, forKey: "sportsDict")
            UserDefaults.standard.setValue("back", forKey: "sportsButton")
            vc.sport_id = sport_id as String!
            vc.dictSports = homeDetailDict
        }
        else if segue.identifier == "showSports"
        {
            let vc = segue.destination as! SportsViewController
            vc.arrayContent = sportsIconContentArray
            vc.strType = strType
        }
        else if segue.identifier == "liveListShow"
        {
            let vc = segue.destination as! LiveListViewController
            vc.contentArray = arrayLiveData
        }
        else if segue.identifier == "showLoginSession"
        {
            
        }
        else if segue.identifier == "searchPush"
        {
        }//showHomeSub
        else if segue.identifier == "showHomeSub"
        {
        }
        else
        {
            let vc = segue.destination as! NewsListViewController
            vc.strCatID = strID
            vc.strHeading = strHeading
            vc.contentArray = newsContentArray
            vc.prvLoadCount = sendListCount
            
        }
    }
    
    func expandBtnAction()
    {
        if bEnlarge == true {
            bEnlarge = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        else
        {
            bEnlarge = true
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
    }
    
    
    func update()
    {
        // Something cool
        if self.videoBgPlayer != nil && (self.videoBgPlayer.currentItem != nil)
        {
            let currentItem:AVPlayerItem = videoBgPlayer.currentItem!
            let duration:CMTime = currentItem.duration
            let videoDUration:Float = Float(CMTimeGetSeconds(duration))
            let currentTime:Float = Float(CMTimeGetSeconds(videoBgPlayer.currentTime()))
            playbackSlider.value = currentTime
            playerTime = Int(currentTime)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if UserDefaults.standard.value(forKey: "userCurrentPlay") != nil
            {
                let time = UserDefaults.standard.value(forKey: "userCurrentPlay") as! Int
                let countTime = time + playerTime
                if countTime == 120 || countTime > 120
                {
                    
                    if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
                    {
                        let subMode = UserDefaults.standard.value(forKey: "susubscription_mode") as! String
                        if subMode == "free" || subMode == ""
                        {
                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                            {
                                
                            }
                            else
                            {
                                if self.timer != nil
                                {
                                    self.timer.invalidate()
                                    self.timer  = nil
                                }
                                if  self.videoBgPlayer != nil {
                                    self.videoBgPlayer.pause()
                                }
                                self.playerController.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "showHomeSub", sender: self)
                                
                            }
                        }
                        else if subMode == "null"
                        {
                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                            {
                                
                            }
                            else
                            {
                                if self.timer != nil
                                {
                                    self.timer.invalidate()
                                    self.timer  = nil
                                }
                                if  self.videoBgPlayer != nil {
                                    self.videoBgPlayer.pause()
                                }
                                self.playerController.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "showHomeSub", sender: self)
                            }
                        }
                        else
                        {
                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                            {
                                if appDelegate.subscribedItemArrays.count > 0
                                {
                                    
                                }
                                else
                                {
                                    if self.timer != nil
                                    {
                                        self.timer.invalidate()
                                        self.timer  = nil
                                    }
                                    if  self.videoBgPlayer != nil {
                                        self.videoBgPlayer.pause()
                                    }
                                    self.playerController.dismiss(animated: true, completion: nil)
                                    self.performSegue(withIdentifier: "showHomeSub", sender: self)
                                    //  self.tblHomeData.reloadData()
                                }
                            }
                            else
                            {
                                if self.timer != nil
                                {
                                    self.timer.invalidate()
                                    self.timer  = nil
                                }
                                if  self.videoBgPlayer != nil {
                                    self.videoBgPlayer.pause()
                                }
                                self.playerController.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "showHomeSub", sender: self)
                                //   self.tblHomeData.reloadData()
                            }
                        }
                    }
                    else
                    {
                        // print("Null subscribe")
                        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                        {
                            
                        }
                        else
                        {
                            if self.timer != nil
                            {
                                self.timer.invalidate()
                                self.timer  = nil
                            }
                            if  self.videoBgPlayer != nil {
                                self.videoBgPlayer.pause()
                            }
                            //showHomeSub
                            self.playerController.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "showHomeSub", sender: self)
                            // self.tblHomeData.reloadData()
                        }
                    }
                    
                }
            }
            
            let (hr,  minf) = modf (currentTime / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            
            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            lblLeft.text = time
        }
        
        // let time = String(format: "%@:%@:%@", hoursString,minutesString, secondsString)
        //lblLeft.text = time
    }
    
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        // KingfisherManager.shared.cache.clearMemoryCache()
        // KingfisherManager.shared.cache.clearDiskCache()
        super.viewWillDisappear(animated)
        // self.tblHomeData = nil
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
        UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
        //   print("viewWillDisappear")
        if (videoBgPlayer != nil) {
            videoBgPlayer.pause()
        }
        // self.view = nil
        //NotificationCenter.default.addObserver(self,selector: #selector(showBannerDetail),name: NSNotification.Name(rawValue: "showBannerDetail"),object: nil)
        
        
        /*
         NotificationCenter.default.addObserver(self,selector: #selector(get_Response),name: NSNotification.Name(rawValue: "getHomeResponse"),object: nil)
         
         NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionLogin"),object: nil)
         
         NotificationCenter.default.addObserver(self,selector: #selector(getHomeNewsDataResponse),name: NSNotification.Name(rawValue: "getHomeNewsDataResponse"),object: nil)
         NotificationCenter.default.addObserver(self,selector: #selector(getHomePackageList),name: NSNotification.Name(rawValue: "getHomePackageList"),object: nil)
         NotificationCenter.default.addObserver(self,selector: #selector(getcatListResponse),name: NSNotification.Name(rawValue: "getcatListResponse"),object: nil)
         NotificationCenter.default.addObserver(self,selector: #selector(getversionchekResponse),name: NSNotification.Name(rawValue: "getversionchekResponse"),object: nil)
         
         NotificationCenter.default.addObserver(self,selector: #selector(loginRedirect),name: NSNotification.Name(rawValue: "loginScreen"),object: nil)
         
         NotificationCenter.default.addObserver(self,selector: #selector(redirectLoginScreen),name: NSNotification.Name(rawValue: "redirectLoginScreen"),object: nil)
         */
        //loadApiData
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "backLiveVideo"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "loadApiData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "get_Response"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "afterSessionLogin"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getHomeNewsDataResponse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getHomePackageList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getcatListResponse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getversionchekResponse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "loginScreen"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "redirectLoginScreen"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "showBannerDetail"), object: nil)
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeTimer"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    // MARK:- Play Video
    
    func playMovie() {
        
        self.frostedViewController.panGestureEnabled = false
        self.view.isUserInteractionEnabled = false
        let videoURL: NSURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "mymovie", ofType: "mp4")!) as NSURL
        player = AVPlayer(url: videoURL as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        
        playerVC.player = player
        playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerVC.showsPlaybackControls = false
        
        let playerView = playerVC.view
        addChildViewController(playerVC)
        view.addSubview(playerView!)
        playerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView?.frame = view.bounds
        playerVC.didMove(toParentViewController: self)
        
        
    }
    // MARK:- End Playing Video
    func playerDidFinishPlaying(note: NSNotification){
        self.frostedViewController.panGestureEnabled = true
        self.view.isUserInteractionEnabled = true
        playerLayer.removeFromSuperlayer()
        playerVC.view.removeFromSuperview()
        
        // dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning()
    {
        //  KingfisherManager.shared.cache.clearMemoryCache()
        //  KingfisherManager.shared.cache.clearDiskCache()
        //   print("didReceiveMemoryWarning home")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && self.miniMediaControlsViewController.active {
        } else {
        }
        UIView.animate(withDuration: kCastControlBarsAnimationDuration, animations: {() -> Void in
            self.view.layoutIfNeeded()
        })
        self.view.setNeedsLayout()
    }
    
    // MARK: - GCKUIMiniMediaControlsViewControllerDelegate
    
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                         shouldAppear: Bool) {
        self.updateControlBarsVisibility()
    }
}
extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width:size.width/resizeFactor, height:size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}

extension UIImageView
{
    func downloadFrom(link:String?, contentMode mode: UIViewContentMode)
    {
        contentMode = mode
        if link == nil
        {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!)
        {
            
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async { () -> Void in
                    
                    self.image = UIImage(data: data)
                    // self.image = self.cropToBounds(image: self.image!, width: 95, height: 120)
                }
            }).resume()
        }
        else
        {
            self.image = UIImage(named: "default")
        }
    }
    func downloadSportsFrom(link:String?, contentMode mode: UIViewContentMode)
    {
        contentMode = mode
        if link == nil
        {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!)
        {
            
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async { () -> Void in
                    
                    self.image = UIImage(data: data)
                    self.image = self.cropToBounds(image: self.image!, width: 85, height: 120)
                }
            }).resume()
        }
        else
        {
            self.image = UIImage(named: "default")
        }
    }
    
    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x:x, y:y, width:size.height, height:size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    
    
    
    
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

