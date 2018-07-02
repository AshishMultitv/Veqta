//
//  ContactUsViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 17/05/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import REFrostedViewController
class ContactUsViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    //MARK:- View outlate
    @IBOutlet var Email_tx: UITextField!
    @IBOutlet var detail_txview: UITextView!
    @IBOutlet var Submitbutton: UIButton!
    var objLoader : LoaderView = LoaderView()
    var objWeb = AFNetworkingWebServices()
    
    //MARK:- View Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,selector: #selector(getContactUsResponse),name: NSNotification.Name(rawValue: "getContactUsResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionContactListLogin"),object: nil)
        detail_txview.layer.cornerRadius = 5.0
        detail_txview.layer.masksToBounds = true
        Submitbutton.layer.cornerRadius = 20.0
        Submitbutton.layer.masksToBounds = true
        
    }
    func afterSessionLogin()
    {
        // self.performSegue(withIdentifier: "profileLogin", sender: self)
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionContactListLogin"
        self.frostedViewController.panGestureEnabled = false
    }
    //MARK:- Textfiled delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    //MARK:- Textview delegate method
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "How may we help you?")
        {
            textView.text = ""
            
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    //MARK:- Menu button action
    @IBAction func sideMenuAction(_ sender: Any) {
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- EMail Validation
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- Submit button action
    @IBAction func Submitaction()
    {
        if !(Email_tx.text?.isEmptyOrWhitespace())! {
            showalert(str: "Please Enter Email")
        }
        else if !isValidEmail(testStr: Email_tx.text!) {
            showalert(str: "Please Enter Correct Email")
        }
        else if(!(detail_txview.text?.isEmptyOrWhitespace())! || (detail_txview.text == "How may we help you?"))
        {
            showalert(str: "Query can't be empty")
        }
        else
        {
            senddataonweb()
        }
        
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
    //MARK:- APi send
    func senddataonweb()
    {
        self.createLoader()
        let json = ["device":"ios","email":Email_tx.text! as String,"message":detail_txview.text! as String,"subject":"VEQTA" as String ]
        print("idArray>>>%@",json)
        var url = String(format: "%@%@", LoginCredentials.Contactusapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)

        objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getContactUsResponse" )
    }
    @objc func getContactUsResponse(notification: NSNotification)
    {
        self.removeLoader()
        var responseDict:NSDictionary=NSDictionary()
        responseDict=notification.object as! NSDictionary
        let resultCode = responseDict.object(forKey: "code") as! Int
        if resultCode == 1
        {
            print("notification >>>>>",notification.object)
            Email_tx.text = ""
            detail_txview.text = "How may we help you?"
            
            let alert = UIAlertController(title: "Message", message: "We have received your message and will get back to you shortly.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: "Oops! Something went wrong, please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    //MARK:- Make Alert
    func showalert(str:String)
    {
        let alert = UIAlertController(title: "Message", message: str, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
//MARK:- String Extension
extension String {
    func isEmptyOrWhitespace() -> Bool {
        return(!self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)
    }
}
