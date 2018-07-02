//
//  ForgotPwdViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 30/03/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AFNetworking

class ForgotPwdViewController: UIViewController {
    var objWeb = AFNetworkingWebServices()
    
    @IBOutlet var emailTxtFld: UITextField!
    @IBOutlet var submitBtn: UIButton!
     var objLoader : LoaderView = LoaderView()
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius=20
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,selector: #selector(getForgotResponse),name: NSNotification.Name(rawValue: "getForgotResponse"),object: nil)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
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
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    @IBAction func submit_Action(_ sender: Any)
    {
        
        
        
        emailTxtFld.resignFirstResponder()
        let strEmail = emailTxtFld.text! as String
        
        if(!Common.isValidEmail(testStr: strEmail))
        {
            let alert = UIAlertController(title: "Error", message: "Please enter valid email.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if strEmail != ""
        {
            self.createLoader()
            let json = ["email":strEmail as String,"device":"ios"]
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
                self.removeLoader()
                
            })
            
            
            
            // objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getForgotResponse" )
        }
    }
    @objc func getForgotResponse(notification: NSNotification)
    {
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        
        var dictResponse:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        print(responseDict)
        dictResponse=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        
        let resultCode = dictResponse.object(forKey: "code") as! Int
        if resultCode == 1
        {
            let alert = UIAlertController(title: "Message", message: dictResponse.object(forKey: "result") as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
        //    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           // self.dismiss(animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: dictResponse.object(forKey: "error") as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       // UserDefaults.standard.setValue(dictResponse.object(forKey: "id"), forKey: "loginData")
       // self.performSegue(withIdentifier: "getForgotResponse", sender: self)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // first parameter mean you will let user use again your customized orientation support. If the previous user screen is landscapeLeft, setting the second parameter to `.landscapeLeft ` will bring back to its previous landscape after disappear. This is really useful for best user experience.
//        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .landscapeLeft)
//        

//    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func back_btn_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
        // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
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
