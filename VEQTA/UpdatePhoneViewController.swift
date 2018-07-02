//
//  UpdatePhoneViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 18/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class UpdatePhoneViewController: UIViewController {
    @IBOutlet var phoneTxtFld: UITextField!
    var objLoader : LoaderView = LoaderView()
    @IBOutlet var btnBack: UIButton!
    var strRedirectType:NSString = NSString()
    var objWeb = AFNetworkingWebServices()
    @IBOutlet var btnSubmit: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        phoneTxtFld.becomeFirstResponder()
        self.frostedViewController.panGestureEnabled = false
       NotificationCenter.default.addObserver(self,selector: #selector(getVerifyResponse),name: NSNotification.Name(rawValue: "getVerifyResponse"),object: nil)
        // Do any additional setup after loading the view.
        btnSubmit.layer.cornerRadius = 20
        if strRedirectType == "facebook"
        {
            btnBack.isHidden = true
        }
        else
        {
            btnBack.isHidden = false
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
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
    @IBAction func btn_Submit_Action(_ sender: Any) {
        
        let userID:Int = UserDefaults.standard.value(forKey: "UID") as! Int
        let strID = String(userID)
       // let otp = UserDefaults.standard.value(forKey: "OTP") as! Int
        let strNumber = phoneTxtFld.text! as String
        
        if strNumber != ""
        {
            if strNumber.characters.count == 10
            {
                 self.createLoader()
                let json = ["user_id":strID ,"type":"mobile","value":strNumber]
                print("json >>",json)
                var url = String(format: "%@%@", LoginCredentials.Otpgenerateapi,Constants.APP_Token)
                url = url.trimmingCharacters(in: .whitespaces)

                objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getVerifyResponse" )
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
            let alert = UIAlertController(title: "Message", message: "Please enter valid number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func getVerifyResponse(notification: NSNotification)
    {
         self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        print("verify otp>>>>",notification.object)
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictResponse=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        print("dictResponse otp >>>%@",dictResponse)
        let resultCode = dictResponse.object(forKey: "code") as! Int
        if resultCode == 1
        {
            phoneTxtFld.resignFirstResponder()
         //   UserDefaults.standard.setValue(dictResponse.object(forKey: "id"), forKey: "UID")
            UserDefaults.standard.setValue(dictResponse.object(forKey: "otp"), forKey: "OTP")
            // print("\(UserDefaults.standard.value(forKey: "user_auth_token")!)")
           // self.performSegue(withIdentifier: "showOtp", sender: self)
            //showSignUPHome
            if strRedirectType == "facebook"
            {
                self.performSegue(withIdentifier: "verifyOTPPush", sender: self)
            }
            else
            {
                _ = navigationController?.popViewController(animated: true)
            }
            
            

            
        }
        else
        {
         //   btnSignUp.isEnabled = true
            let alert = UIAlertController(title: "Message", message: dictResponse.object(forKey: "error") as! String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    @IBAction func back_btn_Action(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
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
