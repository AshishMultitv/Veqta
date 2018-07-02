//
//  LivePlayerViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 31/05/17.
//  Copyright © 2017 Multitv. All rights reserved.
//
import UIKit
import AVFoundation
import M3U8Kit2
import CoreTelephony
import AFNetworking
import GoogleCast
import AVKit


class LivePlayerViewController: UIViewController,UIActionSheetDelegate,AVPictureInPictureControllerDelegate, GCKSessionManagerListener,
GCKRemoteMediaClientListener, GCKRequestDelegate {
    var videoItem:AVPlayerItem!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var backImg: UIButton!
    var strCatID:NSString = NSString()
    var strLiveContentID:NSString = NSString()
    @IBOutlet var soundbutton: UIButton!
    @IBOutlet var resolutionbutton: UIButton!
    var activityIndicator:UIActivityIndicatorView=UIActivityIndicatorView()
    var objWeb = AFNetworkingWebServices()
    var bHideControl:Bool = Bool()
    var catID:NSString = NSString()
    var videoPlayer:AVPlayer!
    var lblEnd:UILabel = UILabel()
    var avLayer:AVPlayerLayer!
    var timer:Timer!
    var bEnlarge:Bool = Bool()
    var isseekplayed:Bool = Bool()
    var playbackSlider:UISlider!
    var lblLeft:UILabel = UILabel()
    var tempView:UIView!
    var expandBtn:UIButton = UIButton()
    var bFirstTime:Bool = Bool()
    var enlargeBtn:UIButton = UIButton()
    var enlargeBtnLayer:UIButton = UIButton()
    var golivebutton:UIButton = UIButton()
    var playerTime:Int!
    var livePlayerUrl:URL!
    var Secure_url = String()
    var videoresoulationtypearray:NSMutableArray=NSMutableArray()
    var videoresoulationurlarray:NSMutableArray=NSMutableArray()
    
    
    
    
    
    
    
    ///////////Google CAST
    
    
    @IBOutlet var castButton: GCKUICastButton!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.livePlayerUrl = URL(string: "http://150.242.73.243:1935/veqtamulcdn/test123/playlist.m3u8?DVR")
        isseekplayed = true
        print(strLiveContentID)
 
        LoginCredentials.Videoid = strLiveContentID as String
        playerTime = 0
        LoginCredentials.Livebuffertime = 0
        self.startloader()
        LoginCredentials.PlayType = "LIVE"
        Common.startlivebuffertime()
        if(Common.isuserlogin())
        {
            getUsersession()
        }
        
        if(Secure_url == "1")
        {
            // livePlayerUrl = Common.genrateOauthkeykeyforplayerurl(key: <#T##String#>, url: <#T##String#>)
        }
        self.playvideo(videoURL: livePlayerUrl)
        
        NotificationCenter.default.addObserver(self,selector: #selector(getForgotResponse),name: NSNotification.Name(rawValue: "getForgotResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(Sessionexpireback),name: NSNotification.Name(rawValue: "SESSIONINACTIVE"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(poptologout),name: NSNotification.Name(rawValue: "poptologout"),object: nil)
        
        let path:String = self.livePlayerUrl.absoluteString
        print(path)
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.parseallsteme(url: path)
            }
        }
    }
    /* func backLiveVideo()
     {
     if self.timer != nil
     {
     self.timer.invalidate()
     self.timer  = nil
     }
     avLayer.removeFromSuperlayer()
     videoPlayer.pause()
     //playerControllerDetail.view.removeFromSuperview()
     _ = navigationController?.popViewController(animated: true)
     }*/
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
        
        //////GOOGLE CAST
        print("viewWillAppear; mediaInfo is \(String(describing: self.mediaInfo)), mode is \(self.playbackMode)")
        appDelegate?.isCastControlBarsEnabled = true
        
        // but now have a session, then switch to remote playback mode.
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode != .remote) {
            self.switchToRemotePlayback()
        } else if (self.sessionManager.currentSession == nil) && (self.playbackMode != .local) {
            self.switchToLocalPlayback()
        }
        self.sessionManager.add(self)
        
    }
    
    
    func poptologout()
    {
        self.navigationController?.popToRootViewController(animated: true)
        
        
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote) {
            self.sessionManager.currentSession?.endAndStopCasting(true)
        }
        UserDefaults.standard.set("", forKey: "sessionID")
        UserDefaults.standard.set(nil, forKey: "loginData")
        UserDefaults.standard.set(nil, forKey: "UserID")
        UserDefaults.standard.set("slider", forKey: "screenFrom")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginScreen"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        Common.DeActivateUsersession()
        
        
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
    
    
    @IBAction func taptocast(_ sender: Any)
    {
        
        if(videoresoulationurlarray.count<1)
        {
            return
        }
        loadMediaList()
        
    }
    
    
    func resumeLive() {
        
        self.playvideo(videoURL: livePlayerUrl)
    }
    
    
    
    
    func disableallactivityaftercasting()
    {
        
        resolutionbutton.isUserInteractionEnabled = false
        soundbutton.isUserInteractionEnabled = false
        expandBtn.isUserInteractionEnabled = false
        playbackSlider.isUserInteractionEnabled = false
        self.videoPlayer.pause()
        
        
    }
    
    
    func enableallactivityaftercasting()
    {
        resolutionbutton.isUserInteractionEnabled = true
        soundbutton.isUserInteractionEnabled = true
        expandBtn.isUserInteractionEnabled = true
        playbackSlider.isUserInteractionEnabled = true
    }
    
    
    func loadMediaList()
    {
        // Look up the media list URL.
        
        
        let metadata = GCKMediaMetadata()
        print(videoresoulationurlarray.object(at: videoresoulationurlarray.count-1) as! String)
        metadata.addImage(GCKImage(url: livePlayerUrl, width: 480, height: 360))
        
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
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = mediaInfo
            builder.autoplay = true
            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build
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
    
    
    
    
    func loadMediaList1()
    {
        // Look up the media list URL.
        if(videoresoulationurlarray.count<1)
        {
            return
        }
        
        let metadata = GCKMediaMetadata()
        print(videoresoulationurlarray.object(at: videoresoulationurlarray.count-1) as! String)
        metadata.addImage(GCKImage(url: livePlayerUrl, width: 480, height: 360))
        
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
    
    
    
    func switchToRemotePlayback() {
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
        self.disableallactivityaftercasting()
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        print("MediaViewController: sessionManager didResumeSession \(session)")
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        
        
        print("session ended with error: \(String(describing: error))")
        let message = "The Casting session has ended.\n\(String(describing: error))"
        if let window = appDelegate?.window {
            Toast.displayMessage(message, for: 3, in: window)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.resumeLive()
        self.enableallactivityaftercasting()
        self.switchToLocalPlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        if let error = error {
            self.resumeLive()
            self.enableallactivityaftercasting()
            self.showAlert(withTitle: "Failed to start a session", message: error.localizedDescription)
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
    
    
    
    
    func Sessionexpireback() {
        
        
        
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote) {
            self.sessionManager.currentSession?.endAndStopCasting(true)
        }
        
        
        
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        avLayer.removeFromSuperlayer()
        videoPlayer.pause()
        //playerControllerDetail.view.removeFromSuperview()
        _ = navigationController?.popViewController(animated: true)
        
        Common.callheartBeatapi()
        Common.stoplivebuffertime()
        Common.DeActivateUsersession()
        
    }
    
    
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        avLayer.removeFromSuperlayer()
        videoPlayer.pause()
        //playerControllerDetail.view.removeFromSuperview()
        _ = navigationController?.popViewController(animated: true)
        
        Common.callheartBeatapi()
        Common.stoplivebuffertime()
        Common.DeActivateUsersession()
        
    }
    
    
    
    
    
    
    func getUsersession()
    {
        
        let userid = UserDefaults.standard.value(forKey: "loginData") as! String
        
        let parameters = ["customer_id":userid,"device_type":"ios"]
        
        
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
                    
                }
                else
                {   if self.videoPlayer != nil
                {
                    self.videoPlayer.pause()
                    }
                    self.disableappsessionalert()
                }
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
        
        
        
    }
    
    
    
    
    func disableappsessionalert()
    {
        if(Common.isuserlogin())
        {
            let alert = UIAlertController(title: "", message: "This account is playing a video on another device.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Watch it here", style: UIAlertActionStyle.default, handler: { (action) in
                Common.ActivateUsersession()
                self.videoPlayer.play()
            }))
            
            alert.addAction(UIAlertAction(title: "Watch on other device", style: UIAlertActionStyle.default, handler: { (action) in
                
                self.contantdisablebackaction()
            }))
            
            
            if(!LoginCredentials.Issociallogin)
            {
                
                alert.addAction(UIAlertAction(title: "Change password", style: UIAlertActionStyle.default, handler: { (action) in
                    self.forgotpasswordapi()
                    
                }))
            }
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func forgotpasswordapi()
    {
        self.startloader()
        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! NSData
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! NSDictionary
        let email = decodedTeams.object(forKey: "email") as? String
        let json = ["email":email! as String,"device":"ios","device_unique_id":UserDefaults.standard.value(forKey: "UUID") as! String]
        print("json >>",json)
        var url = String(format: "%@%@", LoginCredentials.Forgotapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
        
        objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getForgotResponse" )
    }
    
    @objc func getForgotResponse(notification: NSNotification)
    {
        self.stoploader()
        var responseDict:NSDictionary=NSDictionary()
        
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictResponse=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        
        let resultCode = dictResponse.object(forKey: "code") as! Int
        if resultCode == 1
        {
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
    
    
    
    
    func rotateddd()
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            bEnlarge = true
            backBtn.isHidden = true
            backImg.isHidden = true
            print("Landscape",self.view.frame.size.width)
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            self.avLayer.frame = rect
            let rectPlay = CGRect(x:39, y:self.view.frame.size.height-30, width:self.view.frame.size.width-120, height:25)
            self.playbackSlider.frame = rectPlay
            let rectLeft = CGRect(origin: CGPoint(x: 5,y :self.view.frame.size.height-23), size: CGSize(width: 35, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: self.view.frame.size.width-65,y :self.view.frame.size.height-23), size: CGSize(width: 30, height: 10))
            lblEnd.frame = rectRight
            golivebutton.frame = rectRight
            expandBtn.isHidden = true
            
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height-34), size: CGSize(width: 30, height: 30))
            enlargeBtn.frame = rectEnlarge
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-60,y :self.view.frame.size.height-64), size: CGSize(width: 90, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            
            let rectResulation = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :10), size: CGSize(width: 40, height: 40))
            //expandPlayer
            self.resolutionbutton.frame = rectResulation
            
            let rectSound = CGRect(origin: CGPoint(x: self.view.frame.size.width-80,y :16), size: CGSize(width: 22, height: 22))
            //sound
            self.soundbutton.frame = rectSound
            
            
            ////////
            let rectcast = CGRect(origin: CGPoint(x: self.view.frame.size.width-110,y :16), size: CGSize(width: 22, height: 22))
            self.castButton.frame = rectcast
            
            
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            bEnlarge = false
            print("Portrait")
            backBtn.isHidden = false
            backImg.isHidden = false
            let rect = CGRect(origin: CGPoint(x: 0,y :(self.view.frame.size.height/2) - 100), size: CGSize(width: self.view.frame.size.width, height: 200))
            self.avLayer.frame = rect
            
            self.tempView.frame = CGRect(x:0, y:(self.view.frame.size.height/2) - 100, width:self.view.frame.size.width+10, height:200)
            
            let rectPlay = CGRect(x:39, y:(self.view.frame.size.height/2)+67, width:self.view.frame.size.width-100, height:25)
            self.playbackSlider.frame = rectPlay
            
            
            let rectLeft = CGRect(origin: CGPoint(x: 5,y :175), size: CGSize(width: 35, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: self.tempView.frame.size.width-65,y :175), size: CGSize(width: 30, height: 10))
            lblEnd.frame = rectRight
            golivebutton.frame = rectRight
            
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-20,y :171), size: CGSize(width: 20, height: 20))
            enlargeBtn.frame = rectEnlarge
            
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            
            let rectResulation = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height/2-83), size: CGSize(width: 40, height: 40))
            //expandPlayer
            self.resolutionbutton.frame = rectResulation
            
            let rectSound = CGRect(origin: CGPoint(x: self.view.frame.size.width-80,y :self.view.frame.size.height/2-75), size: CGSize(width: 22, height: 22))
            //expandPlayer
            self.soundbutton.frame = rectSound
            
            
            let rectcast = CGRect(origin: CGPoint(x: self.view.frame.size.width-110,y :self.view.frame.size.height/2-75), size: CGSize(width: 22, height: 22))
            self.castButton.frame = rectcast
            
            
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func playvideo(videoURL:URL)
    {
        //let videoURL = URL(string:url)
        
        DispatchQueue.main.async { () -> Void in
            let rect = CGRect(origin: CGPoint(x: 0,y :(self.view.frame.size.height/2) - 100), size: CGSize(width: self.view.frame.size.width, height: 200))
            let playerItem:AVPlayerItem = AVPlayerItem(url: videoURL)
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
            do
            {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
            }
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.startplayingnotification), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: self.videoPlayer.currentItem)
            self.view.layer.addSublayer(self.avLayer)
            self.videoPlayer.play()
            
            // self.videoPlayer.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
            if (self.tempView != nil)
            {
                self.tempView.removeFromSuperview()
                self.tempView = nil
            }
            self.tempView = UIView(frame:CGRect(x:0, y:(self.view.frame.size.height/2) - 100, width:self.view.frame.size.width+10, height:200))
            self.tempView.backgroundColor=UIColor.clear
            self.view.addSubview(self.tempView)
            
            if self.playbackSlider != nil
            {
                self.playbackSlider.removeFromSuperview()
            }
            self.playbackSlider = UISlider(frame:CGRect(x:39, y:(self.view.frame.size.height/2)+67, width:self.view.frame.size.width-100, height:25))
            let leftTrackImage = UIImage(named: "sliderThumb")
            let minImage = UIImage(named: "lineRed")
            let maxImage = UIImage(named: "lineGray")
            self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
            self.playbackSlider.minimumValue = 0
            // playbackSlider.maximumValue = 100
            self.playbackSlider.setValue(0, animated: true)
            self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
            self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
            
            self.playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
            
            // let duration : CMTime = playerItem.asset.duration
            //   let seconds : Float64 = CMTimeGetSeconds(duration)
            // print("seconds >>>",seconds)
            //playerViewController.player = player
            //   let endInterval = NSDate(timeIntervalSince1970:seconds)
            //   let dateFormatter = DateFormatter()
            //  dateFormatter.timeZone = TimeZone.ReferenceType.local
            //  dateFormatter.dateFormat = "HH:mm:ss"
            //  let dateTimeFromPublishedString = dateFormatter.string(from: endInterval as Date)
            //   print("dateTimeFromPublishedString >>",dateTimeFromPublishedString)
            //            if seconds != seconds
            //            {
            self.playbackSlider.maximumValue = Float(0.0)
            //            }
            //            else
            //            {
            self.playbackSlider.maximumValue = Float(100000)
            //}
            
            self.playbackSlider.isContinuous = true
            self.playbackSlider.tintColor = UIColor.green
            
            if (self.timer != nil)
            {
                self.timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            //Swift 2.2 selector syntax
            //self.playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
            self.view.addSubview(self.playbackSlider)
            
            
            self.view.bringSubview(toFront: self.tempView)
            self.view.bringSubview(toFront: self.playbackSlider)
            //duration
            let rectLeft = CGRect(origin: CGPoint(x: 5,y :175), size: CGSize(width: 35, height: 10))
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
            //  let timeDuration = Float(seconds)
            //singleTapped
            //            let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped))
            //            tap.numberOfTapsRequired = 2
            //            self.tempView.addGestureRecognizer(tap)
            //
            //            let singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
            //            singletap.numberOfTapsRequired = 1
            //            self.tempView.addGestureRecognizer(singletap)
            
            
            //   print("timeDuration >>",timeDuration)
            let singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
            singletap.numberOfTapsRequired = 1
            self.tempView.addGestureRecognizer(singletap)
            
            //            let (hr,  minf) = modf (timeDuration / 3600)
            //            let (min, secf) = modf (60 * minf)
            //            let second:Float =  60 * secf
            //            let hoursString = String(hr)
            //            let minutesString = String(min)
            //            let secondString = String(second)
            //   let timeEnd = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            //   print("timeEnd >>>>>",timeEnd,hoursString,minutesString,secondString)
            
            let rectRight = CGRect(origin: CGPoint(x: self.tempView.frame.size.width-65,y :175), size: CGSize(width: 30, height: 10))
            if self.lblEnd != nil
            {
                self.lblEnd.removeFromSuperview()
            }
            self.lblEnd.backgroundColor = UIColor.clear
            self.lblEnd.font = UIFont.systemFont(ofSize: 8)
            self.lblEnd.text = "Live"//NSString(format: "%.f", playbackSlider.maximumValue) as String
            self.lblEnd.frame = rectRight
            self.golivebutton.frame = rectRight
            self.playbackSlider.addTarget(self, action: #selector(self.goliveagain), for: .valueChanged)
            self.lblEnd.textColor = UIColor.red
            self.tempView.addSubview(self.lblEnd)
            self.tempView.addSubview(self.golivebutton)
            
            if self.expandBtn != nil
            {
                self.expandBtn.removeFromSuperview()
            }
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :80), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore//CGRectMake(viewForHeader.frame.size.width-70, 5, 60, 20)
            //  self.expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
            let image = UIImage(named:"")
            self.expandBtn.setImage(image, for: .normal)
            
            if self.enlargeBtn != nil
            {
                self.enlargeBtn.removeFromSuperview()
            }
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-20,y :171), size: CGSize(width: 20, height: 20))
            //expandPlayer
            let expandImage = UIImage(named: "expandPlayer")
            self.enlargeBtn.setImage(expandImage, for: .normal)
            self.enlargeBtn.frame = rectEnlarge//CGRectMake(viewForHeader.frame.size.width-70, 5, 60, 20)
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
            
            let rectResulation = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height/2-83), size: CGSize(width: 40, height: 40))
            //expandPlayer
            self.resolutionbutton.frame = rectResulation
            
            let rectSound = CGRect(origin: CGPoint(x: self.view.frame.size.width-80,y :self.view.frame.size.height/2-75), size: CGSize(width: 22, height: 22))
            //expandPlayer
            self.soundbutton.frame = rectSound
            
            let rectcast = CGRect(origin: CGPoint(x: self.view.frame.size.width-110,y :self.view.frame.size.height/2-75), size: CGSize(width: 22, height: 22))
            //expandPlayer
            self.castButton.frame = rectcast
            
            
            
            self.tempView.addSubview(self.enlargeBtnLayer)
            self.tempView.bringSubview(toFront: self.enlargeBtnLayer)
            self.view.bringSubview(toFront: self.resolutionbutton)
            self.view.bringSubview(toFront: self.soundbutton)
            self.view.bringSubview(toFront: self.castButton)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.userViewTime =   appDelegate.userViewTime + self.playerTime
            self.playerTime = 0
            UserDefaults.standard.set(appDelegate.userViewTime, forKey: "userCurrentPlay")
            print("appDelegate.userViewTime ",UserDefaults.standard.value(forKey: "userCurrentPlay") )
            
            //
            self.bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            self.soundbutton.isHidden = true
            self.castButton.isHidden = true
            self.resolutionbutton.isHidden = true
            self.rotateddd()
        }
        
    }
    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
        print("now")
        if self.videoPlayer.currentItem?.status == AVPlayerItemStatus.readyToPlay {
            print("ready")
        }
    }
    /*func observeValue(forKeyPath keyPath: String, ofObject object: Any, change: [AnyHashable: Any], context: UnsafeMutableRawPointer) {
     if object == player && (keyPath == "status") {
     if player.status == .readyToPlay {
     print(<#T##items: Any...##Any#>)
     }
     else if player.status == .failed {
     // something went wrong. player.error should contain some information
     }
     }
     }*/
    func singleTapped() {
        // do something cool here
        print("single Tapped")
        
        if bHideControl == true
        {
            bHideControl = false
            self.playbackSlider.isHidden = false
            self.lblLeft.isHidden = false
            self.lblEnd.isHidden = false
            self.enlargeBtn.isHidden = false
            self.enlargeBtnLayer.isHidden = false
            self.soundbutton.isHidden = false
            self.castButton.isHidden = false
            resolutionbutton.isHidden = false
        }
        else
        {
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            self.soundbutton.isHidden = true
            self.castButton.isHidden = true
            resolutionbutton.isHidden = true
        }
    }
    func removeLoaderAfter()
    {
        self.stoploader()
    }
    
    func goliveagain()
    {
        // self.goliveagain()
        // self.viewDidLoad()
    }
    
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        isseekplayed = false
        let seconds : Int64 = Int64(playbackSlider.value)
        print(seconds)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        if self.videoPlayer!.rate == 0
        {
            self.videoPlayer?.play()
        }
        
        
    }
    
    
    
    
    func startplayingnotification(note: NSNotification)
    {
        print("note >>>",note.object)
        Common.ActivateUsersession()
        self.perform(#selector(removeLoaderAfter), with: nil, afterDelay: 10.0)
        Common.stoplivebuffertime()
        //        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        //        DispatchQueue.main.asyncAfter(deadline: when) {
        //
        //            //self.removecontroleronvideofter3sec()
        //        }
        // Your code with delay
    }
    func parseallsteme(url:String)
    {
        print(url)
        videoresoulationtypearray.removeAllObjects()
        videoresoulationurlarray.removeAllObjects()
        let resolutionlist = try! M3U8PlaylistModel.init(url:url).masterPlaylist.allStreamURLs() as NSArray
        let count = (resolutionlist.count) as Int
        for i in 0..<count {
            let name = resolutionlist.object(at: i) as! String
            videoresoulationurlarray.add(name)
            // let fullNameArr = name.components(separatedBy: "_")
            // let name1 = fullNameArr[1] as String
            // let fullNameArr2 = name1.components(separatedBy: ".")
            // let name2 = fullNameArr2[0] as String
            // videoresoulationtypearray.add(name2)
        }
        let xStreamList = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList
        let count1 = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList.count
        for i in 0..<count1 {
            
            let str = (xStreamList?.xStreamInf(at: i).resolution.height)! as Float
            let str1 = "\(str.cleanValue)\("P")"
            videoresoulationtypearray.add(str1)
            
        }
        videoresoulationtypearray.add("Auto")
        videoresoulationurlarray.add(url)
        videoresoulationtypearray =  NSMutableArray(array:videoresoulationtypearray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        videoresoulationurlarray =  NSMutableArray(array:videoresoulationurlarray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        
        
        
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote) {
            //self.switchToRemotePlayback()
            if(self.videoPlayer == nil)
            {
            }
            else
            {
                self.disableallactivityaftercasting()
            }
            self.loadMediaList1()
        }
        
        
    }
    
    func downloadSheet()
    {
        
        let orderedSet = NSOrderedSet(object: videoresoulationtypearray)
        print(orderedSet.array)
        
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
            
            actionSheet.addButton(withTitle: videoresoulationtypearray.object(at: i) as? String)
        }
        actionSheet.show(in: view)
        
        
    }
    func startloader()
    {
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    func stoploader()
    {
        activityIndicator.removeFromSuperview()
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print(buttonIndex)
        if buttonIndex>0 {
            isseekplayed = true
            let url = URL(string: videoresoulationurlarray.object(at: buttonIndex-1) as! String)
            self.playvideo(videoURL:url!)
 
        }
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
        print("appDelegate.userViewTime ",UserDefaults.standard.value(forKey: "userCurrentPlay") )
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            //showSubscribe
            self.performSegue(withIdentifier: "subscribeLivePush", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "subscribeLivePush", sender: self)
            
        }
    }
    func enlargeBtnAction()
    {
        // present(self.playerControllerDetail, animated: true, completion: nil)
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
        if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
        {
            let currentItem:AVPlayerItem = videoPlayer.currentItem!
            let duration:CMTime = currentItem.duration
            let videoDUration:Float = Float(CMTimeGetSeconds(duration))
            let currentTime:Float = Float(CMTimeGetSeconds(videoPlayer.currentTime()))
            print(currentTime)
            if(isseekplayed)
            {
                playbackSlider.maximumValue = currentTime
                self.playbackSlider.value = currentTime
            }
            else
            {
                self.playbackSlider.value = currentTime
                
            }
            
            
            LoginCredentials.VideoPlayingtime = Int(currentTime)
            print("\("Live PLaying Time=>")\(LoginCredentials.VideoPlayingtime)")
            
            playerTime = Int(currentTime)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if UserDefaults.standard.value(forKey: "userCurrentPlay") != nil
            {
                ////////////////start new code////////////////////
                if(Common.isuserlogin())
                {
                    if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
                    {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        print(appDelegate.subscribedItemArrays)
                        
                        if(appDelegate.subscribedItemArrays.count > 0)
                        {
                            let pkg_id = Common.nullToNil(value: ((appDelegate.subscribedItemArrays.object(at: 0) as! NSDictionary).value(forKey: "package_id") as AnyObject)) as! String
                            
                            if pkg_id == ""
                            {
                                if((UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) == "free")
                                {
                                    
                                    
                                    
                                    
                                    
                                }
                                else
                                {
                                    self.redirectTosubscribe()
                                    return
                                }
                                
                            }
                        }
                        else
                        {
                            self.redirectTosubscribe()
                            return
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
                ///////////////end new code///////////////////
                
                
                
                
                
                let time = UserDefaults.standard.value(forKey: "userCurrentPlay") as! Int
                let countTime = time + playerTime
                // print("countTime>>>>>",countTime)
                if countTime == Constants.SkipDuration || countTime > Constants.SkipDuration
                {
                    print("User need to redirect>>>>",time)
                    
                    if (UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) != nil
                    {
                        let subMode = UserDefaults.standard.value(forKey: "susubscription_mode") as! String
                        //let value = (subMode == nil || subMode is NSNull) ? nil : (subMode )
                        if subMode == "free" || subMode == ""
                        {
                            print("free subscribe")
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
                                //  self.playerControllerDetail.dismiss(animated: true, completion: nil)
                                self.redirectTosubscribe()
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
                                if self.timer != nil
                                {
                                    self.timer.invalidate()
                                    self.timer  = nil
                                }
                                //  self.playerControllerDetail.dismiss(animated: true, completion: nil)
                                self.redirectTosubscribe()
                            }
                        }
                        else
                        {
                            if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                            {
                                if appDelegate.subscribedItemArrays.count > 0
                                {
                                    
                                    let pkg_id = Common.nullToNil(value: ((appDelegate.subscribedItemArrays.object(at: 0) as! NSDictionary).value(forKey: "package_id") as AnyObject)) as! String
                                    
                                    if pkg_id == ""
                                    {
                                        if((UserDefaults.standard.value(forKey: "susubscription_mode") as? NSString) == "free")
                                        {
                                            
                                            
                                            
                                            
                                            
                                        }
                                        else
                                        {
                                            self.redirectTosubscribe()
                                            return
                                        }
                                        
                                    }
                                    
                                }
                                else
                                {
                                    if self.timer != nil
                                    {
                                        self.timer.invalidate()
                                        self.timer  = nil
                                    }
                                    //  self.playerControllerDetail.dismiss(animated: true, completion: nil)
                                    self.redirectTosubscribe()
                                }
                            }
                            else
                            {
                                if self.timer != nil
                                {
                                    self.timer.invalidate()
                                    self.timer  = nil
                                }
                                //  self.playerControllerDetail.dismiss(animated: true, completion: nil)
                                self.redirectTosubscribe()
                            }
                        }
                    }
                    else
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
                            self.redirectTosubscribe()
                        }
                    }
                }
            }
            
            let (hr,  minf) = modf (currentTime / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            
            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            self.lblLeft.text = time
        }
        
    }
    
    @IBAction func taptomute(_ sender: Any) {
        if ((sender as AnyObject).currentImage?.isEqual(UIImage(named: "SoundUnmute")))! {
            //do something here
            self.videoPlayer.isMuted = true
            (sender as AnyObject).setImage(UIImage.init(named: "Soundmute"), for: .normal)
        }
        else
        {
            self.videoPlayer.isMuted = false
            (sender as AnyObject).setImage(UIImage.init(named: "SoundUnmute"), for: .normal)
        }
    }
    
    @IBAction func taptoresolution(_ sender: Any) {
        self.downloadSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer  = nil
        }
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            if UserDefaults.standard.value(forKey: "loginData") as? String == ""
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
            }
            else
            {
                UserDefaults.standard.set("", forKey: "playerSession")
            }
            
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutRemove"), object: nil)
        }
        AppUtility.lockOrientation([.portrait])
        // NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "backLiveVideo"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: nil)
    }
    
}
extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
