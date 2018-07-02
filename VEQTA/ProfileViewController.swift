

//
//  ProfileViewController.swift
//  VeqtaMyProfile
//
//  Created by multitv on 02/05/17.
//  Copyright © 2017 multitv. All rights reserved.
//

import UIKit
import REFrostedViewController
import AFNetworking
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var arrayPackage:NSMutableArray = NSMutableArray()
    @IBOutlet var successLbl: UILabel!
    @IBOutlet var paymentLbl: UILabel!
    //@IBOutlet var orderLbl: UILabel!
    @IBOutlet var orderIdLbl: UILabel!
    @IBOutlet var subExpDetailLbl: UILabel!
    @IBOutlet var subExpLbl: UILabel!
    @IBOutlet var dateSubLbl: UILabel!
    @IBOutlet var genderLBl: UILabel!
    var localeStr:NSString = NSString()
    @IBOutlet var subDateLbl: UILabel!
    var packageIDS:NSString = NSString()
    var sub_Start:NSString = NSString()
    var sub_End:NSString = NSString()
    
    @IBOutlet var subPlanLbl: UILabel!
    @IBOutlet var subPlanMonthLbl: UILabel!
    
    @IBOutlet var aboutMeBg: UIView!
    @IBOutlet var subDateConstrain: NSLayoutConstraint!
    
    @IBOutlet var dateOfSubLbl: UILabel!
    var objWeb = AFNetworkingWebServices()
    @IBOutlet weak var btnMale:UIButton!
    @IBOutlet weak var btnFemale:UIButton!
    @IBOutlet weak var txtDob:UITextField!
    @IBOutlet weak var txtEmailId:UITextField!
    @IBOutlet weak var txtMobileNumber:UITextField!
    @IBOutlet weak var imgViewProfile:UIImageView!
    @IBOutlet weak var btnEditProfile:UIButton!
    @IBOutlet weak var btnProfileImageChange:UIButton!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var aboutMeLbl: UILabel!
    
    
    var UserpakeageSubscriptiondetail = NSArray()
    
    
    //about_me
    //Anamika
    let imagePicker = UIImagePickerController()
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionProfileLogin"
        self.frostedViewController.panGestureEnabled = false
        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! NSData
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            //  print("countryCode",countryCode)
            localeStr = countryCode as NSString
        }
        else
        {
            localeStr = "us"
        }
        
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! NSDictionary
        
//        let strDob = decodedTeams.object(forKey: "dob") as! String
//        if strDob == "0000-00-00" {
//            self.txtDob.attributedPlaceholder = NSAttributedString(string: "Not Available",
//                                                                   attributes: [NSForegroundColorAttributeName: UIColor.white])
//        }
//        else
//        {
//            self.txtDob.attributedPlaceholder = NSAttributedString(string: decodedTeams.object(forKey: "dob") as! String,
//                                                                   attributes: [NSForegroundColorAttributeName: UIColor.white])
//        }
        let aboutMe = nullToNil(value: decodedTeams.object(forKey: "about_me") as AnyObject) as! String
        if aboutMe == "" {
            self.aboutMeBg.isHidden =  true
            self.aboutMeLbl.text = ""
        }
        else
        {
            self.aboutMeBg.isHidden =  false
            self.aboutMeLbl.text = aboutMe
        }
        
        
        self.txtEmailId.text = decodedTeams.object(forKey: "email") as? String
