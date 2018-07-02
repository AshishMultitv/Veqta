//
//  LandingViewController.swift
//  VEQTA
//
//  Created by SSCyberlinks on 13/01/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import YSLContainerViewController
class LandingViewController: UIViewController,YSLContainerViewControllerDelegate {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden=true
        let homeViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.title  = "Home"
        let sportViewController = self.storyboard!.instantiateViewController(withIdentifier: "SportsViewController") as! SportsViewController
        sportViewController.title  = "Sports"
        
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
      // let navigationHeight = self.navigationController?.navigationBar.frame.size.height
        let containerVC = YSLContainerViewController(controllers: [homeViewController,sportViewController], topBarHeight: statusHeight + 24 , parentViewController: self)
        containerVC?.delegate = self
        containerVC?.menuItemFont = UIFont(name:"Ubuntu-Medium", size: 9)
        containerVC?.menuItemTitleColor = UIColor.white
        
        self.view.addSubview((containerVC?.view)!)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // first parameter mean you will let user use again your customized orientation support. If the previous user screen is landscapeLeft, setting the second parameter to `.landscapeLeft ` will bring back to its previous landscape after disappear. This is really useful for best user experience.
       // AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .landscapeLeft)
        
        // Thanks to you bmjohns
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func containerViewItemIndex(_ index: Int, currentController controller: UIViewController!)
    {
        controller.viewWillAppear(true)
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
