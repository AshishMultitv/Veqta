//
//  LoaderView.swift
//  VEQTA
//
//  Created by Cybermac002 on 27/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func createLoader()
    {
        let bgView:UIView=UIView()
        bgView.backgroundColor=UIColor.black
        bgView.frame=CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        bgView.alpha = 0.40
        self.addSubview(bgView)
        
        let loaderImage:UIImageView=UIImageView()
        loaderImage.frame=CGRect(origin: CGPoint(x: (self.frame.size.width-50)/2,y :self.frame.size.height/2), size: CGSize(width: 50, height: 50))
        loaderImage.animationImages=[UIImage(named: "loader1.png")!,UIImage(named: "loader2.png")!,UIImage(named: "loader3.png")!,UIImage(named: "loader4.png")!,UIImage(named: "loader5.png")!,UIImage(named: "loader6.png")!,UIImage(named: "loader7.png")!,UIImage(named: "loader8.png")!]
        loaderImage.animationDuration = 1.0
        self.addSubview(loaderImage)
        loaderImage.startAnimating()
    }
}
