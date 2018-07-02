//
//  PaytmView.swift
//  VEQTA
//
//  Created by Cybermac002 on 18/08/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AFNetworking

class PaytmView: UIViewController,PGTransactionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
//    
//    func show(_ controller: PGTransactionViewController) {
//        if navigationController != nil {
//            navigationController?.pushViewController((controller as? UIViewController)! , animated: true)
//        }
//        else {
//            present((controller as? UIViewController)! , animated: true, completion: {() -> Void in
//            })
//        }
//    }
//    
//    func remove(_ controller: PGTransactionViewController) {
//        if navigationController != nil {
//            navigationController?.popViewController(animated: true)
//        }
//        else {
//            controller.dismiss(animated: true, completion: {() -> Void in
//            })
//        }
//    }
//    
    
    
    
    func genratechechsum(view:UIView,viewcontroller:UIViewController)
    {
        
        
            
            var orderDict = [String: String]()
            orderDict["MID"] = "Ideali05824300807373"
            orderDict["ORDER_ID"] = "TestMerchant000111008"
            orderDict["CUST_ID"] = "1234567890"
            orderDict["INDUSTRY_TYPE_ID"] = "Retail"
            orderDict["CHANNEL_ID"] = "WAP"
            orderDict["TXN_AMOUNT"] = "1"
            orderDict["WEBSITE"] = "APP_STAGING"
            orderDict["CALLBACK_URL"] = "https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp"
            
            let url = "http://api.multitvsolution.com/automatorapi/v4/paytm/generateChecksum"
            let manager = AFHTTPSessionManager()
            
            manager.post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                     }
                    else
                    {
                        
                        
                        print(dict)
                        
                                          }
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
            
        }
   
    
   
    
    
    func callpaytm(view:UIView,viewcontroller:UIViewController)
    {
        let mc = PGMerchantConfiguration.default()
        // mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
        //mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        var orderDict = [AnyHashable: Any]()
        orderDict["MID"] = "Ideali05824300807373"
        orderDict["ORDER_ID"] = "TestMerchant000111008"
        orderDict["CUST_ID"] = "1234567890"
        orderDict["INDUSTRY_TYPE_ID"] = "Retail"
        orderDict["CHANNEL_ID"] = "WAP"
        orderDict["TXN_AMOUNT"] = "1"
        orderDict["WEBSITE"] = "APP_STAGING"
        orderDict["CALLBACK_URL"] = "https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp"
        orderDict["CHECKSUMHASH"] = "LzX70J3VBbNkFJXaiHo5CE4iz5NJRTXtidUddhUPg4E+O01+EuH+puymoxr6F2WFPdx1w4avY3tTl0KokxJj5SYE525pqAUO8Ir24cto="
      
        
        
        let order = PGOrder(params: orderDict)
        PGServerEnvironment.selectServerDialog(self.view, completionHandler: {(_ eServerTypeProduction: ServerType) -> Void in
            
            let txnController = PGTransactionViewController.init(transactionFor: order)
            //txnController.merchant = [PGMerchantConfiguration defaultConfiguration];
            txnController?.serverType = eServerTypeProduction
            txnController?.merchant = mc
            txnController?.delegate = self
            txnController?.loggingEnabled = true
            viewcontroller.show(txnController!, sender: nil)
            //self.show(txnController!)
        })
        
  
    }
    
    func PayWithpaytm(view:UIView,viewcontroller:UIViewController)
    {
 self.callpaytm(view: view, viewcontroller: viewcontroller)
   //   self.genratechechsum(view: view, viewcontroller: viewcontroller)
        
        
    }
    // MARK: PGTransactionViewController delegate
    
   func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
        print("ViewController::didFinishedResponse:response = %@", responseString)
      //  let title: String = "Response"
      //  UIAlertView(title: title, message: responseString.description, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
        
        //remove(controller)
    }
    
//    func didCancelTransaction(_ controller: PGTransactionViewController, error: Error?, response: [AnyHashable: Any]) {
//        print("ViewController::didCancelTransaction error = %@ response= %@", error, response)
//        var msg: String? = nil
//        if error == nil {
//            msg = "Successful"
//        }
//        else {
//            msg = "UnSuccessful"
//        }
//        UIAlertView(title: "Transaction Cancel", message: msg!, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
//        
//        
//       // remove(controller)
//    }
//    
 
    func didFinishCASTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        print("ViewController::didFinishCASTransaction:response = %@", response)
    }
    func didCancelTrasaction(_ controller: PGTransactionViewController!) {
        
    }
     func errorMisssingParameter(_ controller: PGTransactionViewController!, error: Error!) {
        print(error.localizedDescription)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
}
