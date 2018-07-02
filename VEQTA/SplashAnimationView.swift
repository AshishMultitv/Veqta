//
//  SplashAnimationView.swift
//  VEQTA
//
//  Created by Cybermac002 on 18/05/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class SplashAnimationView: UIView {
let loaderImage:UIImageView=UIImageView()
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
        
        
        loaderImage.frame = CGRect(x:0,y :0, width: self.frame.size.width, height: self.frame.size.height)
        loaderImage.animationImages=[UIImage(named: "1.png")!,UIImage(named: "2.png")!,UIImage(named: "3.png")!,UIImage(named: "4.png")!,UIImage(named: "5.png")!,UIImage(named: "6.png")!,UIImage(named: "7.png")!,UIImage(named: "8.png")!,UIImage(named: "9.png")!,UIImage(named: "10.png")!,UIImage(named: "11.png")!,UIImage(named: "12.png")!,UIImage(named: "13.png")!,UIImage(named: "14.png")!,UIImage(named: "15.png")!,UIImage(named: "16.png")!,UIImage(named: "17.png")!,UIImage(named: "18.png")!,UIImage(named: "19.png")!,UIImage(named: "20.png")!,UIImage(named: "21.png")!,UIImage(named: "22.png")!,UIImage(named: "23.png")!,UIImage(named: "24.png")!,UIImage(named: "25.png")!,UIImage(named: "26.png")!,UIImage(named: "27.png")!,UIImage(named: "28.png")!,UIImage(named: "29.png")!,UIImage(named: "30.png")!,UIImage(named: "31.png")!,UIImage(named: "32.png")!,UIImage(named: "33.png")!,UIImage(named: "34.png")!,UIImage(named: "35.png")!,UIImage(named: "36.png")!]
        loaderImage.animationDuration = 4.0
        self.addSubview(loaderImage)
        loaderImage.startAnimating()
        self.perform(#selector(animationDidFinish), with: nil, afterDelay: loaderImage.animationDuration)        //[self performSelector:@selector(animationDidFinish:) withObject:nil
        //afterDelay:instructions.animationDuration];
    }
    func animationDidFinish()  {
        loaderImage.stopAnimating()
    }
}
