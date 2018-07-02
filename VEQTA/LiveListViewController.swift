//
//  LiveListViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 19/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import Kingfisher
class LiveListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var strCatID:NSString = NSString()
    var localeStr:NSString = NSString()
    var objWeb = AFNetworkingWebServices()
    var strHeading:NSString = NSString()
    var dictDetail:NSDictionary = NSDictionary()
    var strRedirect:NSString = NSString()
    var liveContentIDStr:NSString = NSString()
    var livePlayerUrl:URL!
    var Secure_url = String()
    var contentArray:NSMutableArray = NSMutableArray()
    @IBOutlet var listTblView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionLiveListLogin"),object: nil)
        self.frostedViewController.panGestureEnabled = false
        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden : Bool
    {
        return true
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionLiveListLogin"
        AppUtility.lockOrientation(.portrait)
    }
    func afterSessionLogin()
    {
        self.performSegue(withIdentifier: "liveLogin", sender: self)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.portrait)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellUpcoming")! as UITableViewCell
        //cell.backgroundColor  =  UIColor.clear
        let logoImgVw:UIImageView = cell.viewWithTag(101)! as! UIImageView
     //   logoImgVw.downloadFrom(link: ((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String, contentMode: UIViewContentMode.scaleToFill)
       //  let urlImg = URL(string: (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!)
        
        
        logoImgVw.image = #imageLiteral(resourceName: "thumbnailPlaceHolder")
        if let val = ((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail"))
        {
        
            if(Common.isNotNull(object: (contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail") as AnyObject))
            {
        if(((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as! NSDictionary).count > 0)
        {
            
            let imgThumbUrl = ((contentArray.object(at: indexPath.item) as AnyObject).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
            
            var imgUrlwithsplit = String()
            
            if(Common.isEmptyOrWhitespace(testStr: imgThumbUrl))
            {
            
            if(imgThumbUrl.contains("jpg"))
            {
                let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".jpg")"
            }
            else
            {
                let imgUrlwithsplitarry = imgThumbUrl.components(separatedBy: ".jpg").filter {!$0.isEmpty}
                imgUrlwithsplit = "\(imgUrlwithsplitarry[0])\("_")\(Constants.widthOther)\("x")\(Constants.heightOther)\(".png")"
            }
            
            
            
            let urlImg = URL(string:imgUrlwithsplit)
            logoImgVw.kf.setImage(with: urlImg,
                                                placeholder: nil,
                                                options: [.transition(ImageTransition.fade(1))],
                                                progressBlock: { receivedSize, totalSize in
            },
                                                completionHandler: { image, error, cacheType, imageURL in
            })
        }
            }
        }
        }
        
        
        
        
      //  let imgBaseUrl = (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
       // let imgThumbUrl = (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
        // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
       // let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.heightDetail,Constants.qualityBanner,Constants.widthDetail,imgThumbUrl)
       // print("downloadUrl >>>",downloadUrl)
      //  let urlImg = URL(string:imgThumbUrl)
        
     //   logoImgVw.kf.setImage(with: urlImg,
       //                                     placeholder: nil,
     //                                       options: [.transition(ImageTransition.fade(1))],
     //                                       progressBlock: { receivedSize, totalSize in
     //   },
     //                                       completionHandler: { image, error, cacheType, imageURL in
     //   })
        let headingLbl:UILabel = cell.viewWithTag(102)! as! UILabel
        headingLbl.text = (contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        let statusLbl:UILabel = cell.viewWithTag(103)! as! UILabel
        let dateLbl:UILabel = cell.viewWithTag(104)! as! UILabel
        let timeView:UIView = cell.viewWithTag(105)! 
        let statusView:UIView = cell.viewWithTag(106)!
        timeView.layer.cornerRadius = 3
        
        statusView.layer.cornerRadius = 3
        statusView.layer.borderWidth = 2
        statusView.layer.borderColor = UIColor.red.cgColor
        
//        if indexPath.row == 0 || indexPath.row == 1
//        {
            dictDetail = contentArray.object(at:indexPath.item) as! NSDictionary
            let dateString = dictDetail.value(forKey:"current_date") as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateFormatter.locale = NSLocale(localeIdentifier: localeStr as String) as Locale!
            let dateFromString = dateFormatter.date(from: dateString)! as Date
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateTimeFromString = dateFormatter.string(from: dateFromString)
            print("Crash >>>")
            let datePublishedString = dictDetail.value(forKey:"publish_date") as! String
            let datePublishedFormatter = DateFormatter()
            datePublishedFormatter.locale = NSLocale(localeIdentifier: localeStr as String) as Locale!
            datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
            datePublishedFormatter.dateFormat = "yyyy-MM-dd"
            let dateTimeFromPublishedString = datePublishedFormatter.string(from: dateFromPublishedString)
            let status = dictDetail.value(forKey:"status") as! String
            print("status app >>",status)
            if status == "1" {
                statusLbl.text = "Live"
            }
            else
            {
                 statusLbl.text = "Upcoming"
            }
              /*  if dateTimeFromString == dateTimeFromPublishedString
                {
                    if dateFromString == dateFromPublishedString || dateFromString > dateFromPublishedString
                    {
                        statusLbl.text = "Live"
                       // self.performSegue(withIdentifier: "showUpcomingDetail", sender: self)
                    }
                    else if dateFromString < dateFromPublishedString
                    {
                        statusLbl.text = "Upcoming"
                    }
                    
                }
                else if dateTimeFromString > dateTimeFromPublishedString
                {
                    statusLbl.text = "Upcoming"
                }
                else if dateTimeFromString < dateTimeFromPublishedString
                {
                    statusLbl.text = "Upcoming"
                }
            */
            
            dateLbl.text = (contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"publish_date") as? String

       // }
//        else
//        {
//            statusLbl.text = "Upcoming"
//            dateLbl.text = (contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"publish_date") as? String
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if self.view.frame.size.width > 330 && self.view.frame.size.width < 385
        {
            return 250
        }
        else  if self.view.frame.size.width > 385
        {
            return 270
        }
        else
        {
            return 220
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        dictDetail = contentArray.object(at:indexPath.item) as! NSDictionary
        strCatID = "04043034"
        self.loadMore()
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print("countryCode",countryCode)
            localeStr = countryCode as NSString
        }
        else
        {
            localeStr = "us"
        }
        
      //  var detailDec:NSArray=NSArray()
        
        print("dictDetail>>>",dictDetail)
        let dateString = dictDetail.value(forKey:"current_date") as! String
        //   print("dateString >>>",(detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"current_date") as! String)
        let dateFormatter = DateFormatter()
        //  print("dateString >>>",dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateFormatter.locale = NSLocale(localeIdentifier: localeStr as String) as Locale!
        let dateFromString = dateFormatter.date(from: dateString)! as Date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateTimeFromString = dateFormatter.string(from: dateFromString)
        
        let datePublishedString = dictDetail.value(forKey:"publish_date") as! String
        let datePublishedFormatter = DateFormatter()
        datePublishedFormatter.locale = NSLocale(localeIdentifier: localeStr as String) as Locale!
        datePublishedFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromPublishedString = datePublishedFormatter.date(from: datePublishedString)! as Date
        datePublishedFormatter.dateFormat = "yyyy-MM-dd"
        let dateTimeFromPublishedString = datePublishedFormatter.string(from: dateFromPublishedString)
      
            let status = dictDetail.value(forKey:"status") as! String
            print("status app >>",status)
            if status == "1" {
                livePlayerUrl = URL(string: dictDetail.value(forKey:"url") as! String)
                liveContentIDStr = dictDetail.value(forKey: "id") as! NSString
                 // self.performSegue(withIdentifier: "showUpcomingDetail", sender: self)
                self.performSegue(withIdentifier: "liveShowPlayerPush", sender: self)
            }
            else
            {
                
            }
           
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showUpcomingDetail"
        {
            let vc = segue.destination as! DetailViewController
            vc.dictDetail = dictDetail
            vc.strCatID = strCatID
        }
        else if segue.identifier == "liveShowPlayerPush"
        {
            let vc = segue.destination as! LivePlayerViewController
            vc.livePlayerUrl = livePlayerUrl
            vc.Secure_url = ""
            vc.strLiveContentID = liveContentIDStr
        }
        else if segue.identifier == "liveLogin"
        {
        
        }
    }
    func loadMore()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "notload"
    }
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func back_Action(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
   
    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning livelist")
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
