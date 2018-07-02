//
//  LoginViewController.swift
//  VEQTA
//
//  Created by SSCyberlinks on 13/01/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreTelephony
import AFNetworking
class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate,UITextFieldDelegate,RazorpayPaymentCompletionProtocolWithData
{
    
    var isPaywithpaytm = Bool()
    private var razorpay : Razorpay!
    var signature_id = String()
    var Razorpay_id = String()
    var IAPtrans_id = String()
    var successPayId:NSString = NSString()
    var successFailedStr:NSString = NSString()
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()
   // var params : PUMRequestParams = PUMRequestParams.shared()
    var utils : Utils = Utils()
    var orderResponse:NSDictionary=NSDictionary()
    var paymentResponse:NSDictionary=NSDictionary()
    @IBOutlet var usernameTxtFld: UITextField!
    @IBOutlet var pwdTxtFld: UITextField!
    @IBOutlet var btnGoogleSign: UIButton!
    var idStrs:NSString = NSString()
    var strType:NSString = NSString()
    var strRedirect:NSString = NSString()
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var btnFaceBookLogIn: FBSDKLoginButton!
    var objWebService = AFNetworkingWebServices()
    var objLoader : LoaderView = LoaderView()
    @IBOutlet var btn_Skip: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation([.portrait])
        self.getloginpram()
       // self.frostedViewController.panGestureEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    func getloginpram()
    {
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strResolution=String(format: "%.f*%.f", self.view.frame.size.width, self.view.frame.size.height)
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        
        
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname =  (carrier?.carrierName)! as String
        }
        var Pushtoken  = String()
        