//        self.txtEmailId.attributedPlaceholder = NSAttributedString(string: decodedTeams.object(forKey: "email") as! String,
//                                                                   attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.txtMobileNumber.text = decodedTeams.object(forKey: "contact_no") as? String
//        self.txtMobileNumber.attributedPlaceholder = NSAttributedString(string: decodedTeams.object(forKey: "contact_no") as! String,
//                                                                        attributes: [NSForegroundColorAttributeName: UIColor.white])
         let image_mode = nullToNil(value: decodedTeams.object(forKey: "image") as AnyObject)
       // self.imgViewProfile.downloadFrom(link: decodedTeams.object(forKey: "image") as? String, contentMode: UIViewContentMode.scaleToFill)
        self.imgViewProfile.sd_setImage(with: URL(string: (image_mode as? String)!), placeholderImage: UIImage(named: "userProfile"))
        
        let first = nullToNil(value: decodedTeams.object(forKey: "first_name") as AnyObject)
        let last = nullToNil(value: decodedTeams.object(forKey: "last_name") as AnyObject)
        let strName = String(format: "%@ %@", (first as? String)!,(last as? String)!)
        self.nameLbl.text = strName
        self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.height/2
        self.imgViewProfile.clipsToBounds = true
        self.imgViewProfile.layer.masksToBounds = true
        
        let gender = nullToNil(value: decodedTeams.object(forKey: "gender") as AnyObject)
        let strGender = gender as! String
        if strGender == "Male"
        {
           genderLBl.text = "Male"
        }
        else  if strGender == ""
        {
            genderLBl.text = ""
        }
        else
        {
           genderLBl.text = "Female"
        }
        
 
        //Anamika
        imagePicker.delegate = self
        //imagePicker.delegate = self
        self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.height/2
        self.imgViewProfile.image = self.cropToBounds(image: self.imgViewProfile.image!, width: 100, height: 100)
        self.imgViewProfile.clipsToBounds = true
        self.imgViewProfile.layer.masksToBounds = true
        //self.btnProfileImageChange.layer.cornerRadius = self.imgViewProfile.frame.height/2
      self.getSubscribePlans()
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
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
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func getSubscribePlans()
    {
        
 
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            var url = String(format: "%@/subscriptionapi/v6/spackage/user_packages/token/%@device/ios/uid/%@",Constants.SubscriptionBaseUrl,Constants.APP_Token,strID)
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
                            if let _  = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list")
                            {
                                if(Common.isNotNull(object: (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as AnyObject))
                                {
                                    if(((dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as! NSArray).count>0) {
                                        self.UserpakeageSubscriptiondetail = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as! NSArray
                                        
                                       if(self.UserpakeageSubscriptiondetail.count>0)
                                       {
                                        self.setusersubscriptiondetail()
                                        }
                                    }
                                    else
                                    {
                                        self.UserpakeageSubscriptiondetail = NSArray()
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                    }
                }) { (task: URLSessionDataTask?, error: Error) in
                    print("POST fails with error \(error)")
                    self.UserpakeageSubscriptiondetail = NSArray()
                }
           
        }
        
        
        
        
        
//
//        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
//        {
//            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
//            let json = ["uid":strID]
//            //    print("subscribe json >>",json)
//            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
//            url = url.trimmingCharacters(in: .whitespaces)
//
//            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getProfilePackageList")
//        }
//        else
//        {
//            let json = ["device":"ios"]
//            // print("json >>",json)
//            //    print("subscribe json >>",json)
//            var url = String(format: "%@%@", LoginCredentials.Subscriptionapi,Constants.APP_Token)
//            url = url.trimmingCharacters(in: .whitespaces)
//
//            objWeb.getRequestAndGetResponse(urlString:url as NSString, param: json as NSDictionary, info:"getProfilePackageList")
//        }
  //  }
    
    
    
    
   func setusersubscriptiondetail()
   {
    
     let subscription_dict = self.UserpakeageSubscriptiondetail.object(at: 0) as! NSDictionary
    print(subscription_dict)
    if(subscription_dict.count>0)
    {
    
    self.subDateConstrain.constant = 1
    self.subDateLbl.isHidden = true
    self.subPlanLbl.isHidden = false
    self.dateOfSubLbl.isHidden = false
    self.subPlanMonthLbl.isHidden = false
    self.subExpLbl.isHidden = false
    self.subPlanMonthLbl.text =  subscription_dict.value(forKey: "description") as? String
    self.dateSubLbl.isHidden = false
    self.dateSubLbl.text = sub_Start as String
    self.subExpDetailLbl.isHidden = false
    self.subExpDetailLbl.text = sub_End as String
    self.successLbl.isHidden = false
    self.paymentLbl.isHidden = false
     var price =  ((subscription_dict.value(forKey: "price") as? NSString)?.integerValue)! as Int
      print(price+1)
       price = price + 1
        print("\("Successful")\(price)")
        self.successLbl.text = "\("Successful ")\(price)"
        self.dateSubLbl.text = (subscription_dict.value(forKey: "subscription_start") as? NSString as! String)
        self.subExpDetailLbl.text = (subscription_dict.value(forKey: "subscription_end") as? NSString as! String)
        
    }
    
    }

    @objc func getProfilePackageList(notification: NSNotification)
    {
        var responseDict:NSDictionary=NSDictionary()
        // print("notification>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        let subscribeDict=(responseDict.object(forKey:"result") as AnyObject) as! NSDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        // print("subscribeDict >>>>>>>>>>>",subscribeDict)
        let susubscription_mode = nullToNil(value: subscribeDict.object(forKey: "subscription_mode") as AnyObject)
        //  print("susubscription_mode >>",susubscription_mode)
        UserDefaults.standard.set(susubscription_mode as! String, forKey: "susubscription_mode")
        
        dictResponse = subscribeDict.mutableCopy() as! NSMutableDictionary
        //  print("subscribe list>>>",dictResponse)
        var arraySubscribe:NSArray=NSArray()
        arraySubscribe = (dictResponse.value(forKey: "subscription_list") as AnyObject) as! NSArray
        var arraySubscribed:NSArray=NSArray()
        arraySubscribed = (dictResponse.value(forKey: "subscribed_item") as AnyObject) as! NSArray
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.subscribedItemArrays = arraySubscribed.mutableCopy() as! NSMutableArray
        
        if arraySubscribed.count > 0 {
            let count = arraySubscribed.count as Int
            let dictSubcribed = arraySubscribed.object(at: count-1) as! NSDictionary
           packageIDS = nullToNil(value: dictSubcribed.object(forKey: "package_id") as AnyObject) as! NSString
            sub_Start = nullToNil(value: dictSubcribed.object(forKey: "subscription_start") as AnyObject) as! NSString
            if sub_Start == "" {
                
            }
            else
            {
                let datePublishedString = sub_Start as String
                let datePublishedFormatter = DateFormatter()
                datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                datePublishedFormatter.locale = NSLocale(localeIdentifier: self.localeStr as String) as Locale!
                let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
                datePublishedFormatter.dateFormat = "dd/MM/yyyy"
                let dateTimeFromPublishedString = datePublishedFormatter.string(from: dateFromPublishedString)
                let strFormat = dateTimeFromPublishedString                
                sub_Start = strFormat as NSString
            }
            
            sub_End = nullToNil(value: dictSubcribed.object(forKey: "subscription_end") as AnyObject) as! NSString
            if sub_End == "" {
                
            }
            else
            {
                let datePublishedEndString = sub_End as String
                let datePublishedEndFormatter = DateFormatter()
                datePublishedEndFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                datePublishedEndFormatter.locale = NSLocale(localeIdentifier: self.localeStr as String) as Locale!
                let dateFromPublishedEndString = datePublishedEndFormatter.date(from: datePublishedEndString)! as Date
                datePublishedEndFormatter.dateFormat = "dd/MM/yyyy"
                let dateTimeFromPublishedEndString = datePublishedEndFormatter.string(from: dateFromPublishedEndString)
                sub_End = dateTimeFromPublishedEndString as NSString
            }
            
            
            
//            let arrayEnd = sub_End.components(separatedBy: " ") as NSArray
//            if arrayEnd.count > 0 {
//                sub_End = arrayEnd.object(at: 0) as! NSString
//            }
            //sub_End = sub_End.replacingOccurrences(of: " 00:00:00", with: "") as NSString
        }
        else
        {
            packageIDS = ""
        }
        arrayPackage.removeAllObjects()
        for item in 0..<arraySubscribe.count
        {
            let subListDict = arraySubscribe.object(at: item) as! NSDictionary
            let tempDict:NSMutableDictionary=NSMutableDictionary()
            tempDict.setObject(subListDict.object(forKey: "s_id"), forKey: "s_id" as NSCopying)
            tempDict.setObject(subListDict.object(forKey: "s_name"), forKey: "s_name" as NSCopying)
            tempDict.setObject(subListDict.object(forKey: "s_subscription_validity"), forKey: "s_subscription_validity" as NSCopying)
            
            let arraySub = subListDict.object(forKey: "s_pakcage") as! NSArray
            for index in 0..<1 {
                //    print("212")
                let subListDict = arraySub.object(at: index) as! NSDictionary
                tempDict.setObject(subListDict.object(forKey: "circle"), forKey: "circle" as NSCopying)
                tempDict.setObject(subListDict.object(forKey: "end_date"), forKey: "end_date" as NSCopying)
                tempDict.setObject(subListDict.object(forKey: "p_currency"), forKey: "p_currency" as NSCopying)
                tempDict.setObject(subListDict.object(forKey: "p_name"), forKey: "p_name" as NSCopying)
                tempDict.setObject(subListDict.object(forKey: "p_price"), forKey: "p_price" as NSCopying)
                tempDict.setObject(subListDict.object(forKey: "package_id"), forKey: "package_id" as NSCopying)
                tempDict.setObject(subListDict.object(forKey: "start_date"), forKey: "start_date" as NSCopying)
                arrayPackage.add(tempDict)
            }
        }
        print("arrayPackage >>>",arrayPackage)
        
        if susubscription_mode as! String == "free"
        {
            subDateLbl.text = String(format:"Subscription - Free Trial %@ Days Left",subscribeDict.object(forKey: "free_days") as! String)
        }
        else
        {
            if arraySubscribed.count > 0
            {
                for item in 0..<arrayPackage.count
                {
                    // let strPackage = ((arrayPackage.object(at: item) as AnyObject).object(forKey: "package_id") as? String)!
                    let strPackage = nullToNil(value: (arrayPackage.object(at: item) as AnyObject).object(forKey: "package_id") as AnyObject) as? String
                    if packageIDS as String == ""
                    {
                       //subDateLbl.text = String(format:"Subscription Free Trail %@ Days Left",subscribeDict.object(forKey: "free_days") as! String)
                    }
                    else if packageIDS as String == strPackage
                    {
                        /*
                        subdatelbl first
                        subplanLbl hide false only
                        subplanmonthlbl (s_name)
                        dateofsublbl hide
                        datesubLbl start_date
                        subexplbl hide
                        subexpdetailbl end_date
                        orderlbl order lbl
                        success lbl successful (p_price)*/
                        self.subDateConstrain.constant = 1
                        self.subDateLbl.isHidden = true
                        self.subPlanLbl.isHidden = false
                        self.dateOfSubLbl.isHidden = false
                        self.subPlanMonthLbl.isHidden = false
                        self.subExpLbl.isHidden = false
                        self.subPlanMonthLbl.text = nullToNil(value: (arrayPackage.object(at: item) as AnyObject).object(forKey: "s_name") as AnyObject) as? String
                         self.dateSubLbl.isHidden = false
                        self.dateSubLbl.text = sub_Start as String//nullToNil(value: (arrayPackage.object(at: item) as AnyObject).object(forKey: "start_date") as AnyObject) as? String
                        self.subExpDetailLbl.isHidden = false
                        self.subExpDetailLbl.text = sub_End as String//nullToNil(value: (arrayPackage.object(at: item) as AnyObject).object(forKey: "end_date") as AnyObject) as? String
                        //self.orderIdLbl.isHidden = false
                        //self.orderLbl.isHidden = false
                        //self.orderLbl.text = nullToNil(value: (arrayPackage.object(at: item) as AnyObject).object(forKey: "s_id") as AnyObject) as? String
                        self.successLbl.isHidden = false
                        self.paymentLbl.isHidden = false
                      //  String(format: "Starting at: %@", dateTimeFromPublishedString)
                        
                     
                        
                        if(Common.isNotNull(object: (arrayPackage.object(at: item) as! NSDictionary).object(forKey: "p_price") as AnyObject?))
                        {
                            var price =  (((arrayPackage.object(at: item) as AnyObject).object(forKey: "p_price") as? NSString)?.integerValue)! as Int
                            print(price+1)
                            price = price + 1
                            print("\("Successful")\(price)")
                            self.successLbl.text = "\("Successful ")\(price)"
                         }
                        
                        
                        
                    }
                    else
                    {
                        
                    }
                }
            }
            else
            {
                
            }
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()//dob
         NotificationCenter.default.addObserver(self,selector: #selector(getProfilePackageList),name: NSNotification.Name(rawValue: "getProfilePackageList"),object: nil)
         NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionProfileLogin"),object: nil)
        AppUtility.lockOrientation(.portrait)
       
    }
    func afterSessionLogin()
    {
       // self.performSegue(withIdentifier: "profileLogin", sender: self)
        
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
    }
    
    @IBAction func btnSliderAction(_ sender: Any) {
       // let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
       // addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
       // view.addSubview(controller.view)
        
        self.performSegue(withIdentifier: "profileHomePush", sender: self)
        /*
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
 */
    }
    
    @IBAction func editButtonAction()
    {
        self.performSegue(withIdentifier: "editProfile", sender: self)
      //  let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        //self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    //Anamika
    @IBAction func  btnProfileImageChangeAction()
    {
        print("gjhbknlsdd")
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Imagepicker delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            
            self.imgViewProfile.image = pickedImage
            self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.height/2
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.masksToBounds = true
            
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
