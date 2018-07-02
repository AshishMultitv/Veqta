//
//  SignUpViewController.swift
//  VEQTA
//
//  Created by SSCyberlinks on 13/01/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreTelephony
import AFNetworking
class SignUpViewController: UIViewController,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate,RazorpayPaymentCompletionProtocolWithData {
    private var razorpay : Razorpay!
     var isPaywithpaytm = Bool()
    var successPayId:NSString = NSString()
    var signature_id = String()
    var Razorpay_id = String()
    var IAPtrans_id = String()
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()

     var successFailedStr:NSString = NSString()
    @IBOutlet var btnSignUp: UIButton!
   // var params : PUMRequestParams = PUMRequestParams.shared()
    var utils : Utils = Utils()
    var paymentResponse:NSDictionary=NSDictionary()
    @IBOutlet var fbLoginBtn: FBSDKLoginButton!
    var strRedirect:NSString = NSString()
    @IBOutlet var googleBtn: UIButton!
    var orderResponse:NSDictionary=NSDictionary()
    @IBOutlet var phoneTxtFld: UITextField!
    @IBOutlet var lastNmTxtFld: UITextField!
    @IBOutlet var pwdTxtFld: UITextField!
    @IBOutlet var firstnameTxtFld: UITextField!
    @IBOutlet var cnfrmPwdTxtFld: UITextField!
    @IBOutlet var emailTxtFld: UITextField!
    var strSelected:NSString = NSString()
    var objLoader : LoaderView = LoaderView()
    var objWeb = AFNetworkingWebServices()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        btnSignUp.layer.cornerRadius=20
        self.frostedViewController.panGestureEnabled = false
        NotificationCenter.default.addObserver(self,selector: #selector(getSignUpResponse),name: NSNotification.Name(rawValue: "getSignUpResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getPaymentLoginResponse),name: NSNotification.Name(rawValue: "getPaymentSignUpResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getSubscriptionLoginResponse),name: NSNotification.Name(rawValue: "getSubscriptionSignUpResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.get_FBLogin_Response),name: NSNotification.Name(rawValue: "getFBSignUpResponse"),object: nil)
        self.configureFacebook()
        let btnImage = UIImage(named: "fb") as UIImage?
        for subView in fbLoginBtn.subviews
        {
            subView.removeFromSuperview()
        }
        fbLoginBtn.setBackgroundImage(btnImage, for: UIControlState.normal)
        fbLoginBtn.setBackgroundImage(btnImage, for: UIControlState.application)
        fbLoginBtn.setBackgroundImage(btnImage, for: UIControlState())
        fbLoginBtn.setBackgroundImage(btnImage, for: UIControlState.highlighted)
        fbLoginBtn.setBackgroundImage(btnImage, for: UIControlState.reserved)
        fbLoginBtn.setBackgroundImage(btnImage, for: UIControlState.selected)
        // btnFaceBookLogIn.setTitle("", for: UIControlState.normal)
        fbLoginBtn.setImage(nil, for: UIControlState.normal)
        fbLoginBtn.setImage(nil, for: UIControlState.application)
        fbLoginBtn.setImage(nil, for: UIControlState())
        fbLoginBtn.setImage(nil, for: UIControlState.highlighted)
        fbLoginBtn.setImage(nil, for: UIControlState.reserved)
        fbLoginBtn.setImage(nil, for: UIControlState.selected)
        fbLoginBtn.backgroundColor = UIColor.clear
       // fbLoginBtn.frame = CGRect(x:(self.view.frame.size.width/2) - 63, y:491, width:53, height:53)
       // googleBtn.frame = CGRect(x:(self.view.frame.size.width/2) + 10, y:491, width:53, height:53)
        fbLoginBtn.translatesAutoresizingMaskIntoConstraints = true
        // Do any additional setup after loading the view.
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
    
    func createLoader() {
        self.objLoader.frame=CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.objLoader.createLoader()
        UIApplication.shared.delegate!.window!?.addSubview(self.objLoader)
        UIApplication.shared.delegate!.window!?.bringSubview(toFront:self.objLoader)
    }
    func removeLoader() {
        self.objLoader.removeFromSuperview()
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.getloginpram()
      
        let arrayOfVCs = navigationController!.viewControllers as Array
        print("view ?????>>>>",arrayOfVCs)
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        //let str = self.firstnameTxtFld.text as String
//        // first parameter mean you will let user use again your customized orientation support. If the previous user screen is landscapeLeft, setting the second parameter to `.landscapeLeft ` will bring back to its previous landscape after disappear. This is really useful for best user experience.
//        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .landscapeLeft)
//        
//        // Thanks to you bmjohns
//    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
//    func phoneNumberValidation(value: String) -> Bool {
//        var charcter  = NSCharacterSet(charactersIn: "0123456789").inverted
//        var filtered:NSString!
//        var inputString:NSArray = value.components(separatedBy: charcter)
//        filtered = inputString.componentsJoined(by: "") as NSString!
//        return  value == filtered
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        //    print("TextField should return method called")
        textField.resignFirstResponder()
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phoneTxtFld
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        if textField == firstnameTxtFld || textField == lastNmTxtFld
        {
            let aSet = NSCharacterSet(charactersIn:"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == emailTxtFld
        {
            strSelected = "email"
        }
        if textField == firstnameTxtFld
        {
            strSelected = "firstname"
        }
        if textField == phoneTxtFld
        {
            strSelected = "phone"
        }
        if textField == lastNmTxtFld
        {
            strSelected = "lastname"
        }
        if textField == pwdTxtFld
        {
            strSelected = "password"
        }
        if textField == cnfrmPwdTxtFld
        {
            strSelected = "confirm"
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        strSelected = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func googleBtnLogin(_ sender: Any) {
        LoginCredentials.Issociallogin = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        GIDSignIn.sharedInstance().signIn()
    }
    func updateButtons()
    {
        let autenticated:Bool!
        
        autenticated = GIDSignIn.sharedInstance().currentUser.authentication != nil
        // self.btnGoogleSign.enabled = !autenticated
        
        
        if autenticated ?? true
        {
            
        } else {
            // self.btnGoogleSign.alpha = 1.0;
            //self.signOutButton.alpha = self.disconnectButton.alpha = 0.5;
        }
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
        print("Dispatch")
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
                
                
                let json=["dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                          "dd":Common.convertdictinyijasondata(data: devicedetailss),
                          "type":"social",
                          "device":"ios",
                          "social":Common.convertdictinyijasondata(data: googleDetail),
                          "provider":"google"]
                let defaults = UserDefaults.standard
                defaults.set(json, forKey: "getFBSignUpResponse")
                print("json>>>>\(json)")
                let url = String(format: "%@%@", LoginCredentials.SocialAPI,Constants.APP_SOCIAL_Token)
                let manager = AFHTTPSessionManager()
                manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getFBSignUpResponse"), object: dict)
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    print("POST fails with error \(error)")
                    self.removeLoader()
                    
                })
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
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        fbLoginBtn.delegate = self
        
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
                    print("result >>>",dictResponse.value(forKey: "email") as! String)
                    
                    let firstName = self.nullToNil(value: dictResponse.value(forKey: "first_name") as AnyObject)
                    let idFB = self.nullToNil(value: dictResponse.value(forKey: "id") as AnyObject)
                    let lastName = self.nullToNil(value: dictResponse.value(forKey: "last_name") as AnyObject)
                    
                    //loginUpdatePush
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
                        //result.valueForKey("name") as! NSString
                        
                    let json=["dod":Common.convertdictinyijasondata(data: self.dictionaryOtherDetail),
                               "dd":Common.convertdictinyijasondata(data: self.devicedetailss),
                               "type":"social",
                             "device":"ios",
                            "social":Common.convertdictinyijasondata(data: fbDetail),
                          "provider":"facebook"]
                        let defaults = UserDefaults.standard
                        defaults.set(json, forKey: "getFBSignUpResponse")
                        print("Fb Login>>>>\(json)")
                        let url = String(format: "%@%@", LoginCredentials.SocialAPI,Constants.APP_SOCIAL_Token)
                         let manager = AFHTTPSessionManager()
                        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                            let dict = responseObject as! NSDictionary
                            print(dict)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getFBSignUpResponse"), object: dict)
                        }, failure: { (task: URLSessionDataTask?, error: Error) in
                            print("POST fails with error \(error)")
                            self.removeLoader()
                            
                        })
                    }
                    catch
                    {
                        print(error)
                    }
                    
                }
            }
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
    @objc func get_FBLogin_Response(notification: NSNotification)
    {
        /*
         print(notification)
         
         var responseDict:NSDictionary=NSDictionary()
         
         var dictHome:NSMutableDictionary=NSMutableDictionary()
         responseDict=notification.object as! NSDictionary
         dictHome=responseDict.mutableCopy() as! NSMutableDictionary
         UserDefaults.standard.setValue(dictHome.object(forKey: "id"), forKey: "loginData")
         UserDefaults.standard.setValue(dictHome.object(forKey: "uid"), forKey: "UserID")
         print("dictHome\(dictHome)")
         
         strType = "login"
         DispatchQueue.main.async { () -> Void in
         self.performSegue(withIdentifier: "showLanding", sender: self)
         }
         */
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
                 let newid = loginDict.object(forKey: "id") as! NSNumber
                UserDefaults.standard.setValue(newid.stringValue, forKey: "loginData")
                UserDefaults.standard.setValue(newid.stringValue, forKey: "UserID")
                print("dictHome\(dictHome)")
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
                UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
                DispatchQueue.main.async { () -> Void in
                    UserDefaults.standard.setValue(newid.stringValue, forKey: "loginData")
                    UserDefaults.standard.setValue(newid.stringValue, forKey: "UserID")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                    
                    self.performSegue(withIdentifier: "showSignUpHome", sender: self)
                    
//                    
//                    if UserDefaults.standard.value(forKey: "screenFrom") as? String != nil
//                    {
//                        let lastScreen = UserDefaults.standard.value(forKey: "screenFrom") as! String
//                        if lastScreen == "subscribe"
//                        {
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            if appDelegate.paymentOfSubscribe == "free" {
//                                   self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                            }
//                            else
//                            {
//                                self.getOrderID()
//                             }
//                            
//                        }
//                        else
//                        {
//                             self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                         }
//                    }
//                    else
//                    {
//                         self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                    }
                    
                 }
            }
            else
            {
                // let otp = loginDict.object(forKey: "otp") as! Int
                let strOtp = strOtpMode
                print("strOtp count",strOtp.characters.count)
                if strOtp == ""
                {
                    strRedirect = "facebook"
                    let newid = loginDict.object(forKey: "id") as! NSNumber
 
                   
                    UserDefaults.standard.setValue(newid, forKey: "UID")
                    UserDefaults.standard.setValue(strOtp, forKey: "OTP")
                    self.performSegue(withIdentifier: "showUpdateSignUp", sender: self)
                }
                else
                {
                     let newid = loginDict.object(forKey: "id") as! NSNumber

                    
                    UserDefaults.standard.setValue(newid.stringValue, forKey: "loginData")
                    UserDefaults.standard.setValue(newid.stringValue, forKey: "UserID")
                    print("dictHome\(dictHome)")
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
                    UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                    DispatchQueue.main.async { () -> Void in
                        
                        
                        self.performSegue(withIdentifier: "showSignUpHome", sender: self)
                        
                        
                        
//                        if UserDefaults.standard.value(forKey: "screenFrom") as? String != nil
//                        {
//                            let lastScreen = UserDefaults.standard.value(forKey: "screenFrom") as! String
//                            if lastScreen == "subscribe"
//                            {
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                if appDelegate.paymentOfSubscribe == "free" {
//                                    self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                                }
//                                else
//                                {
//                                    self.getOrderID()
//                                    //self.CallPaymentmethod()
//                                }
//                            }
//                            else
//                            {
//                                self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                            }
//                        }
//                        else
//                        {
//                            self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                        }
                    }
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Please enter registered emailid and password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
            
            let myArray = [["price" : strPrice, "id" : strPakageId,"title" : strPakageName,"type" : "subs","content_type" : "video"]]
            let dictionaryOtherDetail: NSDictionary = [
                "items" : myArray
            ]
            
            
            let tempDict1:NSMutableDictionary = NSMutableDictionary()
            tempDict1.setObject(myArray, forKey: "items" as NSCopying)
            print("dictionaryOtherDetail >>>",tempDict1)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionaryOtherDetail as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let itemString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                let strID = UserDefaults.standard.value(forKey: "loginData") as! String
                let json = ["device":"ios","total_price":strPrice,"cart":itemString as! String,"c_id":strID as String]
                print("json>>>",json)
                var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
                url = url.trimmingCharacters(in: .whitespaces)

                objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSubscriptionSignUpResponse" )
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
//                   // self.PayWithpaytm()
//                let paytm = PaytmView()
//                paytm.PayWithpaytm(view: self.view, viewcontroller: self)
//            }
//            else
//            {
//                self.startPayment()
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
                print("Saved")
                self.isPaywithpaytm = true
                self.getOrderID()
                
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
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let orderId =  (orderResponse.object(forKey: "order_id") as! NSNumber).stringValue
            let json = ["device":"ios","c_id":strID as String,"trans_id":IAPtrans_id,"signature":"","status":"1","order_id":orderId] as [String : Any]
            print("Payment >>",json)
            var url = String(format: "%@%@", LoginCredentials.Subscriptionpaymentv2,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)

            objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentSignUpResponse" )
            
            /*
             let strID = UserDefaults.standard.value(forKey: "loginData") as! String
             let payId = self.paymentResponse.object(forKey: "paymentId") as! Int
             let strPayId = String(payId)
             let strStatusMode = self.paymentResponse.object(forKey: "status") as! String
             let strStatus:NSString!
             if strStatusMode == "success"
             {
             strStatus = "1"
             }
             else
             {
             strStatus = "0"
             }
             let orderId = UserDefaults.standard.value(forKey: "orderID") as! Int
             let strOrderId = String(orderId)
             let json = ["device":"ios","c_id":strID as String,"trans_id":strPayId ,"status":strStatus as String,"order_id":strOrderId] as [String : Any]
             print("Payment >>",json)
             let url = String(format: "%@content/subs_payment/token/%@", Constants.API,Constants.APP_Token)
             objWebService.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentLoginResponse" )*/
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
            self.performSegue(withIdentifier: "showSignUpHome", sender: self)
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
//                let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! Data
//        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
//        print("decodedTeams",decodedTeams)
//        //razorpay = Razorpay.initWithKey("rzp_test_Ztx5S8FLWXpi7m", andDelegate: self)
//        razorpay = Razorpay.initWithKey("rzp_live_j9cAJlPELnvxVe", andDelegateWithData: self)
//          var price = UserDefaults.standard.value(forKey: "price") as! String
//      //  price = "\(price as String)00"
//        print(price as String)
//       //  price = String(format: "%@00",price as NSString)
//      //  let options: [AnyHashable: Any] = ["amount": UserDefaults.standard.value(forKey: "price") as! String!, "currency": "INR", "description": "VEQTA Sports", "name": "Razorpay",  "prefill": ["email": decodedTeams.object(forKey: "email") as! String, "contact": decodedTeams.object(forKey: "contact_no") as! String], "theme": ["color": "#3594E2"]]
//         let options: [AnyHashable: Any] = ["amount": price as String, "currency": "INR", "description": "VEQTA Sports", "name": "Razorpay",  "prefill": ["email": decodedTeams.object(forKey: "email") as! String, "contact": decodedTeams.object(forKey: "contact_no") as! String], "theme": ["color": "#3594E2"],"order_id":orderResponse.value(forKey: "order_id") as! String]
//        razorpay.open(options)
        
        
        
        
        
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
    @IBAction func backBtn(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Signup_Action(_ sender: Any)
    {
        LoginCredentials.Issociallogin = false
        firstnameTxtFld.resignFirstResponder()
        lastNmTxtFld.resignFirstResponder()
        emailTxtFld.resignFirstResponder()
        phoneTxtFld.resignFirstResponder()
        pwdTxtFld.resignFirstResponder()
        cnfrmPwdTxtFld.resignFirstResponder()
        
        let strFirstNM = firstnameTxtFld.text! as String
        let strLastNM = lastNmTxtFld.text! as String
        let strEmail = emailTxtFld.text! as String
        let strPhone = phoneTxtFld.text! as String
        let strPassword = pwdTxtFld.text! as String
        let strConfirmPassword = cnfrmPwdTxtFld.text! as String
        
        
        if strPassword == strConfirmPassword
        {
            if strFirstNM != "" && strLastNM != "" && strEmail != "" && strPhone != "" && strPassword != ""{
                if self.isValidEmail(testStr: strEmail)
                {
                    if strPassword.characters.count > 7
                    {
                        if strPhone.characters.count == 10
                        {
                            btnSignUp.isEnabled = false
                            self.createLoader()
                            do
                            {
                               
                    let json = ["first_name":firstnameTxtFld.text! as String,
                                "last_name":lastNmTxtFld.text! as String,
                                "email":emailTxtFld.text! as String,
                                "password":pwdTxtFld.text! as String,
                               "phone":strPhone,
                              "device_other_detail":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                             "devicedetail":Common.convertdictinyijasondata(data: devicedetailss)]
                                print("json >>",json)
                                var url = String(format: "%@%@", LoginCredentials.AddAPi,Constants.APP_Token)
                                url = url.trimmingCharacters(in: .whitespaces)
                                
                              let manager = AFHTTPSessionManager()
                                manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                                    let dict = responseObject as! NSDictionary
                                    print(dict)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getSignUpResponse"), object: dict)
                                }, failure: { (task: URLSessionDataTask?, error: Error) in
                                    print("POST fails with error \(error)")
                                    self.removeLoader()
                                    
                                })
                                
                                
                                

                                //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSignUpResponse" )
                            }
                            catch
                            {
                                print("catch")
                            }
                            
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Message", message: "Please enter valid phone number.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                       
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Message", message: "Password should be atleast 8 character long.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    /*
                    if self.validate(value: strPhone)
                    {
                       
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Message", message: "Please enter valid phone number.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                   */
                }
                else
                {
                    let alert = UIAlertController(title: "Message", message: "Please enter valid email.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "Message", message: "Please fill all fields.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Password and confirm password is not same.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showUpdateSignUp"
        {
            let vc = segue.destination as! UpdatePhoneViewController
            vc.strRedirectType = strRedirect
            
        }
    }
    @objc func getSignUpResponse(notification: NSNotification)
    {
        self.removeLoader()
        btnSignUp.isEnabled = true
        var responseDict:NSDictionary=NSDictionary()
        print("notification>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictResponse=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        print("dictResponse >>>%@",dictResponse)
        let resultCode = dictResponse.object(forKey: "code") as! Int
        if resultCode == 1
        {
//            UserDefaults.standard.setValue(dictResponse.object(forKey: "id"), forKey: "UID")
//            UserDefaults.standard.setValue(dictResponse.object(forKey: "otp"), forKey: "OTP")
//             self.performSegue(withIdentifier: "showOtp", sender: self)
            
            
            
   
            
            ////////new change/////
            
            
            var loginDict:NSDictionary=NSDictionary()
            loginDict = dictResponse.value(forKey:"info") as! NSDictionary
            let newid = loginDict.object(forKey: "id") as! NSNumber
            print("dictResponse otp >>>%@",dictResponse)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
            UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            UserDefaults.standard.setValue(newid.stringValue, forKey: "loginData")
            UserDefaults.standard.setValue(newid.stringValue, forKey: "UserID")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startHeartBeat"), object: dictResponse)
            
            self.performSegue(withIdentifier: "showSignUpHome", sender: self)
            
//            if UserDefaults.standard.value(forKey: "screenFrom") as? String != nil
//            {
//                let lastScreen = UserDefaults.standard.value(forKey: "screenFrom") as! String
//                if lastScreen == "subscribe"
//                {
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    if appDelegate.paymentOfSubscribe == "free" {
//                        self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                    }
//                    else
//                    {
//                        self.getOrderID()
//                    }
//                }
//                else
//                {
//                    self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//                }
//            }
//            else
//            {
//                self.performSegue(withIdentifier: "showSignUpHome", sender: self)
//            }
//            
            
            
            
            
            
        }
        else
        {
            btnSignUp.isEnabled = true
            let alert = UIAlertController(title: "Message", message: dictResponse.object(forKey: "error") as! String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        //showLoginScreen
        self.performSegue(withIdentifier: "showLoginScreen", sender: self)
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0
            {
                if strSelected == "email" || strSelected == "firstname" || strSelected == "lastname" || strSelected == "phone"
                {
                    
                }
                else
                {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            self.view.frame.origin.y = 0
            
            
//            if view.frame.origin.y != 0 {
//                if strSelected == "email" || strSelected == "firstname" || strSelected == "lastname" || strSelected == "phone"
//                {
//                    
//                }
//                else
//                {
//                   self.view.frame.origin.y += keyboardSize.height
//                }
//                
//            }
//            else {
//                
//            }
        }
    }
    
    
    
    
    
    
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
    
    
    

}
