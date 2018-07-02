//
//  AppUtility.swift
//  VEQTA
//
//  Created by Cybermac002 on 13/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import Foundation
import UIKit

struct AppUtility {
    
    // This method will force you to use base on how you configure.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    // This method done pretty well where we can use this for best user experience.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}
