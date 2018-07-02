//
//  FavViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 27/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import REFrostedViewController
import AFNetworking


class FavViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var favTblView: UITableView!
    var category_ids:NSString!
    var contentListArray:NSMutableArray = NSMutableArray()
    var objWeb = AFNetworkingWebServices()
    var objLoader : LoaderView = LoaderView()
    var dictDetail:NSDictionary = NSDictionary()
    var arrayContentDetail:NSMutableArray = NSMutableArray()
    @IBOutlet var noFavLbl: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.frostedViewController.panGestureEnabled = true
        NotificationCenter.default.addObserver(self,selector: #selector(getFavListResponse),name: NSNotification.Name(rawValue: "getFavListResponse"),object: nil)
         self.favTblView!.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameCell")
         NotificationCenter.default.addObserver(self,selector: #selector(getFavRemoveResponse),name: NSNotification.Name(rawValue: "getFavRemoveResponse"),object: nil)
         NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionFavLogin"),object: nil)
        // Do any additional setup after loading the view.
        //You have not selected any videos as your favourite. Start creating your favourite video list by pressing on the 'thumbs up' icon on the video player
       
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionFavLogin"
         self.fav_List()
    }
    func afterSessionLogin()
    {
        //self.performSegue(withIdentifier: "favLogin", sender: self)
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func createLoader()
    {
        
        if self.objLoader != nil {
            self.objLoader.removeFromSuperview()
        }
        self.objLoader.frame=CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.objLoader.createLoader()
        UIApplication.shared.delegate!.window!?.addSubview(self.objLoader)
        UIApplication.shared.delegate!.window!?.bringSubview(toFront:self.objLoader)
    }
    func removeLoader() {
        self.objLoader.removeFromSuperview()
    }
    func remove_Fav_List()
    {
       /*  let strID = UserDefaults.standard.value(forKey: "loginData") as? String
        let json = ["device":"ios","user_id":strID! as String as String,"type":"video","content_id":contentId! as String,"favorite":"0","content_type":"video"]
        let url = String(format: "%@content/favorite/token/%@", Constants.API,Constants.APP_Token)
        objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getFavRemoveResponse" )*/
    }
    @objc func getFavRemoveResponse(notification: NSNotification)
    {
        self.removeLoader()
        self.fav_List()
       /*
        var responseDict:NSDictionary=NSDictionary()
        responseDict=notification.object as! NSDictionary
        let response = responseDict.object(forKey: "code") as! Int
        if response == 1
        {
            let result = responseDict.object(forKey: "result") as! Int
            if result == 1
            {
                let img = UIImage(named: "likeActive")
                btnLike.setImage(img, for: UIControlState.normal)
                
                let alert = UIAlertController(title: "Message", message: "Added to 'My Favorites.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let img = UIImage(named: "likeInactive")
                btnLike.setImage(img, for: UIControlState.normal)
                let alert = UIAlertController(title: "Message", message: "Removed to 'My Favorites.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Message", message: responseDict.object(forKey: "error") as! String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print("like Resopnse >>>",responseDict)
 */
    }
    
    
    //////Ashish Change
    
    func fav_List()
    {
        print(UserDefaults.standard.value(forKey: "loginData") as? String)
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            self.createLoader()
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as! [String:String]
            print("idArray>>>%@",json)
            
 
          var url = String(format: "%@%@device/ios/current_offset/0/type/favorite/user_id/%@/max_counter/20", LoginCredentials.Userrelatedapi,Constants.APP_Token,strID as String)
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
           objWeb.getRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info: "getFavListResponse")
       //   objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getFavListResponse" )
        }
        else
        {
            //You have not selected any videos as your favourite. Start creating your favourite video list by pressing on the 'thumbs up' icon on the video player
            let alert = UIAlertController(title: "Message", message: "Please login first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func getFavListResponse(notification: NSNotification)
    {
        self.removeLoader()
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
        arrayTempContent = ((dictContent.value(forKey: "result") as! NSDictionary).value(forKey: "content") as! AnyObject) as! NSArray
        contentListArray = arrayTempContent.mutableCopy() as! NSMutableArray
        print("favList >>>",contentListArray)
        favTblView.reloadData()
        if contentListArray.count > 0 {
            noFavLbl.isHidden = true
        }
        else
        {
            noFavLbl.isHidden = false
//            let alert = UIAlertController(title: "Message", message: "You have not selected any videos as your favourite. Start creating your favourite video list by pressing on the 'thumbs up' icon on the video player", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
        
        // var arrayTempContent:NSArray=NSArray()
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
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contentListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "favViewCell")! as UITableViewCell
        //cell.backgroundColor  =  UIColor.clear
      //  print("print isss>>>",((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject))
     //   print("print >>>",((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)
        let logoImgVw:UIImageView = cell.viewWithTag(101)! as! UIImageView
        logoImgVw.image = nil
        
        let bgView:UIView = cell.viewWithTag(121)!
        bgView.layer.cornerRadius = 3
        let lblTime:UILabel = cell.viewWithTag(122)! as! UILabel
        let durationStr = String(format: "%@", ((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"duration") as? String!)!)
        lblTime.text = durationStr
        
        if let val = ((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
        {
            if(((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
            {
                let imgThumbUrl = ((((contentListArray.object(at: indexPath.item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
            
            
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
            
            
            logoImgVw.downloadFrom(link: imgUrlwithsplit, contentMode: UIViewContentMode.scaleToFill)
        }
        
        }
        
       // let imgBaseUrl = (((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
        //let imgThumbUrl = (((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
        // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
        //let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.heightDetail,Constants.qualityBanner,Constants.widthDetail,imgThumbUrl)
       // print("downloadUrl >>>",downloadUrl)
      //  let urlImg = URL(string:downloadUrl)
      //  logoImgVw.downloadFrom(link: imgThumbUrl, contentMode: UIViewContentMode.scaleToFill)
       // logoImgVw.downloadFrom(link: ((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String, contentMode: UIViewContentMode.scaleToFill)
        let headingLbl:UILabel = cell.viewWithTag(102)! as! UILabel
        headingLbl.text = (contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
        let crossdBtn:UIButton = cell.viewWithTag(103)! as! UIButton
       // let crossBtn = UIButton()
        crossdBtn.isHidden = false
       // crossdBtn.tag = indexPath.row
        //crossBtn.frame = crossdBtn.frame
        crossdBtn.addTarget(self, action: #selector(crossBtnAction), for: .touchUpInside)
       // cell.addSubview(crossBtn)
        return cell
    }
    
    
    
    //////Ashish Change
    
    func crossBtnAction(sender:UIButton)
    {
        self.createLoader()
        let buttonPosition = sender.convert(CGPoint.zero, to: self.favTblView)
        var indexPath: IndexPath? = self.favTblView.indexPathForRow(at: buttonPosition)
       
        let detailFav = contentListArray.object(at:(indexPath?.row)!) as! NSDictionary
        print("detailFav ???",detailFav)
         let contentId = detailFav.object(forKey: "id") as? String
        let strID = UserDefaults.standard.value(forKey: "loginData") as? String
        let json = ["device":"ios","user_id":strID! as String as String,"type":"video","content_id":contentId! as String,"favorite":"0","content_type":"video"]
        print("json >>>",json)
        var url = String(format: "%@%@", LoginCredentials.Favrioutapi,Constants.APP_Token)
        url = url.trimmingCharacters(in: .whitespaces)
        
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getFavRemoveResponse"), object: dict)
 
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
      //   objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getFavRemoveResponse" )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        arrayContentDetail.removeAllObjects()
        for item in 0..<contentListArray.count {
            arrayContentDetail.add(contentListArray.object(at: item))
        }
      //  arrayContentDetail.removeObject(at: indexPath.item)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "notload"
        dictDetail = contentListArray.object(at:indexPath.item) as! NSDictionary
        let arrayCatId = dictDetail.object(forKey: "category_ids") as! NSArray
        print("dictDetail in fav>>>",dictDetail)
        if arrayCatId.count>0 {
            category_ids = arrayCatId.object(at: 0) as! String as NSString!
        }
        else
        {
            category_ids = "1223789892389"
        }
        self.performSegue(withIdentifier: "showFavDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showFavDetail"
        {
            let vc = segue.destination as! DetailViewController
            vc.dictDetail = dictDetail
            vc.contentArray = arrayContentDetail
            vc.strCatID = category_ids
        }
        else if segue.identifier == "favLogin"
        {
            
        }
    }
    @IBAction func sideAction(_ sender: Any) {
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    @IBAction func sideMenuAction(_ sender: Any) {
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }

    override func didReceiveMemoryWarning() {
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
