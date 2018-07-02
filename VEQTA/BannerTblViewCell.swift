//
//  BannerTblViewCell.swift
//  Veqta
//
//  Created by Bijendra Singh Bhatia on 13/01/17.
//  Copyright © 2017 MacBook-10.8. All rights reserved.
//

import UIKit

class BannerTblViewCell: UITableViewCell,UIScrollViewDelegate
{
    @IBOutlet var bannerImgVw: UIImageView!
    var strType:NSString = NSString()
    @IBOutlet var alphaViews: UIView!
    //@IBOutlet var underLbl: UILabel!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    var dictBanner:NSDictionary = NSDictionary()
    @IBOutlet var placeHolderImgView: UIImageView!
    @IBOutlet weak var showSlider:UIScrollView!
    //var pageControl : UIPageControl
    // @IBOutlet var alphaView: UIView!
    var timer:Timer!
    var arrayBanner:NSMutableArray=NSMutableArray()
    var arrayDetailBanner:NSMutableArray=NSMutableArray()
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "scrolling"), object: nil)
        // NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "bannerArrayResponse"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(bannerArrayResponse),name: NSNotification.Name(rawValue: "bannerArrayResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(removeTimer),name: NSNotification.Name(rawValue: "removeTimer"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(scrolling),name: NSNotification.Name(rawValue: "scrolling"),object: nil)
        let decoded  = UserDefaults.standard.object(forKey: "BannerArray") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSMutableArray
        self.call_UI(bannerArray: decodedTeams)
    }
    func removeTimer()
    {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    func scrolling(notification: NSNotification)  {
        let pageIndex:Int = notification.object as! Int
        
        self.pageControl.currentPage = pageIndex
        
        let dictBanner = self.arrayBanner.object(at:pageIndex) as! NSDictionary
        
        
        let title = (dictBanner["title"] == nil || dictBanner["title"] is NSNull) ? nil : (dictBanner["title"]! as! String)
        
        if (title != nil)
        {
            headingLbl.text = dictBanner.value(forKey:"title") as? String
        }
    }
    func call_UI(bannerArray:NSMutableArray)
    {
        self.arrayBanner = bannerArray
        if self.arrayBanner.count > 0 {
            pageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
            headingLbl.text = (self.arrayBanner.object(at:0) as AnyObject).value(forKey:"title") as? String
            showSlider.subviews.forEach({ $0.removeFromSuperview() })
            showSlider.delegate = self
            let screenSize: CGRect = UIScreen.main.bounds
            for item in 0..<self.arrayBanner.count
            {
                let showImgView:UIImageView=UIImageView()
                if screenSize.width > 330 && screenSize.width < 380{
                    showImgView.frame=CGRect(origin: CGPoint(x: screenSize.width*CGFloat(item),y :0), size: CGSize(width: screenSize.width, height: 212))
                }
                else if screenSize.width > 380 {
                    showImgView.frame=CGRect(origin: CGPoint(x: screenSize.width*CGFloat(item),y :0), size: CGSize(width: screenSize.width, height: 232))
                }
                else
                {
                    showImgView.frame=CGRect(origin: CGPoint(x: screenSize.width*CGFloat(item),y :0), size: CGSize(width: screenSize.width, height: 180))
                }
                
                if let val = ((self.arrayBanner.object(at:item) as AnyObject).value(forKey:"thumbs"))
                {
                    
                    if(((self.arrayBanner.object(at:item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
                    {
                        let imgThumbUrl = ((((self.arrayBanner.object(at: item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                        
                    var imgUrlwithsplit = String()
                    if(imgThumbUrl.contains("jpg"))
                    {
                        let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                        imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthBanner)\("x")\(Constants.heightBanner)\(".jpg")"
                    }
                    else
                    {
                        let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                        imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthBanner)\("x")\(Constants.heightBanner)\(".png")"
                    }

                    
                    
                let urlImg = URL(string:imgUrlwithsplit)
                    showImgView.sd_setImage(with: urlImg)
                    
                }
                
                }
                
                
               // let imgBaseUrl = (((self.arrayBanner.object(at:item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
               // let imgThumbUrl = (((self.arrayBanner.object(at:item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
                // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
               // let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.heightBanner,Constants.qualityBanner,Constants.widthBanner,imgThumbUrl)
               // print("downloadUrl >>>",downloadUrl)
               // let urlImg = URL(string:imgThumbUrl)
               // showImgView.sd_setImage(with: urlImg)
                //showImgView.sd_setImage(with: URL(string: (((self.arrayBanner.object(at:item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!), placeholderImage: UIImage(named: ""))
                
                self.showSlider.addSubview(showImgView)
                
                let layer = CAGradientLayer()
                layer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
                layer.colors = [UIColor.clear.cgColor,UIColor.init(colorLiteralRed: 25.0/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0).cgColor]
                alphaViews.layer.addSublayer(layer)
                
                let clickBtn = UIButton()
                clickBtn.frame = CGRect(origin: CGPoint(x: screenSize.width*CGFloat(item),y :0), size: CGSize(width: screenSize.width, height: showSlider.frame.size.height))
                clickBtn.tag = item
                clickBtn.addTarget(self, action: #selector(sendDetailScreen), for: .touchUpInside)
                self.showSlider.addSubview(clickBtn)
                
               // let rect = CGRect(origin: CGPoint(x: 10,y :130), size: CGSize(width: 200, height: 20))
            }
            
            self.bringSubview(toFront: pageControl)
            
          //  let f = self.frame.size.width * CGFloat(self.arrayBanner.count)
            self.showSlider.contentSize=CGSize(width:screenSize.width * CGFloat(self.arrayBanner.count), height:showSlider.frame.size.height)
            self.sliderShow()
        }
        else
        {
            
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        let pageIndex = Int(currentPage)
        let dictBanner = self.arrayBanner.object(at:pageIndex) as! NSDictionary
        self.pageControl.currentPage = pageIndex
        let title = (dictBanner["title"] == nil || dictBanner["title"] is NSNull) ? nil : (dictBanner["title"]! as! String)
        
        
        if (title != nil)
        {
            
            headingLbl.text = dictBanner.value(forKey:"title") as? String
        }
    }
    
    func singleTapped() {
    }
    
    
    func sendDetailScreen(sender:UIButton)
    {
        arrayDetailBanner.removeAllObjects()
        for item in 0..<arrayBanner.count {
            arrayDetailBanner.add(arrayBanner.object(at: item))
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "notload"
        appDelegate.bannerDetailInfo = arrayBanner.object(at:sender.tag) as! NSDictionary
        if strType == "sportsBanner" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showBannerSportsDetail"), object: arrayDetailBanner)
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showBannerDetail"), object: arrayDetailBanner)
        }
        
    }
    @objc func bannerArrayResponse(notification: NSNotification)
    {
        
    }
    func sliderShow()
    {
        pageControl.numberOfPages = self.arrayBanner.count
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        timer=Timer.scheduledTimer(timeInterval: 5.00, target: self, selector: #selector(displayShow), userInfo: nil, repeats:true)
    }
    
    func displayShow()
    {
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        let contentOffset:CGFloat  = self.showSlider.contentOffset.x;
        let nextPage:Int  = (Int)(contentOffset/self.showSlider.frame.size.width) + 1 ;
        if nextPage != self.arrayBanner.count
        {
            let dictBanner = self.arrayBanner.object(at:nextPage) as! NSDictionary
           
            let title = (dictBanner["title"] == nil || dictBanner["title"] is NSNull) ? nil : (dictBanner["title"]! as! String)
            self.showSlider.scrollRectToVisible(CGRect.init(x:CGFloat(nextPage)*self.frame.size.width , y: 0, width: self.frame.size.width, height: self.showSlider.frame.size.height),animated: true)
            self.pageControl.currentPage = nextPage
            if (title != nil)
            {
               
                
            }
        }
        else
        {
            let dictBanner = self.arrayBanner.object(at:0) as! NSDictionary
        
            let title = (dictBanner["title"] == nil || dictBanner["title"] is NSNull) ? nil : (dictBanner["title"]! as! String)
            
            if (title != nil)
            {
            }
            
            
            
            
            
            self.showSlider.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.showSlider.frame.size.height), animated: true)
            self.pageControl.currentPage = 0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
