


//
//  SubscriptionPlanVC.swift
//  VEQTA
//
//  Created by multitv on 18/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AFNetworking

class SubscriptionPlanVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,RazorpayPaymentCompletionProtocolWithData
{
    //var params : PUMRequestParams = PUMRequestParams.shared()
    var utils : Utils = Utils()
    var objLoader : LoaderView = LoaderView()
    private var razorpay : Razorpay!
     var isPaywithpaytm = Bool()

    @IBOutlet var tableConstrain: NSLayoutConstraint!
    @IBOutlet var freeLbl: UILabel!
    @IBOutlet var freeTrailLbl: UILabel!
    
    @IBOutlet var attributetextview: UITextView!

    @IBOutlet var subscribeTbView: UITableView!
    @IBOutlet weak var subsCollection:UICollectionView!
    @IBOutlet weak var signUpView:UIView!
      @IBOutlet var signupview2: UIView!
    @IBOutlet weak var btnSignUP:UIButton!
    @IBOutlet weak var lblAnyTime:UILabel!
    var orderResponse:NSDictionary=NSDictionary()
    var paymentResponse:NSDictionary=NSDictionary()
    var price:NSString = NSString()
    var packageIDS:NSString = NSString()
    var successPayId:NSString = NSString()
    var signature_id = String()
    var IAPtrans_id = String()
    var successFailedStr:NSString = NSString()
     @IBOutlet weak var btnSideMenu: UIButton!
    var arrayPackage:NSMutableArray = NSMutableArray()
    var arrayLastOrder:NSDictionary = NSDictionary()
    var objWeb = AFNetworkingWebServices()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // let arrayOfVCs = navigationController!.viewControllers as Array
     //   print("view ?????>>>>",arrayOfVCs)
        AppUtility.lockOrientation(.portrait)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
         self.frostedViewController.panGestureEnabled = false
        NotificationCenter.default.addObserver(self,selector: #selector(getPackageListResponse),name: NSNotification.Name(rawValue: "getPackageList"),object: nil)
        //getSubscriptionResponse
        NotificationCenter.default.addObserver(self,selector: #selector(getSubscriptionResponse),name: NSNotification.Name(rawValue: "getSubscriptionResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getPaymentResponse),name: NSNotification.Name(rawValue: "getPaymentResponse"),object: nil)
        self.subscribeTbView!.register(UINib(nibName: "SubscribeTableViewCell", bundle: nil), forCellReuseIdentifier: "subscribeCell")
        //getPaymentResponse
        self.subscribeTbView!.register(UINib(nibName: "watchTvTableViewCell", bundle: nil), forCellReuseIdentifier: "watchTvCell")
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionSubsLogin"),object: nil)
       //For register custom cell of collection view
       // self.signUpView.layer.borderWidth = 0.5
       // self.signUpView.layer.borderColor = UIColor.white.cgColor
        self.signUpView.layer.cornerRadius = 5
       // self.btnSignUP.layer.borderWidth = 0.5
       // self.btnSignUP.layer.borderColor = UIColor.white.cgColor
        self.btnSignUP.layer.cornerRadius = 5
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            signupview2.isHidden = true
            signUpView.isHidden = true
            freeTrailLbl.isHidden = false
            freeLbl.isHidden = true
            let rect = CGRect(origin: CGPoint(x: 0,y :200), size: CGSize(width: subscribeTbView.frame.size.width, height: self.view.frame.size.height-200))
            subscribeTbView.frame = rect
            
        }
        else
        {
         
            freeLbl.isHidden = true

            
            tableConstrain.constant = 66
            freeTrailLbl.isHidden = true
            signupview2.isHidden = true
            signUpView.isHidden = true
            let alert = UIAlertController(title: "Message", message: "If you are already a VEQTA subscriber, please Sign in to continue.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign In", style: UIAlertActionStyle.default, handler: { (action) in
                
                self.afterSessionLogin()
                
               // self.performSegue(withIdentifier: "subsLogin", sender: self)
              }))
            
         
            self.present(alert, animated: true, completion: nil)
        }
        self.getSubscribePlans()
        self.setlinkattribute()
    }
    //rzp_live_sESWgny72GhK18

    
    
    func setlinkattribute()
    {
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: "https://www.veqta.in/Terms&condition.html")!,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!
             ] as [String : Any]
        let linkAttributes1 = [
            NSLinkAttributeName: NSURL(string: "https://www.veqta.in/privacy.html")!,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!
             ] as [String : Any]
         attributetextview.linkTextAttributes = linkAttributes
        let linkAttributes2 = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        let attributedString = NSMutableAttributedString(string: attributetextview.text, attributes: linkAttributes2 )
        print(attributedString.length)
      

        // Set the 'click here' substring to be the link
        attributedString.setAttributes(linkAttributes, range:NSRange(location:683,length:13))
        attributedString.setAttributes(linkAttributes1, range:NSRange(location:700,length:14))
        attributetextview.attributedText = attributedString
 
    }
    
    
    func afterSessionLogin()
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        view.addSubview(controller.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionSubsLogin"
    }
    func createLoader() {
        self.objLoader = LoaderView()
        self.objLoader.frame=CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.objLoader.createLoader()
        UIApplication.shared.delegate!.window!?.addSubview(self.objLoader)
        UIApplication.shared.delegate!.window!?.bringSubview(toFront:self.objLoader)
    }
    func removeLoader() {
        
        self.objLoader.removeFromSuperview()
    }
    func redirectTologin()
    {
        //sucribeSignUp
        self.performSegue(withIdentifier: "sucribeSignUp", sender: self)
    }
    func getSubscribePlans()
    {
        self.createLoader()
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
            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getPackageList")
        }
        else
        {
            var json = ["device":"ios"]
            json = [:]
            // print("json >>",json)
            print("subscribe json >>",json)
            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
            url = "\(Constants.SubscriptionBaseUrl)/subscriptionapi/v6/spackage/subscription/token/\(Constants.APP_Token)device/ios"
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getPackageList")
        }
        //        let json = ["user_id":"12"]
        //        print("json >>",json)
        //        objWeb.getRequestAndGetResponse(urlString:"http://dev.multitvsolution.com/automator/api/v2/spackage/subscription/token/584ab077cc9f8/", param: json as NSDictionary, info:"getPackageList")
    }
    func nullToNil(value : AnyObject?) -> AnyObject?
    {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @objc func getPackageListResponse(notification: NSNotification)
    {
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        // print("notification>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        let subscribeDict=(responseDict.object(forKey:"result") as AnyObject) as! NSDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        dictResponse = subscribeDict.mutableCopy() as! NSMutableDictionary
        print("sub scribe list >>%@",dictResponse)
        LoginCredentials.UserSubscriptiondetail = (dictResponse.value(forKey: "package_list") as AnyObject) as! NSArray
         if LoginCredentials.UserSubscriptiondetail.count == 2 {
            self.subscribeTbView.isScrollEnabled = false
        }
        else
        {
            self.subscribeTbView.isScrollEnabled = true
        }

        subscribeTbView.reloadData()
        print("arrayPackage>>>",arrayPackage)
       
        
        if(Common.Isuserissubscribe(Userdetails: self))
        {
             tableConstrain.constant = 77
            var strPackName = (LoginCredentials.UserSubscriptiondetail.object(at: 0) as! NSDictionary).object(forKey: "s_name") as? String
            if strPackName == "Annual Value Pack" {
                strPackName = "Annual"
            }
            else
            {
                strPackName = "Monthly"
            }
              freeTrailLbl.text =   String(format: "You are on your %@ Plan.",strPackName!)
        }
        else
        {
            tableConstrain.constant = 30
            freeTrailLbl.text = ""
        }
    }
    
    @IBAction func btn_Subscription_ACtion(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.paymentOfSubscribe = "free"
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
      
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
        }
        else
        {
            UserDefaults.standard.set("subscribe", forKey: "screenFrom")
            self.redirectTologin()
        }
    }
    @IBAction func side_Action(_ sender: Any) {
        print("Side bar")
       
        
        self.performSegue(withIdentifier: "homeSubPush", sender: self)
       
    }
    
    @IBAction func btnSideMenuAction(_ sender: UIButton)
    {
        print("Side bar")
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
    //TableView View Delegates and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1;
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = UITableViewCell()
        if indexPath.section == 1
        {
            let cells = tableView.dequeueReusableCell(withIdentifier: "watchTvCell", for: indexPath) as! watchTvTableViewCell
            print("set tag>>>",indexPath.section)
            cells.watchCollectionView.reloadData()
            cells.watchCollectionView!.register(UINib(nibName: "WatchTvCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WatchTvCollectionViewCell")
            cells.watchCollectionView.tag = indexPath.section
            cells.watchCollectionView.delegate = self
            cells.watchCollectionView.dataSource = self
            cell = cells
        }
        else
        {
            let cells = tableView.dequeueReusableCell(withIdentifier: "subscribeCell", for: indexPath) as! SubscribeTableViewCell
            print("set tag>>>",indexPath.section)
            cells.subscribeCollectionView.reloadData()
            cells.subscribeCollectionView!.register(UINib(nibName: "SubscriptionCollecCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCollecCell")
            cells.subscribeCollectionView.tag = indexPath.section
            cells.subscribeCollectionView.delegate = self
            cells.subscribeCollectionView.dataSource = self
            cell = cells
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 1)
        {
            return 0
        }
        else
        {
            
            
             var count:Int = 0
            count = LoginCredentials.UserSubscriptiondetail.count * 100
            print("count >>>",count)
            return CGFloat(count)
        }
        
    }
    
    //MARK:- CollectionView Delegates and Datasource
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        sizeForItemAt indexPath: IndexPath) -> CGSize
    //    {
    //        print("collectionView.frame.size.height>>>",collectionView.frame.size.height)
    //        var count = countArray/2
    //        if collectionView.tag == 0
    //        {
    //            count = count * 120
    //            return CGSize(width: collectionView.frame.size.width, height: CGFloat(count))
    //        }
    //       else
    //        {
    //            count = count * 120
    //            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    //        }
    //    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var sizeCalculate = self.view.frame.size.width / 2
        //   print("collectionView.frame.size.height>>>",sizeCalculate)
        sizeCalculate = sizeCalculate - 10
        let screenSize = self.view.frame.size.width
        if collectionView.tag == 1
        {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else
        {
            
           
            
            if screenSize < 330
            {
                return CGSize(width: 150, height: collectionView.frame.size.height)
            }
            else
            {
                return CGSize(width: sizeCalculate, height: collectionView.frame.size.height)
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.tag == 1
        {
            
        }
        else
        {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
        let combinedItemWidth = (numberOfItems * flowLayout.itemSize.width) + ((numberOfItems - 1)  * flowLayout.minimumInteritemSpacing)
        let padding = (collectionView.frame.width - combinedItemWidth) / 2
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 1
        {
            return 1
        }
        else
        {
            return LoginCredentials.UserSubscriptiondetail.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchTvCollectionViewCell", for: indexPath) as! WatchTvCollectionViewCell
            cell.btnVeqta.addTarget(self, action: #selector(openVEQTA), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollecCell", for: indexPath) as! SubscriptionCollecCell
             cell.viewSubPlan.layer.cornerRadius = 5
             cell.viewSubscriptionPlan.layer.cornerRadius = 5
            cell.lblPlan.text = (LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as AnyObject).object(forKey: "s_name") as? String
            let strCurrency = (((LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).object(forKey: "p_currency") as? String)!.uppercased()
            let strPrice = String(format: "%@ %@",strCurrency, (((LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).object(forKey: "p_price") as? String)!)
            let strPackage = (((LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).object(forKey: "is_subscriber") as? String)!
            if strPackage == "1"
            {
                cell.checkImg.isHidden = false
                cell.ClickHerelabel.isHidden = true
                
            }
            else
            {
                cell.checkImg.isHidden = true
                cell.ClickHerelabel.isHidden = false

            }
            
            let fullNameArr = strPrice.components(separatedBy: " ")
            let intprice = ((fullNameArr[1] as? NSString)?.intValue)! + 1
            cell.lblPrice.text =  "\(fullNameArr[0])\(" ")\(intprice)"
            
            return cell
        }
    }
    func openVEQTA()
    {
        UIApplication.shared.openURL(URL(string: "https://www.veqta.in")!)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("tag  ",collectionView.tag)
        if collectionView.tag == 1
        {
            
        }
        else
        {
            
            if Common.Isuserissubscribe(Userdetails: self)
            {
                //cell.checkImg.isHidden = false
            }
            else
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.paymentOfSubscribe = "paid"
                if UserDefaults.standard.value(forKey: "loginData") as? String != nil
                {
                    
                    let finalPrice =   ((LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_price") as! String
                     let strPakageId = ((LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "package_id") as! String
                    let strPakageName = ((LoginCredentials.UserSubscriptiondetail.object(at: indexPath.item) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as! String
                    self.getOrderID(finalprice: finalPrice, pakege_id: strPakageId, pakegename: strPakageName)
                 }
                else
                {
                   UserDefaults.standard.set("subscribe", forKey: "screenFrom")
                    self.redirectTologin()
                }
            }
            
            
        }
        
    }
    
    
    
    
    
    func getOrderID(finalprice:String,pakege_id:String,pakegename:String)
    {
        self.createLoader()
        let newid = (pakege_id as NSString).intValue
        let items = ["id":newid] as [String:Any]
        let itemsarray = [items]
        let cartdetail = ["items" :itemsarray] as [String:Any]
        var Param = NSDictionary()
        let strID = UserDefaults.standard.value(forKey: "loginData") as! String
        Param =   ["cart":Common.convertdictinyijasondata(data: cartdetail as NSDictionary),
                   "c_id":strID,
                   "paymentgateway":"inapp",
             ] as NSDictionary
        print(Common.convertdictinyijasondata(data: Param as NSDictionary))
        var url =  "\(Constants.SubscriptionBaseUrl)/subscriptionapi/v6/subscription/create_order/token/\(Constants.APP_Token)device/ios"
         url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
         manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                   self.removeLoader()
                 Common.Showdefaultalert(view: self, text: "Getting some error please try again later")
 
                }

                else
                {
                  self.removeLoader()
                     let subs_id = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "subscriber_id") as! Int
                    let Order_id = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "id") as! Int
                    print(subs_id)
                    self.startPayment(orderid: Order_id, subscriptionid: subs_id)
                    
                }



            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            self.removeLoader()
            Common.Showdefaultalert(view: self, text: "Getting some error please try again later")
        }

        
//            var url =  "http://staging.multitvsolution.com:9002/subscriptionapi/v6/subscription/create_order/token/\(Constants.APP_Token)device/ios"
//            url = url.trimmingCharacters(in: .whitespaces)
//            print(url)
//            objWeb.postRequestAndGetResponse(urlString: url as NSString, param: Param, info:"getSubscriptionResponse" )
 
        
        
        
        
        
        
        
        
//         let newid = (pakege_id as NSString).intValue
//          let items = ["id":newid] as [String:Any]
//          let itemsarray = [items]
//         let cartdetail = ["items" :itemsarray] as [String:Any]
//
//
//    let myArray = [["price" : finalprice, "id" : pakege_id,"title" : pakegename,"type" : "subs","content_type" : "video"]]
//         let dictionaryOtherDetail: NSDictionary = [
//            "items" : myArray
//        ]
//
//        let tempDict1:NSMutableDictionary = NSMutableDictionary()
//        tempDict1.setObject(myArray, forKey: "items" as NSCopying)
//        print("dictionaryOtherDetail >>>",tempDict1)
//         do
//        {
//            let jsonData = try JSONSerialization.data(withJSONObject: dictionaryOtherDetail as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let itemString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
//            let json = ["device":"ios","total_price":finalprice,"cart":itemString as! String,"c_id":strID as String,"paymentgatway":"IAP"]
//            print("json>>>",json)
//           // let url = String(format: "%@content/subscription_new/token/%@", Constants.APIV2,Constants.APP_Token)
//            var url = String(format: "%@%@", LoginCredentials.Subscriptionapiv2,Constants.APP_Token)
//            url = url.trimmingCharacters(in: .whitespaces)
//              print(url)
//            //  let url = String(format: "%@order/subscription/token/%@", Constants.APIV4,Constants.APP_Token)
//
  //          objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSubscriptionResponse" )
//        }
//        catch
//        {
//            print("catch")
//        }
//
    }
    
    
    
    @objc func getSubscriptionResponse(notification: NSNotification)
    {
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        print(dictResponse)
        let newresponce = notification.object as! NSDictionary
        let resultCode = newresponce.object(forKey: "code") as! Int
        if resultCode == 1
        {
        
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  (newresponce.value(forKey: "result") as! String).aesDecrypt(key: keyString)
        print(encode)
            
          let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
            orderResponse=jsonObject
            print(orderResponse)
        UserDefaults.standard.set(orderResponse.object(forKey: "order_id"), forKey: "orderID")
        // dictResponse = responseDict.mutableCopy() as! NSMutableDictionary
        print("dictResponse >>>",orderResponse)
        UserDefaults.standard.set("subscribe", forKey: "screenFrom")
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            
       //  self.startPayment()
           
//            if(isPaywithpaytm)
//            {
//                   // self.PayWithpaytm()
//                let paytm = PaytmView()
//                paytm.PayWithpaytm(view: self.view, viewcontroller: self)
//            }
//            else
//            {
//              self.startPayment()
//            }
//            
            
        }
        else
        {
            self.redirectTologin()
        }
        
        }
        else
        {
            self.alertWithTitle("Error", message: "Getting error please try after some time")
            return
        }
    }
    
    
    
    
    func CallPaymentmethod(finalprice:String,pakege_id:String,pakegename:String)
  {
   // self.getOrderID(finalprice: finalPrice, pakege_id: strPakageId, pakegename: strPakageName)
    let optionMenu = UIAlertController(title: nil, message: "Choose Payment Option", preferredStyle: .actionSheet)
    
    let saveAction = UIAlertAction(title: "Pay With Paytm", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Saved")
            self.isPaywithpaytm = true
            self.getOrderID(finalprice: finalprice, pakege_id: pakege_id, pakegename: pakegename)
     })
    
    let deleteAction = UIAlertAction(title: "Pay With Razorpay", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Razorpay")
            self.isPaywithpaytm = false
            self.getOrderID(finalprice: finalprice, pakege_id: pakege_id, pakegename: pakegename)
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
    
    
    
    func paymentStatus(tran_id:String,sub_id:Int,orderid:Int)
    {
        
      
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = (receiptData?.base64EncodedString(options: []))! as String
        print(receiptString)
        let strID = UserDefaults.standard.value(forKey: "loginData") as! String
        print(tran_id)
        print(receiptString)
        print(sub_id)
        print(orderid)
        
        let Param =   ["c_id":strID,
                       "paymentgateway":"inapp",
                       "trans_id":tran_id,
                       "signature":receiptString,
                       "subscription_id":sub_id,
                       "order_id":orderid,
                       "status":"1"
            ] as [String:Any]
        print(Param)
        var url = String()
        url = String(format: "\(Constants.SubscriptionBaseUrl)/subscriptionapi/v6/subscription/complete_order/token/%@device/ios",Constants.APP_Token)
           url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                self.getSubscribePlans()
              }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
             self.dismiss(animated: true, completion: nil)
            self.removeLoader()
            Common.Showdefaultalert(view: self, text: "Getting some error please try again later")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        let receiptData = SwiftyStoreKit.localReceiptData
//        let receiptString = (receiptData?.base64EncodedString(options: []))! as String
//        print(receiptString)
//
//            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
//                let orderId =  (orderResponse.object(forKey: "order_id") as! NSNumber).stringValue
//              let json = ["device":"ios","c_id":strID as String,"trans_id":IAPtrans_id,"signature":receiptString,"status":"1","order_id":orderId] as [String : Any]
//            print("Payment >>",json)
//                var url = String(format: "%@%@", LoginCredentials.Subscriptionpaymentv2,Constants.APP_Token)
//        url = url.trimmingCharacters(in: .whitespaces)

        
          //let url = String(format: "%@order/payment/token/%@", Constants.APIV4,Constants.APP_Token)
        
      //       objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentResponse" )
        
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
            let orderId = orderResponse.object(forKey: "order_id") as! Int
            let strOrderId = String(orderId)
            let json = ["device":"ios","c_id":strID as String,"trans_id":strPayId ,"status":strStatus as String,"order_id":strOrderId] as [String : Any]
            print("Payment >>",json)
            let url = String(format: "%@content/subs_payment/token/%@", Constants.API,Constants.APP_Token)
            objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getPaymentResponse" )
         }
 */
    }
    @objc func getPaymentResponse(notification: NSNotification)
    {
        // print("notification>>>>",notification.object)
        //  var dictResponse:NSMutableDictionary=NSMutableDictionary()
        let dictPayment=notification.object as! NSDictionary
        // dictResponse = responseDict.mutableCopy() as! NSMutableDictionary
        print("dictResponse >>>",dictPayment)
        let resultCode = dictPayment.object(forKey: "code") as! Int
        if resultCode == 1
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Payment failed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            let orderId = (orderResponse.object(forKey: "order_id") as! NSNumber).stringValue
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            APPDataBase.saveIapfalierdata(orderid: orderId, userid: strID, transid: IAPtrans_id)
             self.removeLoader()
            
         }
        self.getSubscribePlans()
    }
    //getPaymentResponse
    //MARK: Payment
    func startPayment(orderid:Int,subscriptionid:Int) -> Void {
 
//        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! Data
//        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
//        print("decodedTeams",decodedTeams)
//        razorpay = Razorpay.initWithKey("rzp_live_j9cAJlPELnvxVe", andDelegateWithData: self)
//       // razorpay = Razorpay.initWithKey("rzp_test_Ztx5S8FLWXpi7m", andDelegate: self )
//         let options: [AnyHashable: Any] = ["amount": price as String, "currency": "INR", "description": "VEQTA Sports", "name": "Razorpay",  "prefill": ["email": decodedTeams.object(forKey: "email") as! String, "contact": decodedTeams.object(forKey: "contact_no") as! String], "theme": ["color": "#3594E2"],"order_id":orderResponse.value(forKey: "order_id") as! String]
//        print(options)
//        razorpay.open(options)
        
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        self.createLoader()
        SwiftyStoreKit.purchaseProduct(Constants.appBundleId, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                self.IAPtrans_id = purchase.transaction.transactionIdentifier!
                 print(ReceiptInfo())
                 print(self.IAPtrans_id)
                self.paymentStatus(tran_id: self.IAPtrans_id, sub_id: subscriptionid, orderid: orderid)
                  if purchase.needsFinishTransaction {
                      SwiftyStoreKit.finishTransaction(purchase.transaction)
                  }
            }
            if case .error(let eror) = result
            {
              print(eror.code)
                self.removeLoader()
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
        signature_id = response?["razorpay_signature"] as! String
      //   Razorpay_id = response?["razorpay_order_id"] as! String
        successPayId = payment_id as NSString
        successFailedStr = "success"
         let alert = UIAlertController(title: "Payment Successful", message: "Payment Successful", preferredStyle: UIAlertControllerStyle.alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       // self.paymentStatus()
        
        
    }
    
    
    @IBAction func Taptosubscriptionalert(_ sender: UIButton) {
        
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionwebViewController") as! SubscriptionwebViewController
        let alert = UIAlertController(title: "VEQTA", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Terms of Use", style: UIAlertActionStyle.destructive, handler: { action in
        
            vc.Headerstring = "Terms of Use"
           vc.Urlstring = "https://www.veqta.in/Terms&condition.html"
            self.present(vc, animated: true, completion: nil)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Automatic Renewal Terms", style: UIAlertActionStyle.destructive, handler: { action in
            vc.Headerstring = "Automatic Renewal Terms"
            vc.Urlstring = "https://www.veqta.in/Terms&condition.html"
            
        }))
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: UIAlertActionStyle.destructive, handler: { action in
            vc.Headerstring = "Privacy Policy"
            vc.Urlstring = "https://www.veqta.in/privacy.html"
            self.present(vc, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
        
        
        
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
//       // self.paymentStatus()
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
        
        /*
         String ph = checkNull(key) + "|" + checkNull(txnid) + "|" + checkNull(amount) + "|" + checkNull(productInfo)
         + "|" + checkNull(firstname) + "|" + checkNull(email) + "|" + checkNull(udf1) + "|" + checkNull(udf2)
         + "|" + checkNull(udf3) + "|" + checkNull(udf4) + "|" + checkNull(udf5) + "|" + salt;
         */
        
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
            self.showAlertViewWithTitle(title: "Message", message: "Congrats! Payment is Successful")
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
    override func didReceiveMemoryWarning()
    {
        print("didReceiveMemoryWarning subscribe")
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
