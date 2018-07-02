//
//  Common.swift
//  Eschool
//
//  Created by Desk28 on 03/08/15.
//  Copyright (c) 2015 Shree Ram. All rights reserved.
//

import UIKit
import CryptoSwift
import Foundation
import SystemConfiguration
import ReachabilitySwift
import CoreTelephony



var timer:Timer!


class Common: NSObject {
    
    
    static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    static func setvideoplayeronview(testStr:UIView) {
        // println("validate calendar: \(testStr)")
        
        
    }
    
    
    static func startlivebuffertime()
    {
        if timer != nil
        {
            timer.invalidate()
            timer  = nil
        }
       timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countlivebuffertime), userInfo: nil, repeats: true);
        
    }
   
    static func countlivebuffertime()
    {
      LoginCredentials.Livebuffertime = LoginCredentials.Livebuffertime + 1
        print("\("Live Buffer Time == ")\(LoginCredentials.Livebuffertime)")
    }
    static func stoplivebuffertime()
    {
        if timer != nil
        {
            timer.invalidate()
            timer  = nil
        }
 
    }
    static func callheartBeatapi()
    { 
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callheartbeatapi"), object: nil)
    }
    
    
    static func ActivateUsersession()
    {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "activateusersession"), object: nil)
    }
    static func DeActivateUsersession()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deactivateusersession"), object: nil)
    }
    static func isuserlogin() -> Bool
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            return true
        }
        else
        {
            return false
        }
    }
    static func isInternetAvailable() -> Bool
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
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    static func isEmptyOrWhitespace(testStr:String) -> Bool {
        
        let str = testStr.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        // let str = testStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if(testStr.isEmpty || str.isEmpty) {
            return false
        }
        else
        {
            return true
        }
        
        //return (testStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
    
   static func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    
    
    static func isNotNull(object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
    static func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    static func isNotStringNull(object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }
    
    
    static func gatedateheder(testStr:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: testStr)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date!)
        return result
        
    }
    
    
   static func getCurrentTimeStampWOMiliseconds() -> Int64 {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let date = Date()
        let strTime: String = objDateformat.string(from: date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return milliseconds
    }
    
    
    
    
   
    static func genrateOauthkeykeyforplayerurl(key:String,url:String) -> String
    {
        var Oauthurl = String()
         //var currentTimeInseconds = Int(Date().timeIntervalSince1970)
       //var currentTimeInseconds = getCurrentTimeStampWOMiliseconds()
      //  print(currentTimeInseconds)
        print(Int(Date().timeIntervalSince1970))
      let currentTimeInseconds = Int(Date().timeIntervalSince1970)
        //let baseurllengh = Constants.SECUREBASEURL.characters.count
        let baseurllengh =  0

        let authenticateTokenInterval = currentTimeInseconds + 24 * 60 * 60
        let streamExpiery = currentTimeInseconds + 24 * 60 * 60
        var md5string = ""
        md5string = md5string.md5()
        if(url.contains("?"))
        {
           Oauthurl = ""
        }
        else
        {
          Oauthurl = ""
        }
         print(Oauthurl)
        return Oauthurl
    }
    
    static func makewhitplaceholderintextview(textview:UITextView,string:String)
    {
        textview.text = string
        textview.textColor = UIColor.lightGray
    }
    
    static func Endtextviewplaceholder(textview:UITextView)
    {
        textview.text = nil
        textview.textColor = UIColor.black
    }
    
    
    
    
    
    static func decodedresponsedata(msg:String)-> NSMutableDictionary
    {
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  msg.aesDecrypt(key: keyString)
        let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
        return jsonObject.mutableCopy() as! NSMutableDictionary
        
    }
    
    static func decodedresponseheartbeat(msg:String)-> String
    {
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  msg.aesDecrypt(key: keyString)
        //  let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! String
        return encode
        
    }
    
    
    
    static func makewhitplaceholder(textfiled:UITextField,string:String)
    {
        textfiled.attributedPlaceholder = NSAttributedString(string:string,
                                                             attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
    
    
    static func Isphonevalid(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    
    
    static func convertdictinyijasondata(data:NSDictionary) -> String
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data,options: [])
             let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return otherDetailString
        }
        catch{
            
        }
        return ""
    }
    
    
   static func getModelname()->String
   {
    let divice = UIDevice()
    return divice.modelName
    }
    
    static func getnetworktype()->String
        
    {
         let reachability = Reachability()!
       print(reachability.description)
         
        
        if(!reachability.isReachable)
        {
            return ""
            
        }
        
        if(reachability.isReachableViaWiFi)
        {
            return "WiFi"
        }
            
            
        else
        {
    
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.currentRadioAccessTechnology
            switch carrierType{
            case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?:
                return "2G"
            case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?:
                return "3G"
            case CTRadioAccessTechnologyLTE?:
                return "4G"
            default: return ""
            }
  
        }
        return ""
    }
    
    
    static func getRounduiview(view: UIView, radius:CGFloat) {
        view.layer.cornerRadius = radius;
        view.clipsToBounds=true
    }
    static func getRoundImage(imageView: UIImageView, radius:CGFloat) {
        imageView.layer.cornerRadius = radius;
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
    }
    
    static func getRounduibutton(button: UIButton, radius:CGFloat) {
        button.layer.cornerRadius = radius;
        button.clipsToBounds = true
        button.layer.masksToBounds = true
    }
    
    static func getRoundLabel(label: UILabel,borderwidth:CGFloat) {
        label.layer.cornerRadius = borderwidth
        label.clipsToBounds = true
        label.layer.masksToBounds = true
    }
    
    
    static func setuiviewdborderwidth(View: UIView, borderwidth:CGFloat) {
        View.layer.borderColor=UIColor.gray.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
    
    
    static func settextfieldborderwidth(textfield: UITextField, borderwidth:CGFloat) {
        textfield.layer.borderColor=UIColor.gray.cgColor
        textfield.layer.borderWidth=borderwidth
        textfield.clipsToBounds=true
    }
    
    
    static func settextviewborderwidth(textview: UITextView, borderwidth:CGFloat) {
        textview.layer.borderColor=UIColor.gray.cgColor
        textview.layer.borderWidth=borderwidth
        textview.clipsToBounds=true
    }
    
    
    static func setbuttonborderwidth(button: UIButton, borderwidth:CGFloat) {
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=borderwidth
        button.clipsToBounds=true
    }
    
    
    
    static func setlebelborderwidth(label: UILabel, borderwidth:CGFloat) {
        label.layer.borderColor=UIColor.gray.cgColor
        label.layer.borderWidth=borderwidth
        label.clipsToBounds=true
    }
    
    static func Isuserissubscribe(Userdetails:AnyObject) -> Bool {
 
        if(LoginCredentials.UserSubscriptiondetail.count>0) {
            print(LoginCredentials.UserSubscriptiondetail)
            for i in 0..<LoginCredentials.UserSubscriptiondetail.count {
                let issubcribed = ((LoginCredentials.UserSubscriptiondetail.object(at: i) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
                if(issubcribed == "1") {
                    return true
                }
            }
            
            return false
        }
        else {
            return false
            
        }
        
    }
    
    static func Showdefaultalert(view:UIViewController,text:String)
    {
        let alert = UIAlertController(title: "Veqta", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
         view.present(alert, animated: true, completion: nil)
        
    }
}