        if(!Common.isNotNull(object: UserDefaults.standard.value(forKey: "tokenID") as AnyObject?))
        {
            Pushtoken = ""
        }
        else
        {
            Pushtoken = UserDefaults.standard.value(forKey: "tokenID") as! String
        }
        dictionaryOtherDetail = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        devicedetailss = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "IOS",
            "device_unique_id" : uuid as String,//token! as! String,
            "push_device_token" :  Pushtoken
        ]
        print(dictionaryOtherDetail)
        print(devicedetailss)
        
        
        
    }
    
    
    //loginUpdatePush
    @IBAction func slideMenu(_ sender: Any)
    {
       self.performSegue(withIdentifier: "showLanding", sender: self)
        //_ = navigationController?.popToRootViewController(animated: true)
      
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
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        if self.frostedViewController != nil {
//            
//        }
        UserDefaults.standard.setValue(nil, forKey: "loginData")
       // UserDefaults.standard.set("", forKey: "loginData")
       // UserDefaults.standard.value(forKey: "loginData")
       
       // self.frostedViewController.panGestureEnabled = false
       // let arrayOfVCs = navigationController!.viewControllers as Array
      //  print("view ?????>>>>",arrayOfVCs)
    
        
        self.configureFacebook()
      
        let btnImage = UIImage(named: "fb") as UIImage?
        for subView in btnFaceBookLogIn.subviews
        {
            subView.removeFromSuperview()
        }
        btnFaceBookLogIn.setBackgroundImage(btnImage, for: UIControlState.normal)
        btnFaceBookLogIn.setBackgroundImage(btnImage, for: UIControlState.application)
        btnFaceBookLogIn.setBackgroundImage(btnImage, for: UIControlState())
        btnFaceBookLogIn.setBackgroundImage(btnImage, for: UIControlState.highlighted)
        btnFaceBookLogIn.setBackgroundImage(btnImage, for: UIControlState.reserved)
        btnFaceBookLogIn.setBackgroundImage(btnImage, for: UIControlState.selected)
        // btnFaceBookLogIn.setTitle("", for: UIControlState.normal)
        btnFaceBookLogIn.setImage(nil, for: UIControlState.normal)
        btnFaceBookLogIn.setImage(nil, for: UIControlState.application)
        btnFaceBookLogIn.setImage(nil, for: UIControlState())
        btnFaceBookLogIn.setImage(nil, for: UIControlState.highlighted)
        btnFaceBookLogIn.setImage(nil, for: UIControlState.reserved)
        btnFaceBookLogIn.setImage(nil, for: UIControlState.selected)
        btnFaceBookLogIn.backgroundColor = UIColor.clear
        
        btnFaceBookLogIn.translatesAutoresizingMaskIntoConstraints = true
        btnFaceBookLogIn.frame = CGRect(x:(self.view.frame.size.width/2) - 63, y:416, width:53, height:53)
        btnGoogleSign.frame = CGRect(x:(self.view.frame.size.width/2) + 10, y:416, width:53, height:53)
        signInBtn.layer.cornerRadius=20
        btn_Skip.layer.cornerRadius=5
    }
    
    @IBAction func btn_Skip_Action(_ sender: Any)
    {
        strType = "skip"
//        DispatchQueue.main.async { () -> Void in
//            //self.performSegue(withIdentifier: "showLanding", sender: self)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
//        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        NotificationCenter.default.addObserver(self,selector: #selector(get_Login_Response),name: NSNotification.Name(rawValue: "getLoginResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.get_FBLogin_Response),name: NSNotification.Name(rawValue: "getFBLoginResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getSubscriptionLoginResponse),name: NSNotification.Name(rawValue: "getSubscriptionLoginResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getPaymentLoginResponse),name: NSNotification.Name(rawValue: "getPaymentLoginResponse"),object: nil)
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        
        
        
        //UserID
        
//        print("login data>>>",UserDefaults.standard.value(forKey: "loginData"))
//        if (UserDefaults.standard.value(forKey: "loginData") as? NSString) != nil {
//            idStrs = (UserDefaults.standard.value(forKey: "loginData") as? NSString)!
//            if idStrs.length>0
//            {
//                //                print("Length>>>")
//                //                //self.performSegueWithIdentifier("showSlideMenu", sender: self)
//                //                // [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//                //
//                //self.view.performSelector(#selector(redirctToLogin), withObject: nil, afterDelay: 1.0)
//                //  self.performSegue(withIdentifier: "showLanding", sender: self)
//                // print("call Length>>>")
//                // dispatch_async(dispatch_get_main_queue()) {
//                DispatchQueue.main.async { () -> Void in
//                    self.performSegue(withIdentifier: "showLanding", sender: self)
//                }
//                //}
//                //self.performSegueWithIdentifier("showSlideMenu", sender: self)
//            }
//            //            else
//            //            {
//            //                print("zero>>>")
//            //            }
//        }
    }
    //    override var prefersStatusBarHidden : Bool {
    //        return true
    //    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpShow", sender: self)
    }
    //MARK:-Google SignIn
    func updateButtons()
    {
        let autenticated:Bool!
        
        autenticated = GIDSignIn.sharedInstance().currentUser.authentication != nil
        // self.btnGoogleSign.enabled = !autenticated
        if autenticated ?? true
        {
           
            print("Update Unit and dialog")
        }
        else
        {
            // self.btnGoogleSign.alpha = 1.0;
            //self.signOutButton.alpha = self.disconnectButton.alpha = 0.5;
        }
    }
    
    
    @IBAction func googleBtnAction(_ sender:UIButton)
    {
        print("ghvjdbdsfkdioadnkad")
        LoginCredentials.Issociallogin = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
        print("Dispatch")
       // print(error.localizedDescription)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            print("user>>>\(user)")
            let idToken = user.authentication.idToken
          //  print("idToken>>>\(idToken)")
           // print("user>>>>\(user.userID)")
          //  print("user>>>>\(user.authentication.idToken)")
           // print("user>>>>\(user.profile.name)")
           // print("user>>>>\(user.profile.email)")
            self.updateButtons()
            let userID = self.nullToNil(value: user.userID as AnyObject)
            let profileEmail = self.nullToNil(value: user.profile.email as AnyObject)
            let profileName = self.nullToNil(value: user.profile.name as AnyObject)
            let nameUser = self.nullToNil(value: user.profile.name as AnyObject)
            let googleDetail: NSDictionary = [
                "first_name":nameUser as! String,
                "last_name": "",
                "gender": "",
                "link": "",
                "locale": "",
                "name": nameUser as! String,
                "email": profileEmail as! String,
                "location": "",
                "dob": "",
                "id":userID as! String ]
            
    
    
            do
            {
 
                let strEmail: String = (user.profile.email as? String)!
                //result.valueForKey("name") as! NSString
                self.createLoader()
                var parameters = [String : Any]()
                 parameters =  ["dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                          "dd":Common.convertdictinyijasondata(data: devicedetailss),
                          "type":"social",
                          "device":"ios",
                          "social":Common.convertdictinyijasondata(data: googleDetail),
                          "provider":"google"]
                let url = String(format: "%@%@", LoginCredentials.SocialAPI,Constants.APP_SOCIAL_Token)
                let manager = AFHTTPSessionManager()
                manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                    let dict = responseObject as! NSDictionary
                     print(dict)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getFBLoginResponse"), object: dict)
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    print("POST fails with error \(error)")
                    self.removeLoader()

                })
                
                
                
                
                
