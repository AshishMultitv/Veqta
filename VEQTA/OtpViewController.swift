//
//  OtpViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 14/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class OtpViewController: UIViewController,RazorpayPaymentCompletionProtocolWithData {
    var objWeb = AFNetworkingWebServices()
     var isPaywithpaytm = Bool()
    private var razorpay : Razorpay!
    var successPayId:NSString = NSString()
    var signature_id = String()
    var Razorpay_id = String()
      var successFailedStr:NSString = NSString()
    var orderResponse:NSDictionary=NSDictionary()
    @IBOutlet var submitBtn: UIButton!
    var paymentResponse:NSDictionary=NSDictionary()
    @IBOutlet var codeTxtFld: UITextField!
    @IBOutlet var btnResend: UIButton!
    var objLoader : LoaderView = LoaderView()
    //var params : PUMRequestParams = PUMRequestParams.shared()
    var utils : Utils = Utils()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //getPaymentOtpResponse
        self.frostedViewController.panGestureEnabled = false
        NotificationCenter.default.addObserver(self,selector: #selector(getOtpResponse),name: NSNotification.Name(rawValue: "getOtpResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getPaymentOtpResponse),name: NSNotification.Name(rawValue: "getPaymentOtpResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getSubscriptionOTPSResponse),name: NSNotification.Name(rawValue: "getSubscriptionOTPSResponse"),object: nil)
        // Do any additional setup after loading the view.
        
        submitBtn.layer.cornerRadius = 20
        codeTxtFld.becomeFirstResponder()
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
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "verifyNumber"
        {
            let vc = segue.destination as! UpdatePhoneViewController
            vc.strRedirectType = "otp"
            
        }
    }
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Resend_Action(_ sender: Any) {
        
        self.performSegue(withIdentifier: "verifyNumber", sender: self)
    }
    @IBAction func btn_Back_Action(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        submitBtn.isEnabled = false
        codeTxtFld.resignFirstResponder()
        let userID:Int = UserDefaults.standard.value(forKey: "UID") as! Int
        let strID = String(userID)
      //  let otp = UserDefaults.standard.value(forKey: "OTP") as! Int
        let strCode = codeTxtFld.text! as String
        
        if strCode != ""
        {
           // let code:Int = Int(codeTxtFld.text!)!
           // if code == otp
           // {
            self.createLoader()
                let json = ["user_id":strID ,"otp":strCode as String,"device":"ios"]
                print("json >>",json)
            var url = String(format: "%@%@", LoginCredentials.Verifyotpapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)

                objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getOtpResponse" )
//            }
//            else
//            {
//                let alert = UIAlertController(title: "Message", message: "Please enter valid otp.", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
        }
        else
        {
            submitBtn.isEnabled = true
            let alert = UIAlertController(title: "Message", message: "Please enter valid otp.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func getOtpResponse(notification: NSNotification)
    {
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        print("notification>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictResponse=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        let resultCode = dictResponse.object(forKey: "code") as! Int
        if resultCode == 1
        {
            
            submitBtn.isEnabled = true
            var loginDict:NSDictionary=NSDictionary()
            loginDict = dictResponse.value(forKey:"result") as! NSDictionary
            print("dictResponse otp >>>%@",dictResponse)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginDict)
            UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
            //let idResult = loginDict.object(forKey: "id") as! Int
           // let strID = String(idResult)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
           //let uisResult = loginDict.object(forKey: "uid") as! Int
          //  let strUID = String(uisResult)
            
            
            UserDefaults.standard.setValue(loginDict.object(forKey: "id"), forKey: "loginData")
            UserDefaults.standard.setValue(loginDict.object(forKey: "uid"), forKey: "UserID")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startHeartBeat"), object: dictResponse)
            
            if UserDefaults.standard.value(forKey: "screenFrom") as? String != nil
            {
                let lastScreen = UserDefaults.standard.value(forKey: "screenFrom") as! String
                if lastScreen == "subscribe"
                {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if appDelegate.paymentOfSubscribe == "free" {
                        self.performSegue(withIdentifier: "otpHome", sender: self)
                       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
                        // navigationController!.popToViewController((navigationController?.viewControllers[0])!, animated: false)
                        // navigationController!.popToRootViewController(animated: true)
                    }
                    else
                    {
                        self.getOrderID()
                      // self.CallPaymentmethod()
                    }
                }
                else
                {
                    // navigationController!.popToViewController((navigationController?.viewControllers[0])!, animated: false)
                    //  navigationController!.popToRootViewController(animated: true)
                    self.performSegue(withIdentifier: "otpHome", sender: self)
                   // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
                }
            }
           else
            {
                self.performSegue(withIdentifier: "otpHome", sender: self)
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
            }
            
        }
        else
        {
            submitBtn.isEnabled = true
            print("dictResponse otp >>>%@",dictResponse)
            let alert = UIAlertController(title: "Message", message: "Please enter valid otp.", preferredStyle: UIAlertControllerStyle.alert)
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

                objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSubscriptionOTPSResponse" )
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
    @objc func getSubscriptionOTPSResponse(notification: NSNotification)
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
//             if(isPaywithpaytm)
//            {
//                    //self.PayWithpaytm()
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
        //let payId = self.paymentResponse.object(forKey: "paymentId") as! Int
        // let strPayId = String(payId)
        // let strStatusMode = self.paymentResponse.object(forKey: "status") as! String
        let strStatus:NSString!
        if successFailedStr == "success"
        {
            strStatus = "1"
        }
        else
        {
            strStatus = "0"
            successPayId = "0"
        }
        //let orderId = orderResponse.object(forKey: "order_id") as! Int
       // let strOrderId = String(orderId)
        let json = ["device":"ios","c_id":strID as String,"trans_id":successPayId,"signature":signature_id ,"status":strStatus as String,"order_id":Razorpay_id] as [String : Any]
        print("Payment >>",json)
        var url = String(format: "%@%@", LoginCredentials.Subscriptionpaymentv2,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)

        objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentOtpResponse" )
        /*
        let status = self.paymentResponse.object(forKey: "paymentId") as! Int
        if status == -1
        {
            
        }
        else
        {
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
            objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentOtpResponse" )
        }
        */
    }
    @objc func getPaymentOtpResponse(notification: NSNotification)
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
            self.performSegue(withIdentifier: "otpHome", sender: self)
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
           // navigationController!.popToRootViewController(animated: true)
           //navigationController!.popToViewController((navigationController?.viewControllers[0])!, animated: false)
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Payment failed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        params.delegate = self;*/
        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        print("decodedTeams",decodedTeams)
        //razorpay = Razorpay.initWithKey("rzp_test_Ztx5S8FLWXpi7m", andDelegate: self)
        razorpay = Razorpay.initWithKey("rzp_live_j9cAJlPELnvxVe", andDelegateWithData: self)
        var price = UserDefaults.standard.value(forKey: "price") as! String
       // price = "\(price as String)00"
        print(price as String)

        let options: [AnyHashable: Any] = ["amount": price, "currency": "INR", "description": "VEQTA Sports", "name": "Razorpay",  "prefill": ["email": decodedTeams.object(forKey: "email") as! String, "contact": decodedTeams.object(forKey: "contact_no") as! String], "theme": ["color": "#3594E2"],"order_id":orderResponse.value(forKey: "order_id") as! String]
        
        razorpay.open(options)
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
    
    
//    
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
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
