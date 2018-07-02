//
//  NewsListViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 30/03/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import SDWebImage
import Kingfisher
class NewsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var strCatID:NSString = NSString()
    var objWeb = AFNetworkingWebServices()
    var strHeading:NSString = NSString()
    var dictDetail:NSDictionary = NSDictionary()
    @IBOutlet var lblHeading: UILabel!
    var objWebService = WebService()
    var prvLoadCount:Int!
    var isNewDataLoading:Bool = Bool()
    var offSetStart:Int!
    var offSetEnd:Int!
    var strRedirect:NSString = NSString()
    var objLoader : LoaderView = LoaderView()
    
    
    var contentArray:NSMutableArray = NSMutableArray()
    var contentDetailArray:NSMutableArray = NSMutableArray()
    @IBOutlet var listTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        offSetStart = 0
        offSetEnd = 10
        self.frostedViewController.panGestureEnabled = false
        
        // Do any additional setup after loading the view.
        lblHeading.text = (strHeading as String).uppercased()
        lblHeading.adjustsFontSizeToFitWidth = true
        if strHeading == "Live"
        {
            listTblView.reloadData()
        }
        else
        {
            listTblView.reloadData()
        }
    }
    func afterSessionLogin()
    {
     //   self.performSegue(withIdentifier: "newsLogin", sender: self)
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
    }
    @IBAction func btn_search_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "newsSearchPush", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self,selector: #selector(get_Cat_List_Response),name: NSNotification.Name(rawValue: "getListDataResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionNewsLogin"),object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionNewsLogin"
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getListDataResponse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "afterSessionNewsLogin"), object: nil)
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
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // first parameter mean you will let user use again your customized orientation support. If the previous user screen is landscapeLeft, setting the second parameter to `.landscapeLeft ` will bring back to its previous landscape after disappear. This is really useful for best user experience.
//        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .landscapeLeft)
//        
//        // Thanks to you bmjohns
//    }
    func call_cList()
    {
         let strStart = String(offSetStart)
         let strEnd = String(offSetEnd)
        if offSetStart > 0
        {
           
        }
        else
        {
            self.createLoader()
        }
        
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as! [String:String]
            print("idArray>>>%@",json)
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getListDataResponse")
            
            // let json = ["device_unique_id":"dfsfdfd","device":"ios","display_offset":displayOffset,"display_limit":displayLimit,"content_count":"4","user_id":idStr]
        var url = String(format: "%@%@device/ios/current_offset/%@/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Constants.APP_Token,strStart,strCatID as String)
            url = url.trimmingCharacters(in: .whitespaces)
             print(url)
            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getListDataResponse")
        }
        else
        {
            let json = [:] as! [String:String]
            print("idArray>>>%@",json)
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getListDataResponse")
            
         //   http://staging.multitvsolution.com:9001/automatorapi/v6/content/list/token/58cfdeb8438eb/device/ios/current_offset/10/max_counter/10/cat_id/1767
            
            // let json = ["device_unique_id":"dfsfdfd","device":"ios","display_offset":displayOffset,"display_limit":displayLimit,"content_count":"4","user_id":idStr]
            var url = String(format: "%@%@device/ios/current_offset/%@/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Constants.APP_Token,strStart,strCatID as String)
            url = url.trimmingCharacters(in: .whitespaces)
           print(url)
            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getListDataResponse")
        }
    }
    @objc func get_Cat_List_Response(notification: NSNotification)
    {
       
        if offSetStart > 0 {
             self.listTblView.tableFooterView?.isHidden = true
        }
        else
        {
            self.removeLoader()
        }
       
        var responseDict:NSDictionary=NSDictionary()
        var dictContent:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictContent=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        
         if let _ = dictContent.object(forKey: "code")
        {
            if(dictContent.object(forKey: "code") as! Int == 0)
            {
                return
            }
            
        }
        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        if arrayTempContent.count > 0
        {
            self.contentArray.addObjects(from: arrayTempContent as [AnyObject])
            listTblView.reloadData()
            isNewDataLoading = false
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == listTblView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if isNewDataLoading == true
                {
                    
                }
                else
                {
                    isNewDataLoading = true
                    offSetStart = offSetStart + 10
                    offSetEnd = offSetEnd + 10
                    //  offSetEnd = offSetEnd + 10
                    self.call_cList()
                    self.listTblView.tableFooterView?.isHidden = false
                  //  self.listTblView.reloadData()
                    print("load more rows")
                }
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
            spinner.color = UIColor.red
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
            self.listTblView.tableFooterView = spinner
            self.listTblView.tableFooterView?.isHidden = true
            
        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contentArray.count
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "listViewCell")! as UITableViewCell
        let logoImgVw:UIImageView = cell.viewWithTag(101)! as! UIImageView
        
        let bgView:UIView = cell.viewWithTag(121)!
        bgView.layer.cornerRadius = 3
        let lblTime:UILabel = cell.viewWithTag(122)! as! UILabel
        var durationStr = String(format: "%@", ((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"duration") as? String!)!)
        let arrayTime = durationStr.components(separatedBy: ":") as NSArray
        if arrayTime.count > 0 {
            let strFirst = arrayTime.object(at: 0) as! String
            if strFirst == "00"
            {
                durationStr =  String(format: "%@:%@",arrayTime.object(at: 1) as! CVarArg,arrayTime.object(at: 2) as! CVarArg)
            }
            else
            {
                
            }
        }
        lblTime.text = durationStr
        
        
        
        
        if let val = ((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
        {
            if(Common.isNotNull(object: (contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs") as AnyObject))
            {
            if(((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
            {
               
             
                let imgThumbUrl = ((((contentArray.object(at: indexPath.item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
            
            
            var imgUrlwithsplit = String()
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
                else
            {
                logoImgVw.image = #imageLiteral(resourceName: "higlightPlaceHolder")
                }
        }
          else
            {
              logoImgVw.image = #imageLiteral(resourceName: "higlightPlaceHolder")
            }
        
        
        }
        
        
        
        
//        if self.view.frame.size.width > 330
//        {
//            logoImgVw.frame = CGRect(x: CGFloat(logoImgVw.frame.origin.x), y: CGFloat(logoImgVw.frame.origin.y), width: logoImgVw.frame.size.width, height: CGFloat(205))
//           // logoImgVw.frame = CGRect(x:logoImgVw.frame.origin.x,y:logoImgVw,width:logoImgVw.frame.size.width,height:205)
//        }
//        else
//        {
//             logoImgVw.frame = CGRect(x: CGFloat(logoImgVw.frame.origin.x), y: CGFloat(logoImgVw.frame.origin.y), width: logoImgVw.frame.size.width, height: CGFloat(175))
//        }
        
     //   let imgBaseUrl = (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
      //  let imgThumbUrl = (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
        // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
       // let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
       // print("downloadUrl >>>",downloadUrl)
      //  let urlImg = URL(string:imgThumbUrl)
        
       // let urlImg = URL(string: (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!)
        //  Nuke.loadImage(with: urlImg!, into:  highlightCell.imgLogo)
     //   logoImgVw.kf.setImage(with: urlImg,
      //                        placeholder: nil,
       //                       options: [.transition(ImageTransition.fade(1))],
       //                       progressBlock: { receivedSize, totalSize in
                               // print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
      //  },
       //                       completionHandler: { image, error, cacheType, imageURL in
                              //  print("\(indexPath.row + 1): Finished")
     //   })
        logoImgVw.kf.indicatorType = .activity
//        logoImgVw.sd_setImage(with: urlImg) { (image, error, imageCacheType, imageUrl) in
//            if image != nil {
//                print("image  found")
//                logoImgVw.image = image
//            }else
//            {
//                print("image not found")
//            }
//        }
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
       // logoImgVw.sd_setImage(with: URL(string: (((contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)!), placeholderImage: UIImage(named: ""))
        let headingLbl:UILabel = cell.viewWithTag(102)! as! UILabel
        headingLbl.text = (contentArray.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        cell.updateConstraintsIfNeeded()
        return cell
    }
    func loadMore()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "load"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        contentDetailArray.removeAllObjects()
        for item in 0..<contentArray.count {
            contentDetailArray.add(contentArray.object(at: item))
        }
        self.loadMore()
       // contentDetailArray.removeObject(at: indexPath.item)
        dictDetail = contentArray.object(at:indexPath.item) as! NSDictionary
        print("dictDetail news >>>",dictDetail)
        if strHeading == "Live"
        {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "showListDetail", sender: self)
            }
            else
            {
            
            }
        }
        else
        {
             self.performSegue(withIdentifier: "showListDetail", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showListDetail"
        {
            let vc = segue.destination as! DetailViewController
            vc.dictDetail = dictDetail
            vc.contentArray = contentDetailArray
            vc.strCatID = strCatID
        }
        else if segue.identifier == "newsSearchPush"
        {
            
        }
        else if segue.identifier == "newsLogin"
        {
            
        }
    }
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func back_Btn_Action(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning newslist")
     //   KingfisherManager.shared.cache.clearMemoryCache()
       // KingfisherManager.shared.cache.clearDiskCache()
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