//                let jsonData1 = try JSONSerialization.data(withJSONObject: parameters,options: [])
//                let new = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
//                 let defaults = UserDefaults.standard
//                 defaults.set(parameters, forKey: "getFBLoginResponse")
//                 print(url)
//                 print(new)
//                self.objWebService.postRequestAndGetResponse(urlString: url as NSString, param: parameters as NSDictionary, info: "getFBLoginResponse")
            }
            catch
            {
                print(error)
            }
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    
 
    
    func configureFacebook()
    {
        btnFaceBookLogIn.readPermissions = ["public_profile", "email", "user_friends"];
        btnFaceBookLogIn.delegate = self
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
        
    {
        
        LoginCredentials.Issociallogin = true
         if (error == nil){
            let fbloginresult : FBSDKLoginManagerLoginResult = result
            if result.isCancelled {
                return
            }
            if(fbloginresult.grantedPermissions.contains("email"))
            {
                // self.getFBUserData()
                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, email, last_name, picture.type(large)"]).start { (connection, result, error) -> Void in
                    
                    let dictResponse = result as! NSDictionary
                    print("dictResponse fb >>>",dictResponse)
                    if dictResponse.value(forKey: "email") as? String != nil
                    {
                        //loginUpdatePush
                        let firstName = self.nullToNil(value: dictResponse.value(forKey: "first_name") as AnyObject)
                        let idFB = self.nullToNil(value: dictResponse.value(forKey: "id") as AnyObject)
                         let lastName = self.nullToNil(value: dictResponse.value(forKey: "last_name") as AnyObject)
                        let fbDetail: NSDictionary = [
                            "id" : idFB as! String,
                            "email" : dictResponse.value(forKey: "email") as! String,
                            "first_name" : firstName as! String,
                            "last_name" : lastName as! String,
                            "link": "",
                            "locale": "",
                            "name": firstName as! String,
                            "location": "",
                             "dob": "",
                             "gender":""
                         ]
                        
 
                        do
                        {
                       self.createLoader()
                    let json=["dod":Common.convertdictinyijasondata(data: self.dictionaryOtherDetail),
                            "dd":Common.convertdictinyijasondata(data: self.devicedetailss),
                            "type":"social",
                            "device":"ios",
                            "social":Common.convertdictinyijasondata(data: fbDetail),
                             "provider":"facebook"]
                            
                            
         let url = String(format: "%@%@", LoginCredentials.SocialAPI,Constants.APP_SOCIAL_Token)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                                let dict = responseObject as! NSDictionary
                                print(dict)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getFBLoginResponse"), object: dict)
                            }, failure: { (task: URLSessionDataTask?, error: Error) in
                                print("POST fails with error \(error)")
                                self.removeLoader()
                                
                            })
                            
                            
                            
                            
//                            let json=["dod":otherDetailString as! String,"dd":detailString as! String,"type":"email","phone":strEmail ,"device":"ios","social":fbString as! String,"provider":"facebook"]
//                            let defaults = UserDefaults.standard
//                            defaults.set(json, forKey: "getFBLoginResponse")
//                            print("Fb Login>>>>\(json)")
//                            let url = String(format: "%@%@", LoginCredentials.SocialAPI,Constants.APP_SOCIAL_Token)
//                            self.objWebService.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info: "getFBLoginResponse")
                        }
                        catch
                        {
                            print(error)
                        }
                        
                    }
                    else
                    {
                        //loginUpdatePush
                        let fbDetail: NSDictionary = [
                            "id" : dictResponse.value(forKey: "id") as! String,
                            "email" : "",
                            "first_name" : dictResponse.value(forKey: "first_name") as! String,
                            "last_name" : dictResponse.value(forKey: "last_name") as! String
                        ]
                        let netInfo = CTTelephonyNetworkInfo()
                        let carrier = netInfo.subscriberCellularProvider
                        let strDeviceName=UIDevice.current.model
                        let strResolution=String(format: "%.f*%.f", self.view.frame.size.width, self.view.frame.size.height)
                        let systemVersion=UIDevice.current.systemVersion
                        let defaults = UserDefaults.standard
                        let token = defaults.value(forKey: "DeviceToken")
                        let uuid = UIDevice.current.identifierForVendor!.uuidString
                        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                        
                        
                        
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
                            networkname =  (carrier?.carrierName)! as String
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

                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: dictionaryOtherDetail as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                            
                            let fbData = try JSONSerialization.data(withJSONObject: fbDetail as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let fbString = NSString(data: fbData, encoding: String.Encoding.utf8.rawValue)
                            
                            let detailJson = try JSONSerialization.data(withJSONObject: devicedetailss as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let detailString = NSString(data: detailJson, encoding: String.Encoding.utf8.rawValue)
                            let strEmail: String = "" as! String
                            
                            //result.valueForKey("name") as! NSString
                            self.createLoader()
                            let json=["dod":otherDetailString as! String,"dd":detailString as! String,"type":"email","phone":"" ,"device":"ios","social":fbString as! String,"provider":"facebook"]
                            let defaults = UserDefaults.standard
                            defaults.set(json, forKey: "getFBLoginResponse")
                            print("Fb Login>>>>\(json)")
                            let url = String(format: "%%@", LoginCredentials.SocialAPI,Constants.APP_SOCIAL_Token)
                            self.objWebService.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info: "getFBLoginResponse")
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                    
                }
            }
        }
        else{
            print(error.localizedDescription)
        }
        print("sbjnklas")
        
    }
    
    
    //loginPushOtp
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    //get_FBLogin_Response
    @objc func get_FBLogin_Response(notification: NSNotification)
    {
        print(notification)
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        
        dictHome=responseDict.mutableCopy() as! NSMutableDictionary
        print("dictHome google >>",dictHome)
        
        let resultCode = dictHome.object(forKey: "code") as! Int
        if resultCode == 1
        {
            var loginDict:NSDictionary=NSDictionary()
            loginDict = dictHome.value(forKey:"result") as! NSDictionary
            let otp_mode = nullToNil(value: loginDict.object(forKey: "otp") as AnyObject)
            let strOtpMode = otp_mode as! String

            let strContact = nullToNil(value: loginDict.object(forKey: "contact_no") as AnyObject) as! String
            //if (strOtpMode == "") && (strContact.characters.count > 0)
            if (loginDict.count > 0)
            {
                print("dictHome.object(forKey:>>>> ",loginDict.object(forKey: "uid"))
                let id = loginDict.object(forKey: "id") as! NSNumber
                UserDefaults.standard.setValue(id.stringValue, forKey: "loginData")
                UserDefaults.standard.setValue(id.stringValue, forKey: "UserID")
               // UserDefaults.standard.setValue(loginDict.object(forKey: "uid"), forKey: "UserID")

                print("dictHome\(dictHome)")
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
                UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
                strType = "login"
                DispatchQueue.main.async { () -> Void in
                    UserDefaults.standard.setValue(id.stringValue, forKey: "loginData")
                    UserDefaults.standard.setValue(id.stringValue, forKey: "UserID")
                    //UserDefaults.standard.setValue(loginDict.object(forKey: "uid"), forKey: "UserID")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startHeartBeat"), object: dictHome)
                  self.performSegue(withIdentifier: "showLanding", sender: self)
 
                }
            }
            else
            {
               // let otp = loginDict.object(forKey: "otp") as! Int
                let strOtp = strOtpMode
                print("strOtp count",strOtp.characters.count)
                if strOtp != ""
                {
                    strRedirect = "facebook"
                    let uID = (loginDict.object(forKey: "id") as! NSString).doubleValue
                    let UID = Int(uID)
                    UserDefaults.standard.setValue(UID, forKey: "UID")
                    UserDefaults.standard.setValue(strOtp, forKey: "OTP")
                    self.performSegue(withIdentifier: "loginUpdatePush", sender: self)
                }
                else
                {
                    print("dictHome.object(forKey:>>>> ",loginDict.object(forKey: "uid"))
                    UserDefaults.standard.setValue(loginDict.object(forKey: "id"), forKey: "loginData")
                    UserDefaults.standard.setValue(loginDict.object(forKey: "uid"), forKey: "UserID")
                    print("dictHome\(dictHome)")
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
                    UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                    strType = "login"
                    DispatchQueue.main.async { () -> Void in
                          self.performSegue(withIdentifier: "showLanding", sender: self)
         }
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Please enter registered email ID and password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func forgot_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotShow", sender: self)
    }
    @IBAction func fb_Action(_ sender: AnyObject)
    {
        
    }
    @objc func get_Login_Response(notification: NSNotification)
    {
        print(notification)
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        
        dictHome=responseDict.mutableCopy() as! NSMutableDictionary
        print("dictHome >>",dictHome)
        let resultCode = dictHome.object(forKey: "code") as! Int
        if resultCode == 1
        {
           
            usernameTxtFld.text = ""
            pwdTxtFld.text = ""
            var loginDict:NSDictionary=NSDictionary()
            loginDict = dictHome.value(forKey:"result") as! NSDictionary
          //  let strOtp = loginDict.object(forKey: "otp") as! String
//            if strOtp.characters.count > 0
//            {
//               let uID = (loginDict.object(forKey: "id") as! NSString).doubleValue
//                let UID = Int(uID)
//                UserDefaults.standard.setValue(UID, forKey: "UID")
//                UserDefaults.standard.setValue(loginDict.object(forKey: "otp"), forKey: "OTP")
//                self.performSegue(withIdentifier: "loginPushOtp", sender: self)
//            }
            if loginDict.count>0
            {
                print("dictHome.object(forKey:>>>> ",loginDict.object(forKey: "uid"))
                let newid = loginDict.object(forKey: "id") as! NSNumber
                
                UserDefaults.standard.setValue(newid.stringValue, forKey: "loginData")
                UserDefaults.standard.setValue(newid.stringValue, forKey: "UserID")
                print("dictHome\(dictHome)")
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
                UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                strType = "login"
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startHeartBeat"), object: dictHome)
                DispatchQueue.main.async { () -> Void in
                    
                    
                    self.performSegue(withIdentifier: "showLanding", sender: self)
                    
//                    if UserDefaults.standard.value(forKey: "screenFrom") as? String != nil
//                    {
//                        let lastScreen = UserDefaults.standard.value(forKey: "screenFrom") as! String
//                        if lastScreen == "subscribe"
//                        {
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            if appDelegate.paymentOfSubscribe == "free"
//                            {
//                                self.performSegue(withIdentifier: "showLanding", sender: self)
//                               
//                            }
//                            else
//                            {
//                                self.getOrderID()
//                               // self.CallPaymentmethod()
//                            }
//                            
//                        }
//                        else
//                        {
//                            self.performSegue(withIdentifier: "showLanding", sender: self)
//                        }
//                    }
//                    else
//                    {
//                        self.performSegue(withIdentifier: "showLanding", sender: self)
//                    }
                    
                }
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Please enter registered email ID and password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    @IBAction func signIn_Action(_ sender: AnyObject)
    {
        
        
        if(!Common.isValidEmail(testStr: usernameTxtFld.text!))
        {
            let alert = UIAlertController(title: "Message", message: "Please enter valid email id", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        LoginCredentials.Issociallogin = false
         let strDeviceName1=UIDevice()
        print(strDeviceName1.modelName)
        
        usernameTxtFld.resignFirstResponder()
        pwdTxtFld.resignFirstResponder()
        
        let strUserNM = usernameTxtFld.text! as String
        let strPwd = pwdTxtFld.text! as String
        if strUserNM != "" && strPwd != ""
        {
            
            do
            {
                 self.createLoader()
              
                let usernameStr = usernameTxtFld.text! as String
                let pwdStr = pwdTxtFld.text! as String
                //    print(otherDetailString,detailString)
 
                let json = ["email":usernameStr,
                              "password":pwdStr,
                              "devicedetail":Common.convertdictinyijasondata(data: devicedetailss),
                              "device_other_detail":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                              "device": "ios",
                ]
                
                 let url = String(format: "%@%@", LoginCredentials.LoginAPI,Constants.APP_SOCIAL_Token)
                let manager = AFHTTPSessionManager()
                manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getLoginResponse"), object: dict)
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    print("POST fails with error \(error)")
                    self.removeLoader()
                    
                })
                
                
              //  self.objWebService.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info: "getLoginResponse")
            }
            catch
            {
                print(error)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Please fill all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showLanding"
        {
            let vc = segue.destination as! HomeViewController
            vc.strLoginType = strType
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.strENterDetail = strType
        }
        else if segue.identifier == "loginUpdatePush"
        {
            let vc = segue.destination as! UpdatePhoneViewController
            vc.strRedirectType = strRedirect
        }
    }
    
    func getOrderID()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strPrice = (appDelegate.dictPackageInfo.object(forKey: "p_price") as? String)! as String
            let strPakageId = (appDelegate.dictPackageInfo.object(forKey: "package_id") as? String)! as String
            let strPakageName = (appDelegate.dictPackageInfo.object(forKey: "p_name") as? String)! as String
            //            let dictionaryOtherDetail: NSDictionary = [
            //                "price" : strPrice,
            //                "id" : strPakageId,
            //                "title" : strPakageName,
            //                "type" : "subs",
            //                "content_type" : "video"
            //            ]
            let myArray = [["price" : strPrice, "id" : strPakageId,"title" : strPakageName,"type" : "subs","content_type" : "video"]]
            let dictionaryOtherDetail: NSDictionary = [
                "items" : myArray
            ]
            //            let tempDict:NSMutableDictionary = NSMutableDictionary()
            //            tempDict.setObject(strPrice, forKey: "price" as NSCopying)
            //            tempDict.setObject(strPakageId, forKey: "id" as NSCopying)
            //            tempDict.setObject(strPakageName, forKey: "title" as NSCopying)
            //            tempDict.setObject("subs", forKey: "type" as NSCopying)
            //            tempDict.setObject("content_type", forKey: "video" as NSCopying)
            
            let tempDict1:NSMutableDictionary = NSMutableDictionary()
            tempDict1.setObject(myArray, forKey: "items" as NSCopying)
            print("dictionaryOtherDetail >>>",tempDict1)
            //{"items": [{ "price": "49","id": "102", "title": "Veqta Premium","type": "subs","content_type": "video"}]}
            //            var arrayVod:NSArray=NSArray()
            //            arrayVod = (dictionaryOtherDetail as AnyObject) as! NSArray
            //            let tempDict:NSMutableDictionary = NSMutableDictionary()
            //            tempDict.setObject(arrayVod, forKey: "items" as NSCopying)
            
            //   let array = Array(dictionaryOtherDetail)
            // let cartDetail: NSDictionary = ["items":array]
            // print("cartDetail>>>",tempDict)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionaryOtherDetail as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let itemString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                let strID = UserDefaults.standard.value(forKey: "loginData") as! String
                let json = ["device":"ios","total_price":strPrice,"cart":itemString as! String,"c_id":strID as String]
                print("json>>>",json)
                var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
                url = url.trimmingCharacters(in: .whitespaces)

                objWebService.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSubscriptionLoginResponse" )
            }
            catch
            {
                print("catch")
            }
            
        }
        else
        {
           
        }
    }
    @objc func getSubscriptionLoginResponse(notification: NSNotification)
    {
        // print("notification>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        orderResponse=notification.object as! NSDictionary
        UserDefaults.standard.set(orderResponse.object(forKey: "order_id"), forKey: "orderID")
        // dictResponse = responseDict.mutableCopy() as! NSMutableDictionary
        print("dictResponse >>>",orderResponse)
        //UserDefaults.standard.set("subscribe", forKey: "screenFrom")
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
           
            
            
           self.startPayment()
            
//            if(isPaywithpaytm)
//            {
//                
//               // self.PayWithpaytm()
//               let paytm = PaytmView()
//                paytm.PayWithpaytm(view: self.view, viewcontroller: self)
//              }
//            else
//            {
//             self.startPayment()
//            }
           
         }
        else
        {
           // self.redirectTologin()
        }
    }
    
    
    
    func CallPaymentmethod()
    {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Payment Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Pay With Paytm", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.getOrderID()
                self.isPaywithpaytm = true
                print("Saved")
        })
        
        let deleteAction = UIAlertAction(title: "Pay With Razorpay", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Razorpay")
                self.isPaywithpaytm = false

                self.getOrderID()
               
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
      

    
    func paymentStatus()
    {
        
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = (receiptData?.base64EncodedString(options: []))! as String
        let strID = UserDefaults.standard.value(forKey: "loginData") as! String
        let orderId =  (orderResponse.object(forKey: "order_id") as! NSNumber).stringValue
        let json = ["device":"ios","c_id":strID as String,"trans_id":IAPtrans_id,"signature":receiptString,"status":"1","order_id":orderId] as [String : Any]
        var url = String(format: "%@%@", LoginCredentials.Subscriptionpaymentv2,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)

        objWebService.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentLoginResponse" )
        
             }
   
    @objc func getPaymentLoginResponse(notification: NSNotification)
    {
        // print("notification>>>>",notification.object)
        //  var dictResponse:NSMutableDictionary=NSMutableDictionary()
        let dictPayment=notification.object as! NSDictionary
        // dictResponse = responseDict.mutableCopy() as! NSMutableDictionary
        print("dictResponse >>>",dictPayment)
        // self.performSegue(withIdentifier: "otpHome", sender: self)
        let resultCode = dictPayment.object(forKey: "code") as! Int
        if resultCode == 1
        {
           // navigationController!.popToViewController((navigationController?.viewControllers[0])!, animated: false)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
            self.performSegue(withIdentifier: "showLanding", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Payment failed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            let orderId = orderResponse.object(forKey: "order_id") as! String
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            APPDataBase.saveIapfalierdata(orderid: orderId, userid: strID, transid: IAPtrans_id)
        }
    }
    func startPayment() -> Void {
       /* let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        print("decodedTeams",decodedTeams)
        
        params.amount = UserDefaults.standard.value(forKey: "price") as! String!;
        params.environment = PUMEnvironment.production;
        params.firstname = decodedTeams.object(forKey: "first_name") as! String
        params.key = "bwBJBjb5";//"rjQUPktU";
        params.merchantid = "tfsFxAycJY";//"e5iIg1jwi8";  //Merchant merchantid
        params.logo_url = ""; //Merchant logo_url
        params.productinfo = "VEQTA";
        params.email = decodedTeams.object(forKey: "email") as! String;  //user email
        params.phone = decodedTeams.object(forKey: "contact_no") as! String; //user phone
        params.txnid = utils.getRandomString(2);  //set your correct transaction id here
        params.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php";
        params.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php";
        
        //Below parameters are optional. It is to store any information you would like to save in PayU Database regarding trasnsaction. If you do not intend to store any additional info, set below params as empty strings.
        
        params.udf1 = "";
        params.udf2 = "";
        params.udf3 = "";
        params.udf4 = "";
        params.udf5 = "";
        params.udf6 = "";
        params.udf7 = "";
        params.udf8 = "";
        params.udf9 = "";
        params.udf10 = "";
        //We strictly recommend that you calculate hash on your server end. Just so that you can quickly see demo app working, we are providing a means to do it here. Once again, this should be avoided.
        if(params.environment == PUMEnvironment.production){
            generateHashForProdAndNavigateToSDK()
        }
        else{
            calculateHashFromServer()
        }
        // assign delegate for payment callback.
        params.delegate = self;
 */
        
        
        
        
  ////////////////***********************************************///////////////////////
        
       // razorpay payment start//////
        
        
        
//        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! Data
//        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
//        print("decodedTeams",decodedTeams)
//        razorpay = Razorpay.initWithKey("rzp_live_j9cAJlPELnvxVe", andDelegateWithData: self)
//        // razorpay = Razorpay.initWithKey("rzp_test_Ztx5S8FLWXpi7m", andDelegate: self)
//        var price = UserDefaults.standard.value(forKey: "price") as! String
//        //price = "\(price as String)00"
//        print(price as String)
//        let options: [AnyHashable: Any] = ["amount": price, "currency": "INR", "description": "VEQTA Sports", "name": "Razorpay",  "prefill": ["email": decodedTeams.object(forKey: "email") as! String, "contact": decodedTeams.object(forKey: "contact_no") as! String], "theme": ["color": "#3594E2"],"order_id":orderResponse.value(forKey: "order_id") as! String]
//        
//        razorpay.open(options)
        
        ////////////////***********************************************///////////////////////
        
        // razorpay payment END//////
        
       
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        self.createLoader()
        SwiftyStoreKit.purchaseProduct(Constants.appBundleId, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                self.IAPtrans_id = purchase.transaction.transactionIdentifier!
                print(self.IAPtrans_id)
                self.paymentStatus()
                
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if case .error(let eror) = result
            {
                print(eror.code)
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
                self.removeLoader()
            }
        }
        
   
        
        
        
        
        
        
        
        
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        successFailedStr = "failed"
        let alert = UIAlertController(title: "Error", message: "Payment Failed", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      
    }
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        signature_id = response?["razorpay_payment_id"] as! String
        Razorpay_id = response?["razorpay_order_id"] as! String
        successPayId = payment_id as NSString
        successFailedStr = "success"
        let alert = UIAlertController(title: "Payment Successful", message: "Payment Successful", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.paymentStatus()
        
        
    }
//    func onPaymentSuccess(_ payment_id: String) {
//        successPayId = payment_id as NSString
//        successFailedStr = "success"
//        let alert = UIAlertController(title: "Payment Successful", message: "Payment Successful", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        self.paymentStatus()
//    }
//    
//    func onPaymentError(_ code: Int32, description str: String) {
//        successFailedStr = "failed"
//        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        self.paymentStatus()
//    }
    
    
    
    //////////paywith paytm////
    
    
    
    
    func PayWithpaytm()
    {
        
        
        let mc = PGMerchantConfiguration.default()
        var orderDict = [AnyHashable: Any]()
        orderDict["MID"] = "ITWDig79524644918314"
        orderDict["ORDER_ID"] = "TestMerchant000111008"
        orderDict["CUST_ID"] = "mohit.aggarwal@paytm.com"
        orderDict["INDUSTRY_TYPE_ID"] = "Retail"
        orderDict["CHANNEL_ID"] = "WAP"
        orderDict["TXN_AMOUNT"] = "1"
        orderDict["WEBSITE"] = "APP_STAGING"
        orderDict["CALLBACK_URL"] = "https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp"
        orderDict["CHECKSUMHASH"] = "o3ARWrsxEfuJwDhkG7/m57ZU+YpHJWNVOTqJb9kfp0fbioRG/lsn1ReNBPUr0UKMMB5Iq4e/JUVSHrbFl9g1VyCyQqcHl/jPOqNvYHVE4Ko="
        
        
        
        let order = PGOrder(params: orderDict)
        PGServerEnvironment.selectServerDialog(self.view, completionHandler: {(_ eServerTypeProduction: ServerType) -> Void in
            
            let txnController = PGTransactionViewController.init(transactionFor: order)
            //txnController.merchant = [PGMerchantConfiguration defaultConfiguration];
            txnController?.serverType = eServerTypeProduction
            txnController?.merchant = mc
            //txnController?.delegate = self
            txnController?.loggingEnabled = true
            self.show(txnController!, sender: nil)
          //  viewcontroller.show(txnController!, sender: nil)
            //self.show(txnController!)
        })
        
        
        
        
    }

    
    
    
    
    
    
    
    
    
    /*
    func generateHashForProdAndNavigateToSDK() -> Void {
        
       
        
        let txnid = params.txnid!
        let salt = "tfsFxAycJY"
        //add your salt in place of 'salt' if you want to test on live environment.
        //We suggest to calculate hash from server and not to keep the salt in app as it is a severe security vulnerability.
        let hashSequence : NSString = "\(params.key as NSString)|\(txnid as NSString)|\(params.amount as NSString)|\(params.productinfo as NSString)|\(params.firstname as NSString)|\(params.email as NSString)|||||||||||tfsFxAycJY" as NSString
        print("hashSequence >>>",hashSequence)
        let data :NSString = utils.createSHA512(hashSequence as String!) as NSString
        
        params.hashValue = data as String!;
        startPaymentFlow();
    }
    
    
    func transactinCanceledByUser() -> Void {
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Payment Cancelled ")
        }
    }
    
    func startPaymentFlow() -> Void {
        let paymentVC : PUMMainVController = PUMMainVController()
        var paymentNavController : UINavigationController;
        paymentNavController = UINavigationController(rootViewController: paymentVC);
        self.present(paymentNavController, animated: true, completion: nil)
    }
    
    func transactionCompleted(withResponse response : NSDictionary,errorDescription error:NSError) -> Void {
        self.dismiss(animated: true){
            print("success>>>",response)
            self.paymentResponse = response
            self.showAlertViewWithTitle(title: "Message", message: "congrats! Payment is Successful")
            self.paymentStatus()
        }
    }
    
    
    func transactinFailed(withResponse response : NSDictionary,errorDescription error:NSError) -> Void {
        self.dismiss(animated: true){
            print("Failed>>>",response)
            self.paymentResponse = response
            self.showAlertViewWithTitle(title: "Message", message: "Oops!!! Payment Failed")
            self.paymentStatus()
        }
    }
    
    func showAlertViewWithTitle(title : String,message:String) -> Void {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:HASH CALCULATION
    
    //hash calculation strictly recommended to be done on your server end. This is just to show the hash sequence format and oe the api call for hash should be. Encryption is SHA-512.
    func prepareHashBody()->NSString{
        print("data>>>",params.key)
        print("amount>>>",params.amount)
        print("txnid>>>",params.txnid)
        print("productinfo>>>",params.productinfo)
        print("email>>>",params.email)
        print("firstname>>>",params.firstname)
        //params.amount,params.txnid,params.productinfo,params.email,params.firstname
        return "key=\(params.key!)&amount=\(params.amount!)&txnid=\(params.txnid!)&productinfo=\(params.productinfo!)&email=\(params.email!)&firstname=\(params.firstname!)" as NSString;
    }
    
    func calculateHashFromServer(){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://test.payumoney.com/payment/op/v1/calculateHashForTest")!
        var request = URLRequest(url: url)
        request.httpBody = prepareHashBody().data(using: String.Encoding.utf8.rawValue)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                        //Implement your logic
                        print(json)
                        let status : NSNumber = json["status"] as! NSNumber
                        if(status.intValue == 0)
                        {
                            self.params.hashValue = json["result"] as! String!
                            OperationQueue.main.addOperation {
                                self.startPaymentFlow()
                            }
                        }
                        else{
                            OperationQueue.main.addOperation {
                                self.showAlertViewWithTitle(title: "Message", message: json["message"] as! String)
                            }
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }*/
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
