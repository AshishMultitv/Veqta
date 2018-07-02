//
//  NoInternetViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 04/08/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    @IBOutlet var retrybutton: UIButton!
    @IBOutlet var cloasebutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Taptocloase(_ sender: UIButton) {
    }
    @IBAction func Taptoretry(_ sender: UIButton) {
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
