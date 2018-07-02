//
//  DetailViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 24/03/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher
import CoreTelephony
import M3U8Kit2
import AFNetworking
import GoogleCast
var kPrefMediaListURL: String = "media_list_url"
import REFrostedViewController




enum PlaybackMode: Int {
    case none = 0
    case local
    case remote
}

class DetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,AVPictureInPictureControllerDelegate, GCKSessionManagerListener,
GCKRemoteMediaClientListener, GCKRequestDelegate {
    @IBOutlet var listTblView: UITableView!
    
    var activityIndicator:UIActivityIndicatorView=UIActivityIndicatorView()
    @IBOutlet var heightDesc: NSLayoutConstraint!
    @IBOutlet var backUpperBtn: UIButton!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var listLbl: UILabel!
    
    @IBOutlet var backLandBtn: UIButton!
    
    
    @IBOutlet weak var Backbutton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    var favListArray:NSMutableArray = NSMutableArray()
    @IBOutlet weak var Soundaudio: UIButton!
    @IBOutlet weak var resolutionbutton: UIButton!
    var blackBg:UIView!
    var expandBtn:UIButton = UIButton()
    var bFirstTime:Bool = Bool()
    var enlargeBtn:UIButton = UIButton()
    var enlargeBtnLayer:UIButton = UIButton()
    var playerTime:Int!
    var playerSkipTime:Int!
    var playedIndex:Int!
    var tempView:UIView!
    var bHideControl:Bool = Bool()
    var checkcontantenable:Bool = Bool()
    var bSlideBar:Bool = Bool()
    var bPlay:Bool = Bool()
    var bEnlarge:Bool = Bool()
    var objWeb = AFNetworkingWebServices()
    var detailContentArray:NSMutableArray = NSMutableArray()
    var contentArray:NSMutableArray = NSMutableArray()
    var showListArray:NSMutableArray = NSMutableArray()
    var videoItem:AVPlayerItem!
    var playerControllerDetail = AVPlayerViewController()
    var strCatID:NSString = NSString()
    var catID:NSString = NSString()
    
    var skipStr:NSString = NSString()
    
    var favUnFav:NSString = NSString()
    var videoPlayer:AVPlayer!
    var offSetStart:Int!
    var lblEnd:UILabel = UILabel()
    var avLayer:AVPlayerLayer!
    var playbackSlider:UISlider!
    var lblLeft:UILabel = UILabel()
    var dictDetail:NSDictionary=NSDictionary()
    var isNewDataLoading:Bool = Bool()
    var iscontantfav:Bool = Bool()
    var isAppsessionenble:Bool = Bool()
    @IBOutlet var backBtn: UIButton!
    var timer:Timer!
    var videoresoulationtypearray:NSMutableArray=NSMutableArray()
    var videoresoulationurlarray:NSMutableArray=NSMutableArray()
    var seletetedresoltionindex:Int = 0

    @IBOutlet weak var bacwordbuttonupercnstraint: NSLayoutConstraint!
    
    
    
    
    
    
    
    
    
    
    ///////////Google CAST
    private var sessionManager: GCKSessionManager!
    private var castSession: GCKCastSession?
    private var castMediaController: GCKUIMediaController!
    private var volumeController: GCKUIDeviceVolumeController!
    private var streamPositionSliderMoving: Bool = false
    private var playbackMode = PlaybackMode.none
    private var queueButton: UIBarButtonItem!
    private var showStreamTimeRemaining: Bool = false
    private var localPlaybackImplicitlyPaused: Bool = false
    private var actionSheet: ActionSheet?
    private var queueAdded: Bool = false
    private var gradient: CAGradientLayer!
    @IBOutlet var castButton: GCKUICastButton!
    var mediaList: MediaListModel?
    var cromecastimageurl = String()
    
    /* Whether to reset the edges on disappearing. */
    var isResetEdgesOnDisappear: Bool = false
    // The media to play.
    var mediaInfo: GCKMediaInformation? {
        didSet {
            print("setMediaInfo")
        }
    }
    
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.sessionManager = GCKCastContext.sharedInstance().sessionManager
        self.castMediaController = GCKUIMediaController()
        self.volumeController = GCKUIDeviceVolumeController()
        
    }
    
    
    
    
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        playerTime = 0
        LoginCredentials.PlayType = "VOD"
       checkcontantenable = true
          // Do any additional setup after loading the view.
        self.frostedViewController.panGestureEnabled = false
        btnLike.isHidden = true
        NotificationCenter.default.addObserver(self,selector: #selector(getLikeButtonResponse),name: NSNotification.Name(rawValue: "getLikeButtonResponse"),object: nil)
       
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionDetailLogin"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getDetailMoreResponse),name: NSNotification.Name(rawValue: "getDetailMoreResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getFavListResponse),name: NSNotification.Name(rawValue: "getFavListResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getForgotResponse),name: NSNotification.Name(rawValue: "getForgotResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getPaymentResponse),name: NSNotification.Name(rawValue: "getPaymentResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(userseessionexpire),name: NSNotification.Name(rawValue: "SESSIONINACTIVE"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(poptologout),name: NSNotification.Name(rawValue: "poptologout"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioRouteChangeListener), name: .AVAudioSessionRouteChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
        
        
     
        

        //getAnalyticsResponse
        //getDetailMoreResponse
        print("dictDetail in detail view did >>>",dictDetail)
        self.btnLike.isHidden = true
        //self.getfavlist()
        self.navigationController?.navigationBar.isHidden=true
        //self.detail_Information_Of_Video()
         getvideoDetail()
        //self.call_cList()
        showListArray.removeAllObjects()
        showListArray = NSKeyedUnarchiver.unarchiveObject(
            with: NSKeyedArchiver.archivedData(withRootObject: contentArray)) as! NSMutableArray
        //playedIndex = 0
        for item in 0..<showListArray.count
        {
            let strTitle = (showListArray.object(at:item) as AnyObject).value(forKey:"title") as? String
            if strTitle == dictDetail.object(forKey: "title") as? String
            {
                //showListArray.removeObject(at: item)
                playedIndex = item
                offSetStart = showListArray.count
                offSetStart = offSetStart-10
                let cat_ID = nullToNil(value: dictDetail.object(forKey: "category_id") as AnyObject) as! NSString
                if cat_ID == ""
                {
                    let arrayID  = dictDetail.object(forKey: "category_ids") as! NSArray
                    if arrayID.count > 0
                    {
                        catID = arrayID.object(at: 0) as! NSString
                    }
                }
                else
                {
                    catID  = dictDetail.object(forKey: "category_id") as! NSString!
                }
                return
            }
        }
        
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("appear")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                 //////GOOGLE CAST
        print("viewWillAppear; mediaInfo is \(String(describing: self.mediaInfo)), mode is \(self.playbackMode)")
        appDelegate.isCastControlBarsEnabled = true
        
        // but now have a session, then switch to remote playback mode.
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode != .remote) {
            self.switchToRemotePlayback()
            
            
        } else if (self.sessionManager.currentSession == nil) && (self.playbackMode != .local) {
            self.switchToLocalPlayback()
        }
        self.sessionManager.add(self)
        
        
        appDelegate.strRedirstNotify = "afterSessionDetailLogin"
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        AppUtility.lockOrientation([.portrait,.landscape])
    }

    
    
    
    func willResignActive(_ notification: Notification) {

        
        
      if(expandBtn != nil)
       {
       expandBtn.isHidden = true
        }
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode != .remote) {


        }
        else
        {


            if(self.videoPlayer == nil)
            {

            }
            else
            {
                bPlay = true
                expandBtnAction()
                expandBtn.isHidden = true
             }
        }
        // code to execute
    }



    func audioRouteChangeListener(notification: Notification) {


        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode != .remote) {

        }
        else
        {

            guard let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? Int else { return }

            switch audioRouteChangeReason {

            case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
                //plugged out

                if(self.videoPlayer == nil)
                {

                }
                else
                {
                    if(self.bPlay)
                    {
                        self.bPlay = false
                    }
                    else
                    {
                        self.bPlay = true
                    }
                    expandBtnAction()
                    expandBtn.isHidden = true
                 }
                break

            default:
                break

            }
        }
    }
    

    func castDeviceDidChange(_ notification: Notification)
    {
        if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
             GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce()
         }
        else if(GCKCastContext.sharedInstance().castState != .notConnected)
        {
            print("DISCONNECCTED")
        }
    }
    
    
    @IBAction func taptocromecastbutton(_ sender: Any)
    {
        
        if(videoresoulationurlarray.count<1)
        {
            return
        }
        
   
       // self.tempView.isUserInteractionEnabled = false
         loadMediaList()
        

    }
    
    
    
    
    func loadMediaList() {
        // Look up the media list URL.
        
        let titile = (dictDetail.object(forKey:"title") as? String)
        let desc = nullToNil(value: dictDetail.object(forKey: "des") as AnyObject) as! NSString
        let metadata = GCKMediaMetadata()
        metadata.setString(titile!, forKey: kGCKMetadataKeyTitle)
        metadata.setString(desc as String,
                           forKey:kGCKMetadataKeySubtitle)
        let url = NSURL(string:self.cromecastimageurl)
        print(url)
        print(videoresoulationurlarray.object(at: videoresoulationurlarray.count-1) as! String)
        metadata.addImage(GCKImage(url: url as! URL, width: 480, height: 360))
        mediaInfo =    GCKMediaInformation(
            contentID:
            videoresoulationurlarray.object(at: videoresoulationurlarray.count-2) as! String,
            streamType: GCKMediaStreamType.none,
            contentType: "video/mp4",
            metadata: metadata,
            streamDuration: 0,
            mediaTracks: [],
            textTrackStyle: nil,
            customData: nil
        )
        
     
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient
        {
            bPlay = false
            expandBtnAction()
               stopplayerifcastingenable()
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = mediaInfo
            builder.autoplay = true
             builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build
            
           //  let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
          //  let request = castSession?.remoteMediaClient?.queueLoad([item()], start: 0, playPosition: 0,
            //                                                        repeatMode: repeatMode, customData: nil)
           // request?.delegate = self
            
            
            if (remoteMediaClient.mediaStatus != nil) {
               let request = remoteMediaClient.queueInsert(item(), beforeItemWithID: kGCKMediaQueueInvalidItemID)
              request.delegate = self
            } else {
               let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
             let request = castSession?.remoteMediaClient?.queueLoad([item()], start: 0, playPosition: 0,
                                                                      repeatMode: repeatMode, customData: nil)
           request?.delegate = self
                
 
           }
       }
        
    }
    
    

    func loadMediaList1() {
        // Look up the media list URL.
        
        
        
        let titile = (dictDetail.object(forKey:"title") as? String)
        let desc = nullToNil(value: dictDetail.object(forKey: "des") as AnyObject) as! NSString
        let metadata = GCKMediaMetadata()
        metadata.setString(titile!, forKey: kGCKMetadataKeyTitle)
        metadata.setString(desc as String,
                           forKey:kGCKMetadataKeySubtitle)
        let url = NSURL(string:self.cromecastimageurl)
        print(url)
        print(videoresoulationurlarray.object(at: videoresoulationurlarray.count-1) as! String)
        metadata.addImage(GCKImage(url: url as! URL, width: 480, height: 360))
        mediaInfo =    GCKMediaInformation(
            contentID:
            videoresoulationurlarray.object(at: videoresoulationurlarray.count-2) as! String,
            streamType: GCKMediaStreamType.none,
            contentType: "video/mp4",
            metadata: metadata,
            streamDuration: 0,
            mediaTracks: [],
            textTrackStyle: nil,
            customData: nil
        )
        
       
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
             stopplayerifcastingenable()
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = mediaInfo
            builder.autoplay = true
            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build
            
              let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
             let request = castSession?.remoteMediaClient?.queueLoad([item()], start: 0, playPosition: 0,
                                                                    repeatMode: repeatMode, customData: nil)
             request?.delegate = self
            
            
      
        }
        
    }
    

    func switchToRemotePlayback()
    {
        print("switchToRemotePlayback; mediaInfo is \(String(describing: self.mediaInfo))")
        if self.playbackMode == .remote {
            return
        }
        if self.sessionManager.currentSession is GCKCastSession {
            self.castSession = (self.sessionManager.currentSession as? GCKCastSession)
        }
        
        self.castSession?.remoteMediaClient?.add(self)
        self.playbackMode = .remote
    }
    
    func switchToLocalPlayback() {
        print("switchToLocalPlayback")
        if self.playbackMode == .local {
            return
        }
        var playPosition: TimeInterval = 0
        var paused: Bool = false
        var ended: Bool = false
        if self.playbackMode == .remote {
            playPosition = self.castMediaController.lastKnownStreamPosition
            paused = (self.castMediaController.lastKnownPlayerState == .paused)
            ended = (self.castMediaController.lastKnownPlayerState == .idle)
            print("last player state: \(self.castMediaController.lastKnownPlayerState), ended: \(ended)")
        }
        self.castSession?.remoteMediaClient?.remove(self)
        self.castSession = nil
        self.playbackMode = .local
    }
    
    
    
    
    func clearMetadata() {
        
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil,
                                cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }
    // MARK: - Local playback UI actions
    
    func startAdjustingStreamPosition(_ sender: Any) {
        self.streamPositionSliderMoving = true
    }
    
    func finishAdjustingStreamPosition(_ sender: Any) {
        self.streamPositionSliderMoving = false
    }
    
    func togglePlayPause(_ sender: Any) {
    }
    // MARK: - GCKSessionManagerListener
    
    

    
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        print("MediaViewController: sessionManager didStartSession \(session)")
        self.switchToRemotePlayback()
        self.loadMediaList()

    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        print("MediaViewController: sessionManager didResumeSession \(session)")
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        print("session ended with error: \(String(describing: error))")
        let message = "The Casting session has ended.\n\(String(describing: error))"
        self.resumeplayerifcastingdisable()
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
         if let window = appDelegate?.window {
            Toast.displayMessage(message, for: 3, in: window)
        }
        self.switchToLocalPlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        if let error = error {
        self.showAlert(withTitle: "Failed to start a session", message: error.localizedDescription)
              NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            self.resumeplayerifcastingdisable()
        }
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager,
                        didFailToResumeSession session: GCKSession, withError error: Error?) {
        if let window = UIApplication.shared.delegate?.window {
            Toast.displayMessage("The Casting session could not be resumed.",
                                 for: 3, in: window)
        }
        self.switchToLocalPlayback()
    }
    
    
    
    
    
    
    // MARK: - GCKRemoteMediaClientListener
    
    func remoteMediaClient(_ player: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        self.mediaInfo = mediaStatus?.mediaInformation
      print(mediaStatus?.mediaInformation?.customData.debugDescription)
        print(mediaStatus?.mediaInformation?.contentID)
 
        
    }
   

    
    /* Play has been pressed in the LocalPlayerView. */
    
    func continueAfterPlayButtonClicked() -> Bool {
        let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
        if (self.mediaInfo != nil) && hasConnectedCastSession() {
            // Display an alert box to allow the user to add to queue or play
            // immediately.
            if self.actionSheet == nil {
                self.actionSheet = ActionSheet(title: "Play Item", message: "Select an action", cancelButtonText: "Cancel")
                self.actionSheet?.addAction(withTitle: "Play Now", target: self,
                                            selector: #selector(self.playSelectedItemRemotely))
                self.actionSheet?.addAction(withTitle: "Add to Queue", target: self,
                                            selector: #selector(self.enqueueSelectedItemRemotely))
            }
            self.actionSheet?.present(in: self, sourceView: self.view)
            return false
        }
        return true
    }
    
    func playSelectedItemRemotely() {
        self.loadSelectedItem(byAppending: false)
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    
    func enqueueSelectedItemRemotely() {
        self.loadSelectedItem(byAppending: true)
        let message = "Added \"\(self.mediaInfo?.metadata?.string(forKey: kGCKMetadataKeyTitle) ?? "")\" to queue."
        if let window = UIApplication.shared.delegate?.window {
            Toast.displayMessage(message, for: 3, in: window)
        }
    }
    /**
     * Loads the currently selected item in the current cast media session.
     * @param appending If YES, the item is appended to the current queue if there
     * is one. If NO, or if
     * there is no queue, a new queue containing only the selected item is created.
     */
    
    func loadSelectedItem(byAppending appending: Bool) {
        print("enqueue item \(String(describing: self.mediaInfo))")
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = self.mediaInfo
            builder.autoplay = true
             builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build()
            if ((remoteMediaClient.mediaStatus) != nil) && appending {
                let request = remoteMediaClient.queueInsert(item, beforeItemWithID: kGCKMediaQueueInvalidItemID)
                request.delegate = self
            } else {
                let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
                let request = remoteMediaClient.queueLoad([item], start: 0, playPosition: 0,
                                                          repeatMode: repeatMode, customData: nil)
                request.delegate = self
            }
        }
    }
    // MARK: - GCKRequestDelegate
    
    func requestDidComplete(_ request: GCKRequest) {
        print("request \(Int(request.requestID)) completed")
    }
    
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        print("request \(Int(request.requestID)) failed with error \(error)")
    }
    

    
  
    
    
    
    
    
    //////Ashish Change
    func getfavlist()
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = ["device":"ios","current_offset":"0","max_counter":"20","c_id":strID as String ]
            var url = String(format: "%@%@", LoginCredentials.Favelistapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
            objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getFavListResponse")
        }
    }
    
    @objc func getFavListResponse(notification: NSNotification)
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
        arrayTempContent = (dictContent.value(forKey: "result") as! NSDictionary).value(forKey: "content") as! NSArray
        favListArray = arrayTempContent.mutableCopy() as! NSMutableArray
        self.Changefavbuttonimage()
    }
    
    
    func isfavorite() ->Bool
    {
        
         if(iscontantfav)
        {
            return true
        }
      
          return false
        
        
     
        
    }
    
    
    func Changefavbuttonimage()
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            if(self.isfavorite())
            {
                
                let img = UIImage(named: "likeActive")
                btnLike.setImage(img, for: UIControlState.normal)
                
                
                
            }
            else
            {
                let img = UIImage(named: "likeInactive")
                btnLike.setImage(img, for: UIControlState.normal)
            }
            
        }
    }
    func call_New_cList()
    {
        let strStart = String(offSetStart)
        
        
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = ["device_unique_id":"dfsfdfd","device":"ios","current_offset":strStart,"max_counter":"10","cat_id":catID as String ,"cat_type":"video" as String,"user_id":strID]
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getDetailMoreResponse")
            
            var url = String(format: "%@%@", LoginCredentials.Listapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
             objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getDetailMoreResponse")
            //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getDetailMoreResponse" )
        }
        else
        {
            let json = ["device_unique_id":"dfsfdfd","device":"ios","current_offset":strStart,"max_counter":"10","cat_id":catID as String ,"cat_type":"video" as String,]
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getDetailMoreResponse")
            
            var url = String(format: "%@%@", LoginCredentials.Listapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
             objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getDetailMoreResponse")
            // objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getDetailMoreResponse" )
        }
    }
    @objc func getDetailMoreResponse(notification: NSNotification)
    {
        
        if offSetStart > 0 {
            self.listTblView.tableFooterView?.isHidden = true
        }
        else
        {
            // self.removeLoader()
        }
        
        var responseDict:NSDictionary=NSDictionary()
        var dictContent:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictContent=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        if arrayTempContent.count > 0
        {
            self.showListArray.addObjects(from: arrayTempContent as [AnyObject])
            self.contentArray.addObjects(from: arrayTempContent as [AnyObject])
            listTblView.reloadData()
            isNewDataLoading = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == listTblView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if isNewDataLoading == true
                {
                    
                }
                else
                {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if appDelegate.detailLoadMore == "load"
                    {
                        isNewDataLoading = true
                        offSetStart = offSetStart + 10
                        self.call_New_cList()
                        self.listTblView.tableFooterView?.isHidden = false
                        print("load more rows")
                    }
                    else
                    {
                        
                    }
                    
                }
            }
        }
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            var spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.listTblView.tableFooterView = spinner
            self.listTblView.tableFooterView?.isHidden = true
            
        }
    }
    func afterSessionLogin()
    {
        self.performSegue(withIdentifier: "detailLogin", sender: self)
    }
    
    
    

        
        
    
 
    
    func rotateddd()
    {
 
        expandBtn.isHidden = true
        
        if(self.avLayer != nil)
        {
               
       // if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        if (self.view.frame.size.width / self.view.frame.size.height > 1)
        {
            print("rotation Landscape")
            bEnlarge = true
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            self.avLayer.frame = rect
            backBtn.isHidden = false
            backUpperBtn.isHidden = true
            backLandBtn.isHidden = false
            bacwordbuttonupercnstraint.constant = rect.size.height/2 - 100.0
            let rectPlay = CGRect(x:39, y:self.view.frame.size.height-30, width:self.view.frame.size.width-120, height:25)
            self.playbackSlider.frame = rectPlay
            let rectLeft = CGRect(origin: CGPoint(x: 10,y :self.view.frame.size.height-23), size: CGSize(width: 30, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: self.view.frame.size.width-65,y :self.view.frame.size.height-23), size: CGSize(width: 30, height: 10))
            lblEnd.frame = rectRight
            expandBtn.isHidden = true
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :self.view.frame.size.height/2 - 35.0), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height-34), size: CGSize(width: 30, height: 30))
            enlargeBtn.frame = rectEnlarge
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-60,y :self.view.frame.size.height-64), size: CGSize(width: 90, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            
            blackBg.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
            activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
            Backbutton.isHidden = true
            nextbutton.isHidden = true
            Soundaudio.isHidden = true
            castButton.isHidden = true
            resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: enlargeBtn)
            self.view.bringSubview(toFront: enlargeBtnLayer)
            self.view.bringSubview(toFront: Backbutton)
            self.view.bringSubview(toFront: nextbutton)
            self.view.bringSubview(toFront: Soundaudio)
            self.view.bringSubview(toFront: castButton)
            self.view.bringSubview(toFront: resolutionbutton)
            
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            self.expandBtn.isHidden = true
        }
         // if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
         //if UIDevice.current.orientation.isPortrait
        else
        {
            bEnlarge = false
            print("rotation Portrait")
            if(self.tempView != nil)
            {
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
            self.avLayer.frame = rect
            backBtn.isHidden = false
            backLandBtn.isHidden = true
            backUpperBtn.isHidden = false
            let rectPlay = CGRect(x:39, y:157, width:self.view.frame.size.width-100, height:25)
            self.playbackSlider.frame = rectPlay
            expandBtn.isHidden = false
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :75), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            bacwordbuttonupercnstraint.constant = 13.0
            let rectLeft = CGRect(origin: CGPoint(x: 10,y :165), size: CGSize(width: 30, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: self.view.frame.size.width-60,y :165), size: CGSize(width: 30, height: 10))
            lblEnd.frame = rectRight
            
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-30,y :161), size: CGSize(width: 20, height: 20))
            enlargeBtn.frame = rectEnlarge
            blackBg.frame = CGRect(x:0, y:-10, width:self.view.frame.size.width+10, height:200)
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
        }
    }
       // if UIDevice.current.orientation.isLandscape
        }
        
    }
    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
        print("now")
        if self.videoPlayer.currentItem?.status == AVPlayerItemStatus.readyToPlay {
            print("ready")
        }
    }
    
    func changeOrientation()
    {
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func fetchHd()  {
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                if(Common.isNotNull(object: self.dictDetail.object(forKey:"url") as AnyObject?))
                {
                self.parseallsteme(url: (self.dictDetail.object(forKey:"url") as? String)!)
                }
                else
                {
                    
                }
            }
        }
    }
    func checkIsUserPaid()
    {
        if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
        {
            let subMode = UserDefaults.standard.value(forKey: "susubscription_mode") as! String
            if subMode == "free" || subMode == ""
            {
                print("free subscribe")
                if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                {
                    
                }
                else
                {
                }
            }
            else if subMode == "null"
            {
                print("Null subscribe")
                if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                {
                    
                }
                else
                {
                    
                }
            }
            else
            {
                print("paid subscribe")
            }
        }
        else
        {
            print("Null subscribe")
        }
    }
    
    
    
    
    func getvideoDetail()
    {
         seletetedresoltionindex = 0
         self.startloaderapi()
        
         var parameters = [String : Any]()
         LoginCredentials.Videoid = dictDetail.object(forKey: "id") as! String
         let contentId = dictDetail.object(forKey: "id") as? String
    
          var url = String()
            if(UserDefaults.standard.value(forKey: "loginData") as? String != nil)
            {
                 let userid = UserDefaults.standard.value(forKey: "loginData") as! String
                parameters = [ "content_id":contentId! as String,
                               "device":"ios",
                               "owner_info":"1",
                               "user_id": userid
                ]
                
                 url = String(format: "%@%@device/ios/content_id/%@/owner_info/1/user_id/%@/secure/1", LoginCredentials.Detailapi,Constants.APP_Token,contentId! as String,userid)
                
            }
            else
            {
                parameters = [ "content_id":contentId! as String,
                               "device":"ios",
                               "owner_info":"1",
                               "user_id": ""]
                
                
              url = String(format: "%@%@device/ios/content_id/%@/owner_info/1/secure/1", LoginCredentials.Detailapi,Constants.APP_Token,contentId! as String)
            }
            print(parameters)
            // var url = String(format: "%@%@", LoginCredentials.Detailapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
             let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    self.stoploaderapi()
                    print(responseObject)
                     let dict = responseObject as! NSDictionary
                    let resultCode = dict.object(forKey: "code") as! Int
                    if resultCode == 0
                    {
                        let alert = UIAlertController(title: "", message: "Getting Some error!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                            self.contantdisablebackaction()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                    let detaildict1 = (dict.value(forKey: "result") as! NSDictionary)
                    print(detaildict1)
                    self.dictDetail = detaildict1.value(forKey: "content") as! NSDictionary
  
                if(Common.isNotNull(object: self.dictDetail.object(forKey:"url") as AnyObject))
                 {
                    let videoURL = self.dictDetail.object(forKey:"url") as? String
                    if(videoURL == "")
                    {
                        let alert = UIAlertController(title: "", message: "Getting Some error!", preferredStyle: UIAlertControllerStyle.alert)
                          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                            self.contantdisablebackaction()
                         }))
                        
                        self.present(alert, animated: true, completion: nil)

                           return
                    }
                 
                    
                    }
                    self.detail_Information_Of_Video()
                    
                   
                    if let _ = (detaildict1.value(forKey: "content") as! NSDictionary).value(forKey: "thumbs")
                    {
                        
                        if(Common.isNotNull(object: (detaildict1.value(forKey: "content") as! NSDictionary).value(forKey: "thumbs") as AnyObject))
                        {
                    if(((detaildict1.value(forKey: "content") as! NSDictionary).value(forKey: "thumbs") as! NSArray).count>0)
                    {
                     self.cromecastimageurl = ((((detaildict1.value(forKey: "content") as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    }
                    }
                    }
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                 self.stoploaderapi()
                let alert = UIAlertController(title: "", message: "Getting Some error!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    self.contantdisablebackaction()
                }))
                 self.present(alert, animated: true, completion: nil)
                
                print("POST fails with error \(error)")
            }
 
    }
    
    
    
    /////Get user seesion
    
    func getUsersession()
    {
        
        if(Common.isuserlogin())
        {
        let userid = UserDefaults.standard.value(forKey: "loginData") as! String
        
        let parameters = ["customer_id":userid,"device_type":"ios","device_unique_id" : UserDefaults.standard.value(forKey: "UUID") as! String]
        print(parameters)
        var url = String(format: "%@%@", LoginCredentials.Isplaybackallowedapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let resultCode = dict.object(forKey: "code") as! Int
                if resultCode == 1
                {
                    self.isAppsessionenble = true
                    print("Enable User Session")
                    if(self.checkcontantenable)
                    {
                        Common.ActivateUsersession()
                    }
                }
                else
                {
                    print("Disable User Session")

                    if self.videoPlayer != nil
                    {
                        self.videoPlayer.pause()
                    }
                    
                    self.isAppsessionenble = false
                    self.disableappsessionalert()
                    return
                    
                }
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        }
        
    }
    
    
    
    
    //Montserrat-Regular 11.0
    func detail_Information_Of_Video()
    {

        headingLbl.text = (dictDetail.object(forKey:"title") as? String)
        let desc = nullToNil(value: dictDetail.object(forKey: "des") as AnyObject) as! NSString
        if desc.length > 5 {
            descLbl.text = desc as String
        }
        else
        {
            heightDesc.constant = 0
        }
        NotificationCenter.default.addObserver(self,selector: #selector(get_Cat_Response),name: NSNotification.Name(rawValue: "getVideosDataResponse"),object: nil)
        print("dictDetail in method>>>",dictDetail)
        
        
        
        if(Common.isuserlogin())
        {
            
            if((dictDetail.value(forKey: "favorite") as! String) == "1")
            {
                self.iscontantfav = true
            }
            else
            {
                self.iscontantfav = false
            }
            
            self.Changefavbuttonimage()
        }
        
        
        if(checkcontantenable)
        {
            // self.getUsersession()
          if(Common.isNotNull(object: dictDetail.value(forKey: "is_playback_allowed") as AnyObject?))
        {
          if((dictDetail.value(forKey: "is_playback_allowed") as! String) == "1")
        {
             isAppsessionenble = true
            print("Enable User Session")
            if(self.checkcontantenable)
            {
                Common.ActivateUsersession()
            }
        }
        else
        {
            print("Disable User Session")
            isAppsessionenble = false
            disableappsessionalert()
            return
         }
        }
        }
       //}
        
        
        
        
        self.playvideoaftercheckingcontantsession()
        
//        LoginCredentials.VideoPlayingtime = 0
//        let videoURL = dictDetail.object(forKey:"url") as? String
//         print(videoURL)
//        self.perform(#selector(fetchHd), with: nil, afterDelay: 4.0)
//        self.skipStr  = "no"
//        if(Common.isNotNull(object: videoURL as AnyObject?))
//        {
//        
//        self.playvideo(url: videoURL!)
//            
//        }
//         self.listTblView.reloadData()
    }
    
    
    
    
    func playvideoaftercheckingcontantsession()
    {
        
        LoginCredentials.VideoPlayingtime = 0
        let videoURL = dictDetail.object(forKey:"url") as? String
        print(videoURL)
        self.perform(#selector(fetchHd), with: nil, afterDelay: 4.0)
        self.skipStr  = "no"
        if(Common.isNotNull(object: videoURL as AnyObject?))
        {
            
            self.playvideo(url: videoURL!)
            
        }
        self.listTblView.reloadData()
        
    }
    
    
    func disableappsessionalert()
    {
         let alert = UIAlertController(title: "", message: "This account is playing a video on another device.", preferredStyle: UIAlertControllerStyle.alert)
      
        
        alert.addAction(UIAlertAction(title: "Watch it here", style: UIAlertActionStyle.default, handler: { (action) in
            Common.ActivateUsersession()
            self.playvideoaftercheckingcontantsession()
        }))
        alert.addAction(UIAlertAction(title: "Watch on other device", style: UIAlertActionStyle.default, handler: { (action) in
            self.contantdisablebackaction()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.backstoppalyer()
            })
            return
        }))
        
        if(!LoginCredentials.Issociallogin)
        {
            alert.addAction(UIAlertAction(title: "Change password", style: UIAlertActionStyle.default, handler: { (action) in
                self.forgotpasswordapi()
                    return
                
            }))
        }
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func forgotpasswordapi()
    {
        self.startloaderapi()
        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! NSData
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! NSDictionary
        let email = decodedTeams.object(forKey: "email") as? String
        let json = ["email":email! as String,"device":"ios","device_unique_id":UserDefaults.standard.value(forKey: "UUID") as! String]
        print("json >>",json)
        var url = String(format: "%@%@", LoginCredentials.Forgotapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            let dict = responseObject as! NSDictionary
            print(dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getForgotResponse"), object: dict)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
           self.stoploaderapi()
            
        })
        
        
        //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getForgotResponse" )
    }
    
    
    
    
    @objc func getForgotResponse(notification: NSNotification)
    {
       self.stoploaderapi()
        var responseDict:NSDictionary=NSDictionary()
        
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictResponse=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        
        let resultCode = dictResponse.object(forKey: "code") as! Int
        if resultCode == 1
        {
            
            
            let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
            if hasConnectedSession && (self.playbackMode == .remote) {
                  self.sessionManager.currentCastSession?.endAndStopCasting(true)
             }

            
            if self.videoPlayer != nil
            {
                self.videoPlayer.pause()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.backstoppalyer()
            })
              let alert = UIAlertController(title: "Message", message: dictResponse.object(forKey: "result") as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        else
        {
            let alert = UIAlertController(title: "Message", message: dictResponse.object(forKey: "error") as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
      }

    
    
    func contantdisablebackaction()
    {
      self.navigationController?.popViewController(animated: true)
    }
    
    
    func playvideo(url:String)
    {
 
        let videoURL = URL(string:url)
        DispatchQueue.main.async { () -> Void in
            let rect = CGRect(origin: CGPoint(x: 0,y :-10), size: CGSize(width: self.view.frame.size.width, height: 200))
            let playerItem:AVPlayerItem = AVPlayerItem(url: videoURL!)
            if (self.blackBg != nil)
            {
                self.blackBg.removeFromSuperview()
                self.blackBg = nil
            }
            self.blackBg = UIView(frame:CGRect(x:0, y:0, width:self.view.frame.size.width+10, height:200))
            self.blackBg.backgroundColor=UIColor.init(colorLiteralRed: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0, alpha: 1.0)
            self.view.addSubview(self.blackBg)
            
            if self.avLayer != nil
            {
                self.avLayer.removeFromSuperlayer()
                self.avLayer = nil
            }
            if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
            {
                self.videoPlayer = nil
            }
            self.videoPlayer = AVPlayer(playerItem: playerItem)
            self.avLayer = AVPlayerLayer(player:self.videoPlayer)
            self.avLayer.frame = rect
            self.avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            do
            {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(self.startplayingnotification), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: self.videoPlayer.currentItem)
            
            self.view.layer.addSublayer(self.avLayer)
            if (self.skipStr == "no")
             {
            self.videoPlayer.play()
            }
            
            if (self.tempView != nil)
            {
                self.tempView.removeFromSuperview()
                self.tempView = nil
            }
            self.tempView = UIView(frame:CGRect(x:0, y:-10, width:self.view.frame.size.width+10, height:200))
            self.tempView.backgroundColor=UIColor.clear
            self.view.addSubview(self.tempView)
            
            if self.playbackSlider != nil
            {
                self.playbackSlider.removeFromSuperview()
            }
            self.playbackSlider = UISlider(frame:CGRect(x:39, y:157, width:self.view.frame.size.width-100, height:25))
            let leftTrackImage = UIImage(named: "sliderThumb")
            let minImage = UIImage(named: "lineRed")
            let maxImage = UIImage(named: "lineGray")
            self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
            self.playbackSlider.minimumValue = 0
            // playbackSlider.maximumValue = 100
            self.playbackSlider.setValue(0, animated: true)
            self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
            self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
            let duration : CMTime = playerItem.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            //playerViewController.player = player
            let endInterval = NSDate(timeIntervalSince1970:seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.local
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateTimeFromPublishedString = dateFormatter.string(from: endInterval as Date)
            if seconds != seconds
            {
                self.playbackSlider.maximumValue = Float(0.0)
            }
            else
            {
                self.playbackSlider.maximumValue = Float(seconds)
            }
            
            self.playbackSlider.isContinuous = true
            self.playbackSlider.tintColor = UIColor.green
            
            if (self.timer != nil)
            {
                self.timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            //Swift 2.2 selector syntax
            self.playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
            self.view.addSubview(self.playbackSlider)
            
            self.view.bringSubview(toFront: self.tempView)
            self.view.bringSubview(toFront: self.playbackSlider)
            //duration
            let rectLeft = CGRect(origin: CGPoint(x: 10,y :175), size: CGSize(width: 30, height: 10))
            if self.lblLeft != nil
            {
                self.lblLeft.removeFromSuperview()
            }
            self.lblLeft.backgroundColor = UIColor.clear
            self.lblLeft.font = UIFont.systemFont(ofSize: 8)
            self.lblLeft.textColor = UIColor.white
            self.lblLeft.text = "00:00"
            self.lblLeft.frame = rectLeft
            self.tempView.addSubview(self.lblLeft)
            let timeDuration = Float(seconds)
            //singleTapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped))
            tap.numberOfTapsRequired = 2
            self.tempView.addGestureRecognizer(tap)
            
            let singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
            singletap.numberOfTapsRequired = 1
            self.tempView.addGestureRecognizer(singletap)
            
            let (hr,  minf) = modf (timeDuration / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            let hoursString = String(hr)
            let minutesString = String(min)
            let secondString = String(second)
            let timeEnd = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            
            let rectRight = CGRect(origin: CGPoint(x: self.tempView.frame.size.width-65,y :175), size: CGSize(width: 30, height: 10))
            if self.lblEnd != nil
            {
                self.lblEnd.removeFromSuperview()
            }
            self.lblEnd.backgroundColor = UIColor.clear
            self.lblEnd.font = UIFont.systemFont(ofSize: 8)
            self.lblEnd.text = timeEnd as String
            self.lblEnd.frame = rectRight
            self.lblEnd.textColor = UIColor.white
            self.tempView.addSubview(self.lblEnd)
            
            if self.expandBtn != nil
            {
                self.expandBtn.removeFromSuperview()
            }
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :97), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            self.expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            self.expandBtn.isHidden = true
            if self.enlargeBtn != nil
            {
                self.enlargeBtn.removeFromSuperview()
            }
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-20,y :171), size: CGSize(width: 20, height: 20))
            //expandPlayer
            let expandImage = UIImage(named: "expandPlayer")
            self.enlargeBtn.setImage(expandImage, for: .normal)
            self.enlargeBtn.frame = rectEnlarge
            self.enlargeBtn.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            self.tempView.addSubview(self.expandBtn)
            self.tempView.bringSubview(toFront: self.expandBtn)
            
            self.tempView.addSubview(self.enlargeBtn)
            self.tempView.bringSubview(toFront: self.enlargeBtn)
            
            if self.enlargeBtnLayer != nil
            {
                self.enlargeBtnLayer.removeFromSuperview()
            }
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            //expandPlayer
            let expandLayerImage = UIImage(named: "")
            self.enlargeBtnLayer.setImage(expandLayerImage, for: .normal)
            self.enlargeBtnLayer.frame = rectEnlargeLayer
            self.enlargeBtnLayer.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            self.tempView.addSubview(self.enlargeBtnLayer)
            self.tempView.bringSubview(toFront: self.enlargeBtnLayer)
            self.Backbutton.isHidden = true
            self.nextbutton.isHidden = true
            self.Soundaudio.isHidden = true
            self.castButton.isHidden = true
            
            self.resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: self.Backbutton)
            self.view.bringSubview(toFront: self.nextbutton)
            self.view.bringSubview(toFront: self.Soundaudio)
            self.view.bringSubview(toFront: self.castButton)
            self.view.bringSubview(toFront: self.backBtn)
            self.view.bringSubview(toFront: self.backUpperBtn)
            self.view.bringSubview(toFront: self.backLandBtn)
            self.backLandBtn.isHidden = true
            self.view.bringSubview(toFront: self.resolutionbutton)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
            self.playerSkipTime = self.playerTime
            self.playerTime = 0
            UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
            self.startloader()
            self.rotateddd()
            self.hideOnLoad()
            self.view.bringSubview(toFront: self.btnLike)
        }
        
    }
    
    
    func parseallsteme(url:String)
    {
        
        do {
        videoresoulationtypearray.removeAllObjects()
        videoresoulationurlarray.removeAllObjects()
        let typenadresolutionarray = NSMutableDictionary()
         let xStreamList = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList
        let count1 = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList.count


            
            for i in 0..<count1 {
                
                let str = (xStreamList?.xStreamInf(at: i).resolution.height)! as Float
                let str1 = "\(str.cleanValue)\("P")"
                //let str1 = str.cleanValue

                typenadresolutionarray.setValue((xStreamList?.xStreamInf(at: i).m3u8URL())!, forKey: str1)
            }
              print(typenadresolutionarray)
              let reverser = typenadresolutionarray.sorted(by: { (a, b) in ((a.key as! NSString).intValue) < ((b.key as! NSString).intValue) })
               print(reverser)
            
            for i in 0..<reverser.count {
                videoresoulationtypearray.add(reverser[i].key)
                videoresoulationurlarray.add(reverser[i].value)
            }
            videoresoulationtypearray.insert("Auto", at: 0)
            videoresoulationurlarray.insert(url, at: 0)
            

            
            let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
            if hasConnectedSession && (self.playbackMode == .remote) {
                //self.switchToRemotePlayback()
                  if(self.videoPlayer == nil)
                {
                }
                else
                {
                    self.stopplayerifcastingenable()
                }
                 self.loadMediaList1()
             }
            
            
        
        }
        catch
        {
            print(error.localizedDescription)
        }
       
    }
    
    func startplayingnotification(note: NSNotification)
    {
        
        expandBtn.isHidden = true
        self.stoploader()
        if self.skipStr == "no"
        {
        }
        else
        {
            print("self.playerTime >>>",self.playerSkipTime)
            let seconds : Int64 = Int64(self.playerSkipTime)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            self.videoPlayer!.seek(to: targetTime)
            self.videoPlayer.play()
        }
        
        
        
        //        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        //        DispatchQueue.main.asyncAfter(deadline: when) {
        //
        //            self.removecontroleronvideofter3sec()
        //        }
    }
    func hideOnLoad()
    {
        bHideControl = true
        btnLike.isHidden = true
        self.playbackSlider.isHidden = true
        self.lblLeft.isHidden = true
        self.lblEnd.isHidden = true
        self.enlargeBtn.isHidden = true
        self.enlargeBtnLayer.isHidden = true
        Backbutton.isHidden = true
        nextbutton.isHidden = true
        Soundaudio.isHidden = true
        castButton.isHidden = true
        resolutionbutton.isHidden = true
        self.expandBtn.isHidden = true
    }
    func removecontroleronvideofter3sec()
    {
        bHideControl = true
        btnLike.isHidden = true
        self.playbackSlider.isHidden = true
        self.lblLeft.isHidden = true
        self.lblEnd.isHidden = true
        self.enlargeBtn.isHidden = true
        self.enlargeBtnLayer.isHidden = true
        Backbutton.isHidden = true
        nextbutton.isHidden = true
        Soundaudio.isHidden = true
        castButton.isHidden = true
         resolutionbutton.isHidden = true
        self.expandBtn.isHidden = true
    }
    
    
    
    
   func stopplayerifcastingenable()
   {
    
      bPlay = false
      expandBtnAction()
       self.playbackSlider.isUserInteractionEnabled = false
     self.enlargeBtn.isUserInteractionEnabled = false
     self.enlargeBtnLayer.isUserInteractionEnabled = false
     nextbutton.isUserInteractionEnabled = false
     Soundaudio.isUserInteractionEnabled = false
     resolutionbutton.isUserInteractionEnabled = false
     self.expandBtn.isUserInteractionEnabled = false
    }
    
    
    func resumeplayerifcastingdisable()
    {
        
         bPlay = true
        expandBtnAction()
          self.playbackSlider.isUserInteractionEnabled = true
        self.enlargeBtn.isUserInteractionEnabled = true
        self.enlargeBtnLayer.isUserInteractionEnabled = true
        nextbutton.isUserInteractionEnabled = true
        Soundaudio.isUserInteractionEnabled = true
        resolutionbutton.isUserInteractionEnabled = true
        self.expandBtn.isUserInteractionEnabled = true
    }
    
    
    
    
    func startloaderapi()
    {

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: CGFloat(self.view.frame.size.width/2-25), y: CGFloat(75), width:CGFloat(50), height: CGFloat(50))
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    
    
    func stoploaderapi()
    {
   
     activityIndicator.removeFromSuperview()
    }

    
    
    
    func startloader()
    {
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
        activityIndicator.startAnimating()
        self.tempView.addSubview(activityIndicator)
    }
    
    func stoploader()
    {
        activityIndicator.removeFromSuperview()
    }
    func downloadSheet()
    {
        
        let orderedSet = NSOrderedSet(object: videoresoulationtypearray)
        
        let set = NSSet(array: [videoresoulationtypearray.mutableCopy()])
        videoresoulationtypearray.removeAllObjects()
        let array1:NSMutableArray=NSMutableArray()
        array1.add(set.allObjects)
        videoresoulationtypearray = (((array1.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
        
        let set1 = NSSet(array: [videoresoulationurlarray.mutableCopy()])
        videoresoulationurlarray.removeAllObjects()
        let array2:NSMutableArray=NSMutableArray()
        array2.add(set1.allObjects)
        videoresoulationurlarray = (((array2.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
        
        let actionSheet = UIActionSheet(title: "Video Quality", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        for i in 0..<videoresoulationtypearray.count {
            
            
            if(i == seletetedresoltionindex)
            {
                actionSheet.addButton(withTitle: "\(videoresoulationtypearray.object(at: i) as! String)\(" ✓")")
            }
            else
            {
                actionSheet.addButton(withTitle: videoresoulationtypearray.object(at: i) as? String)
            }
            
            
            
         }
        actionSheet.show(in: view)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex>0 {
            
            
            
            seletetedresoltionindex = buttonIndex-1

            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                avLayer.removeFromSuperlayer()
                self.videoPlayer.pause()
                self.videoPlayer = nil
            }
            
            self.skipStr  = "yes"
            self.playvideo(url: videoresoulationurlarray.object(at: buttonIndex-1) as! String)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                if(self.bPlay)
                {
                 self.bPlay = false
                }
                else
                 {
                 self.bPlay = true
                 }
                self.expandBtnAction()
            
             })
            
            
            
            
        }
    }
    
    @IBAction func changequalityofvideo(_ sender: Any)
    {
        self.downloadSheet()
    }
    
    
    @IBAction func TaptoSound(_ sender: UIButton)
    {
     
        if(self.videoPlayer != nil)
        {
        
        if (sender.currentImage?.isEqual(UIImage(named: "SoundUnmute")))! {
            //do something here
            self.videoPlayer.isMuted = true
            sender.setImage(UIImage.init(named: "Soundmute"), for: .normal)
        }
        else
        {
            self.videoPlayer.isMuted = false
            sender.setImage(UIImage.init(named: "SoundUnmute"), for: .normal)
        }
        }
    }
    
    @IBAction func tapTo_playnextvideo(_ sender: UIButton) {
        
        let seconds : Int64 = Int64(playbackSlider.value + 15.0)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        if self.videoPlayer!.rate == 0
        {
            if bPlay == true
            {
                bPlay = false
            }
            expandBtnAction()

        }
    }
    
    @IBAction func Taptoplaypreviousvideo(_ sender: UIButton)
    {
        if(playbackSlider.value < 5.0)
        {
            
        }
        else
        {
            let seconds : Int64 = Int64(playbackSlider.value - 5.0)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            self.videoPlayer!.seek(to: targetTime)
            self.playbackSlider.value = Float(CGFloat(seconds))
            self.bSlideBar = true
            
            
            if self.videoPlayer!.rate == 0
            {
                if bPlay == true
                {
                    bPlay = false
                }
                expandBtnAction()
             }
        }
    }
    
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        if self.videoPlayer!.rate == 0
        {
            if bPlay == true
            {
              bPlay = false
            }
            expandBtnAction()
         }
    }
    
    func playerDidFinishPlaying(note: NSNotification)
    {
      
        Common.callheartBeatapi()
        
         if showListArray.count > 0 {
             playedIndex = playedIndex + 1
            self.playNextVideo()
            self.Changefavbuttonimage()
          }
        else
         {
            self.videoPlayer.pause()
            bPlay = true
            let image = UIImage(named:"play")
            self.expandBtn.setImage(image, for: .normal)
        }
        
    }
    
    
    
    
    
    
    func poptologout()
    {
        if(Common.isuserlogin())
        {
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote) {
            self.sessionManager.currentSession?.endAndStopCasting(true)
        }
        
         if self.videoPlayer != nil
        {
            self.videoPlayer.pause()
        }
      
        Common.DeActivateUsersession()
        UserDefaults.standard.set("", forKey: "sessionID")
        UserDefaults.standard.set(nil, forKey: "loginData")
        UserDefaults.standard.set(nil, forKey: "UserID")
        UserDefaults.standard.set("slider", forKey: "screenFrom")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginScreen"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.backstoppalyer()
        })
            
          //  self.navigationController?.popToRootViewController(animated: true)
          //  self.dismiss(animated: true, completion: nil)
            
            let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
             addChildViewController(controller)
             view.addSubview(controller.view)
       // self.navigationController?.popToRootViewController(animated: true)
        }
       }
    
    
    
    func playNextVideo()  {
        
        
          if playedIndex < showListArray.count
        {
            dictDetail = showListArray.object(at: playedIndex) as! NSDictionary
        }
        else
        {
            playedIndex = 0
            dictDetail = showListArray.object(at: 0) as! NSDictionary
        }
        checkcontantenable = false
        getvideoDetail()
       // self.detail_Information_Of_Video()
        
    }
    
    @IBAction func btnLandAction(_ sender: Any) {
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
    
    func enlargeBtnAction()
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
    
    func doubleTapped() {
        
        
    }
    func singleTapped() {
        
        if bHideControl == true
        {
            
            self.perform(#selector(self.removecontroleronvideofter3sec), with: self, afterDelay: 4)
//            let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                
//                self.removecontroleronvideofter3sec()
//            }
            bHideControl = false
            self.playbackSlider.isHidden = false
            self.lblLeft.isHidden = false
            self.lblEnd.isHidden = false
            self.enlargeBtn.isHidden = false
            self.enlargeBtnLayer.isHidden = false
            Backbutton.isHidden = false
            nextbutton.isHidden = false
            Soundaudio.isHidden = false
            castButton.isHidden = false

            self.btnLike.isHidden = false
            resolutionbutton.isHidden = false
            self.expandBtn.isHidden = false
        }
        else
        {
          //  NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.removecontroleronvideofter3sec), object: nil)
            bHideControl = true
            self.btnLike.isHidden = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            Backbutton.isHidden = true
            nextbutton.isHidden = true
            Soundaudio.isHidden = true
            castButton.isHidden = true
             resolutionbutton.isHidden = true
            self.expandBtn.isHidden = true
        }
        
    }
    func hideControlBtnAction() {
        
    }
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (hr, min, 60 * secf)
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width:rect.size.width,height:rect.size.height)
        return size
    }
    func redirectTosubscribe()
    {
       
         if(Common.isuserlogin())
        {
            Common.DeActivateUsersession()
        }
        
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        if self.videoPlayer != nil
        {
            self.videoPlayer.pause()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
        self.playerTime = 0
        UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            //showSubscribe
            self.performSegue(withIdentifier: "showSubscribe", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "showSubscribe", sender: self)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.backstoppalyer()
        })
    }
    func expandBtnAction()
    {
        if bPlay == true
        {
            if(self.videoPlayer != nil)
            {
            self.videoPlayer.play()
            }
            bPlay = false
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
        }
        else
        {
            if(self.videoPlayer != nil)
            {
            self.videoPlayer.pause()
            }
            bPlay = true
            let image = UIImage(named:"play")
            self.expandBtn.setImage(image, for: .normal)
        }
    }
    
    @IBAction func moreBtnAction(_ sender: Any) {
        
    }
    @objc func get_Cat_Response(notification: NSNotification)
    {
        var responseDict:NSDictionary=NSDictionary()
        var dictContent:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictContent=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        contentArray = arrayTempContent.mutableCopy() as! NSMutableArray
        listTblView.reloadData()
    }
    
    
       //////Ashish Change
    @IBAction func btn_Like(_ sender: Any) {
        
 
        let likes = dictDetail.object(forKey: "favorite") as? String
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let contentId = dictDetail.object(forKey: "id") as? String
            let strID = UserDefaults.standard.value(forKey: "loginData") as? String
            if strID == "" {
                let alert = UIAlertController(title: "Message", message: "Please login first", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                
                
            else
            {
                if(self.isfavorite())
                {
                    favUnFav = "unfav"
                 //   btnLike.isEnabled = false
                    let json = ["device":"ios",
                                "user_id":strID,
                                "type":"video",
                                "content_id":contentId,
                                "favorite":"0",
                                "content_type":"video"] as! [String:String]
                    var url = String(format: "%@%@", LoginCredentials.Favrioutapi,Constants.APP_Token)
                    url = url.trimmingCharacters(in: .whitespaces)
                    print(url)
                    print(json)
                    
                    let manager = AFHTTPSessionManager()
                    manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                        if (responseObject as? [String: AnyObject]) != nil {
                            let dict = responseObject as! NSDictionary
                            print(dict)
                            self.iscontantfav = false
                             self.Changefavbuttonimage()
                              let alert = UIAlertController(title: "Message", message: "Removed from 'My Favorites'", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        
                          //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getLikeButtonResponse"), object: dict)
                            
                            
                        }
                    }) { (task: URLSessionDataTask?, error: Error) in
                        print("POST fails with error \(error)")
                    }
                    
                    
                    
                    // objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getLikeButtonResponse" )
                }
                else
                {
                    favUnFav = "fav"
                   // btnLike.isEnabled = false
                    let json = ["device":"ios",
                                "user_id":strID,
                                "type":"video",
                                "content_id":contentId,
                                "favorite":"1",
                    "content_type":"video"] as! [String:String]
                    var url = String(format: "%@%@", LoginCredentials.Favrioutapi,Constants.APP_SOCIAL_Token)
                    url = url.trimmingCharacters(in: .whitespaces)
                    print(url)
                    print(json)
                    let manager = AFHTTPSessionManager()
                    manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                        if (responseObject as? [String: AnyObject]) != nil {
                            let dict = responseObject as! NSDictionary
                            print(dict)
                            self.iscontantfav = true
                          self.Changefavbuttonimage()
                            let alert = UIAlertController(title: "Message", message: "Added to 'My Favorites'", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                             // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                            // print(Catdata_dict)
                    //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getLikeButtonResponse"), object: dict)
                            
                            
                        }
                    }) { (task: URLSessionDataTask?, error: Error) in
                        print("POST fails with error \(error)")
                     }
                    
                    
                    
                 //   objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getLikeButtonResponse" )
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Please login first", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func getLikeButtonResponse(notification: NSNotification)
    {
        btnLike.isEnabled = true
        var responseDict:NSDictionary=NSDictionary()
        responseDict=notification.object as! NSDictionary
        print(responseDict)
        let response = responseDict.object(forKey: "code") as! Int
        if response == 1
        {
            let result = responseDict.object(forKey: "result") as! Int
            if result == 1
            {
                if favUnFav == "fav"{
                    let img = UIImage(named: "likeActive")
                    btnLike.setImage(img, for: UIControlState.normal)
                    
                    let alert = UIAlertController(title: "Message", message: "Added to 'My Favorites'", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let img = UIImage(named: "likeInactive")
                    btnLike.setImage(img, for: UIControlState.normal)
                    let alert = UIAlertController(title: "Message", message: "Removed from 'My Favorites'", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else
            {
                //let img = UIImage(named: "likeInactive")
              //  btnLike.setImage(img, for: UIControlState.normal)
               // let alert = UIAlertController(title: "Message", message: "Removed from 'My Favorites'", preferredStyle: UIAlertControllerStyle.alert)
             //   alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
              //  self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: responseDict.object(forKey: "result") as! String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.getfavlist()
    }
    func call_cList()
    {
        let json = ["device_unique_id":"dfsfdfd","device":"ios","current_offset":"0","max_counter":"20","cat_id":strCatID as String ,"cat_type":"video" as String]
        let defaults = UserDefaults.standard
        defaults.set(json, forKey: "getVideosDataResponse")
        
        var url = String(format: "%@%@", LoginCredentials.Listapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
         objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getVideosDataResponse")
        //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getVideosDataResponse" )
    }
    
    
    
    
    
    func Sendaginpaymentrasonserver(dict:NSDictionary)
    {
        
        let strID = UserDefaults.standard.value(forKey: "loginData") as! String
         let json = ["device":"ios","c_id":strID as String,"trans_id":dict.value(forKey: "transid") as! String,"signature":"","status":"1","order_id":dict.value(forKey: "orderid") as! String] as [String : Any]
        print("Payment >>",json)
        var url = String(format: "%@%@", LoginCredentials.Subscriptionpaymentv2,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
         objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentResponse" )
    }
    
    
    
    @objc func getPaymentResponse(notification: NSNotification)
    {
          let dictPayment=notification.object as! NSDictionary
         print("dictResponse >>>",dictPayment)
        let resultCode = dictPayment.object(forKey: "code") as! Int
        let strID = UserDefaults.standard.value(forKey: "loginData") as! String
        if resultCode == 1
        {
             APPDataBase.deleteIAPfailddata(userid:strID )

         }

    
    }
    
    func paymentfailedrenewvelsubscripton()
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            
            
            
            ///////USER IAP PAYMENT SUCEESS BUT SERVER PROBLEM/////////////////////
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let iapdatdict =  APPDataBase.getIAPfaildatabase(userid: strID)
            print(iapdatdict)
            if(iapdatdict.count>0)
            {
                Sendaginpaymentrasonserver(dict: iapdatdict)
                return
            }
        }}
    
    
    
    
    func update()
    {
        if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
        {
            let currentItem:AVPlayerItem = videoPlayer.currentItem!
            let duration:CMTime = currentItem.duration
            let videoDUration:Float = Float(CMTimeGetSeconds(duration))
            let currentTime:Float = Float(CMTimeGetSeconds(videoPlayer.currentTime()))
             if self.bSlideBar == true
            {
                let time = Int(currentTime)
                let timePlay = Int(self.playbackSlider.value)
                if time == timePlay {
                    self.bSlideBar = false
                }
            }
            else
            {
                self.playbackSlider.value = currentTime
            }
            
              playerTime = Int(currentTime)
             LoginCredentials.VideoPlayingtime = playerTime
             if(Common.isuserlogin()) {
                 if(Common.Isuserissubscribe(Userdetails: self)) {
                    
                }
                
                else
                {
                    self.redirectTosubscribe()
                    return
                }
                
            }
            
       
            else
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if UserDefaults.standard.value(forKey: "userCurrentPlay") != nil
                {
                    let time = UserDefaults.standard.value(forKey: "userCurrentPlay") as! Int
                    let countTime = time + playerTime
                    if countTime == Constants.SkipDuration || countTime > Constants.SkipDuration
                    {
                        if self.timer != nil
                        {
                            self.timer.invalidate()
                            self.timer  = nil
                        }
                        self.redirectTosubscribe()
                         return
                    }
            }
            }
            
            
            let (hr,  minf) = modf (currentTime / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            
            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            self.lblLeft.text = time
            
 /////////////////////////////////////////////AShish COde Subscripion//////////////////////////
            
            
//
//
//            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//            {
//
//
//                ///////  END/////////////////////
//
//
//                if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
//                {
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    print(appDelegate.subscribedItemArrays)
//
//                    if(appDelegate.subscribedItemArrays.count > 0)
//                    {
//                    let pkg_id = nullToNil(value: ((appDelegate.subscribedItemArrays.object(at: 0) as! NSDictionary).value(forKey: "package_id") as AnyObject)) as! String
//                    if pkg_id == ""
//                   {
//                    if((UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) == "free")
//                    {
//
//
//                    }
//                    else
//                    {
//                        //
//                        self.redirectTosubscribe()
//                        return
//                    }
//
//                    }
//                    }
//                    else
//                    {
//                        self.redirectTosubscribe()
//                        return
//
//                    }
//
//
//
//                }
//
//
//            }
//
// /////////////////////////////////////////////////////////////////////////////////////////////
//
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            if UserDefaults.standard.value(forKey: "userCurrentPlay") != nil
//            {
//                let time = UserDefaults.standard.value(forKey: "userCurrentPlay") as! Int
//                let countTime = time + playerTime
//                if countTime == Constants.SkipDuration || countTime > Constants.SkipDuration
//                {
//
//                    if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
//                    {
//                        let subMode = UserDefaults.standard.value(forKey: "susubscription_mode") as! String
//                        if subMode == "free" || subMode == ""
//                        {
//                            print("free subscribe")
//                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//                            {
//
//                            }
//                            else
//                            {
//                                if self.timer != nil
//                                {
//                                    self.timer.invalidate()
//                                    self.timer  = nil
//                                }
//                                self.redirectTosubscribe()
//                            }
//                        }
//                        else if subMode == "null"
//                        {
//                            print("Null subscribe")
//                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//                            {
//
//                            }
//                            else
//                            {
//                                if self.timer != nil
//                                {
//                                    self.timer.invalidate()
//                                    self.timer  = nil
//                                }
//                                self.redirectTosubscribe()
//                            }
//                        }
//                        else
//                        {
//                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//                            {
//                                if appDelegate.subscribedItemArrays.count > 0
//                                {
//
//
//                                    let pkg_id = nullToNil(value: ((appDelegate.subscribedItemArrays.object(at: 0) as! NSDictionary).value(forKey: "package_id") as AnyObject)) as! String
//
//                                    if pkg_id == ""
//                                    {
//                                        if((UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) == "free")
//                                        {
//
//
//                                        }
//                                        else
//                                        {
//
//                                            self.redirectTosubscribe()
//                                            return
//                                        }
//
//                                    }
//
//
//
//                                }
//                                else
//                                {
//                                    if self.timer != nil
//                                    {
//                                        self.timer.invalidate()
//                                        self.timer  = nil
//                                    }
//                                    self.redirectTosubscribe()
//                                }
//                            }
//                            else
//                            {
//                                if self.timer != nil
//                                {
//                                    self.timer.invalidate()
//                                    self.timer  = nil
//                                }
//                                self.redirectTosubscribe()
//                            }
//                        }
//                    }
//                    else
//                    {
//                        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//                        {
//
//                        }
//                        else
//                        {
//                            if self.timer != nil
//                            {
//                                self.timer.invalidate()
//                                self.timer  = nil
//                            }
//                            self.redirectTosubscribe()
//                        }
//                    }
//                }
//            }
//
//            let (hr,  minf) = modf (currentTime / 3600)
//            let (min, secf) = modf (60 * minf)
//            let second:Float =  60 * secf
//
//            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
//            self.lblLeft.text = time
        }
        
    }
    
    
    func userseessionexpire()
    {
      
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote) {
            self.sessionManager.currentSession?.endAndStopCasting(true)
        }
        let sender = UIButton()
        backAction(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.backstoppalyer()
        })
   
        
    }
    
    func backstoppalyer()
    {
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
     
        AppUtility.lockOrientation(.portrait)
        Common.DeActivateUsersession()
        Common.callheartBeatapi()
        LoginCredentials.PlayType = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
        UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
        avLayer.removeFromSuperlayer()
        playerControllerDetail.view.removeFromSuperview()
         
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
        
        
        
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            if UserDefaults.standard.value(forKey: "loginData") as? String == ""
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
            }
            else
            {
                UserDefaults.standard.set(nil, forKey: "playerSession")
            }
            
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        print("didReceiveMemoryWarning detail")
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if(tableView.indexPathsForVisibleRows?.index(of: indexPath) == nil)
        {
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return showListArray.count
    }
    func clearCell(cell:UITableViewCell){
        if let iv:UIImageView = cell.viewWithTag(101)! as? UIImageView
        {
            print("called tableview")
            iv.animationImages = nil
            iv.image = nil
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "listCell")! as UITableViewCell
        let timeBgView:UIView = cell.viewWithTag(105)!
        timeBgView.layer.cornerRadius=3
        
        let playImgVw:UIImageView = cell.viewWithTag(415)! as! UIImageView
        let logoImgVw:UIImageView = cell.viewWithTag(101)! as! UIImageView
        
        if playedIndex == indexPath.row {
            playImgVw.isHidden = false
            playImgVw.image = UIImage(named: "Detailplayvideo")
            
        }
        else
        {
            playImgVw.isHidden = true
        }
        
        
        if let val = ((showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
        {
            if(Common.isNotNull(object: (showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs") as AnyObject))
           
            {
            if(((showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
            {
                let imgThumbUrl = ((((showListArray.object(at: indexPath.item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
            
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
            logoImgVw.kf.setImage(with: urlImg,
                                  placeholder: nil,
                                  options: [.transition(ImageTransition.fade(1))],
                                  progressBlock: { receivedSize, totalSize in
            },
                                  completionHandler: { image, error, cacheType, imageURL in
            })
            
        }
            else
            {
                logoImgVw.image = #imageLiteral(resourceName: "higlightPlaceHolder")
                }
        }
            else
            {
                logoImgVw.image = #imageLiteral(resourceName: "higlightPlaceHolder")
            }
        
        }
        
        
        
        
        // let strUrl = (((showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)
       // let imgBaseUrl = (((showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
       // let imgThumbUrl = (((showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
        // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
        //let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.heightDetail,Constants.qualityBanner,Constants.widthDetail,imgThumbUrl)
       // print("downloadUrl >>>",downloadUrl)
       // let urlImg = URL(string:imgThumbUrl)
        
        // let imgURL = URL(string:strUrl!)
      //  logoImgVw.kf.setImage(with: urlImg,
       //                       placeholder: nil,
       //                       options: [.transition(ImageTransition.fade(1))],
      //                        progressBlock: { receivedSize, totalSize in
      //  },
      //                        completionHandler: { image, error, cacheType, imageURL in
     //   })
        logoImgVw.kf.indicatorType = .activity
        let headingLbl:UILabel = cell.viewWithTag(102)! as! UILabel
        headingLbl.text = (showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        
        //        let descLbl:UILabel = cell.viewWithTag(103)! as! UILabel
        //        descLbl.text = (showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"des") as? String
        var durationStr = String(format: "%@", ((showListArray.object(at:indexPath.item) as AnyObject).value(forKey:"duration") as? String)!)
        let durationLbl:UILabel = cell.viewWithTag(106)! as! UILabel
        
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
        
        durationLbl.text = durationStr
        
        // let dateLbl:UILabel = cell.viewWithTag(104)! as! UILabel
        // dateLbl.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Common.callheartBeatapi()
          tableView.deselectRow(at: indexPath, animated: true)
        dictDetail = showListArray.object(at: indexPath.row) as! NSDictionary
        showListArray.removeAllObjects()
        showListArray = NSKeyedUnarchiver.unarchiveObject(
            with: NSKeyedArchiver.archivedData(withRootObject: contentArray)) as! NSMutableArray
        playedIndex = indexPath.row
       //self.detail_Information_Of_Video()
        
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
        
        
         checkcontantenable = false
         getvideoDetail()
         self.Changefavbuttonimage()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
       
        super.viewWillDisappear(animated)
        //AppUtility.lockOrientation(.portrait)
        // AppUtility.lockOrientation([.portrait])
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
}
extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        
        let keysToRemove = dict.keys.filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        
        return dict
    }
}

 
