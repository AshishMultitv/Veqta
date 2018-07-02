//
//  PrivacyPolocyViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 31/08/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class PrivacyPolocyViewController: UIViewController {
@IBOutlet var mywebview: UIWebView!
    var objLoader : LoaderView = LoaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        mywebview.loadRequest(URLRequest(url: URL(string: LoginCredentials.Privactpolocyapi)!))


        // Do any additional setup after loading the view.
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        self.createLoader()
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.removeLoader()
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        self.removeLoader()
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
