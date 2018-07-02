//
//  SearchViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 26/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import Kingfisher
class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var suggestionTblView: UITableView!
    @IBOutlet var blurView: UIView!
    @IBOutlet var searchTblView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var category_ids:NSString!
    var bSearch:Bool = Bool()
    var bResultFound:Bool = Bool()
    var objLoader : LoaderView = LoaderView()
    var suggestionListArray:NSArray = NSArray()
    var contentListArray:NSMutableArray = NSMutableArray()
    var objWeb = AFNetworkingWebServices()
    var dictDetail:NSDictionary = NSDictionary()
    var arrayContentDetail:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchTblView!.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameCell")
        //getSearchSugestResponse
        
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionSearchLogin"),object: nil)
        searchBar.isTranslucent = true
        searchBar.alpha = 1
        suggestionTblView.layer.cornerRadius = 5
        suggestionTblView.layer.borderColor = UIColor.lightGray.cgColor
        suggestionTblView.layer.borderWidth = 1
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        // AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getSearchSugestResponse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getSearchResponse"), object: nil)
        //NotificationCenter.default.addObserver(self,selector: #selector(showBannerDetail),name: NSNotification.Name(rawValue: "showBannerSportsDetail"),object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionSearchLogin"
        NotificationCenter.default.addObserver(self,selector: #selector(getSearchSugestResponse),name: NSNotification.Name(rawValue: "getSearchSugestResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getSearchResponse),name: NSNotification.Name(rawValue: "getSearchResponse"),object: nil)
    }
    func afterSessionLogin()
    {
        //  self.performSegue(withIdentifier: "searchLogin", sender: self)
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // searchActive = true;
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        bSearch = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //self.tableView.reloadData()
        // DispatchQueue.global(qos: .background).async {
        if searchText.characters.count > 2
        {
            self.bSearch = true
            
            //    print("This is run on the background queue")
            if self.bResultFound == true
            {
                self.objWeb.cancelOperation()
            }
            else
            {
                if searchText.characters.count > 2
                {
                    self.bResultFound = true
                    self.suggestList()
                }
                else
                {
                    self.blurView.isHidden = true
                    self.suggestionTblView.isHidden = true
                }
            }
            
            //                DispatchQueue.main.async {
            //                //print("This is run on the main queue, after the previous code in outer block")
            //                }
            
            
        }
        else
        {
            
            self.blurView.isHidden = true
            self.suggestionTblView.isHidden = true
            //suggestionTblView.reloadData()
            // bSearch = false
        }
        // }
        
        if searchText.characters.count < 1 {
            self.perform(#selector(self.hideSearch), with: self, afterDelay: 1)
        }
    }
    
    func hideSearch()
    {
        self.blurView.isHidden = true
        self.suggestionTblView.isHidden = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        if(!Common.isEmptyOrWhitespace(testStr: searchBar.text!))
       {
        return
        }
        suggestionListArray = NSArray()
        contentListArray.removeAllObjects()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        bSearch = false
        self.call_cList()
    }
    func suggestList()  {
        
        let json = [:] as! [String:String]
        print("idArray>>>%@",json)
        var url = String(format: "%@%@/title/%@", LoginCredentials.Autosuggestapi,Constants.APP_SOCIAL_Token,searchBar.text! as String)
        print("url >>",url)
        url = url.trimmingCharacters(in: .whitespaces)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url >>",url)
      //  objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSearchSugestResponse" )
        objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSearchSugestResponse")
        
        bResultFound = true
        
    }
    @objc func getSearchSugestResponse(notification: NSNotification)
    {
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
        
        //        var arrayTempContent:NSArray=NSArray()
        suggestionListArray = (dictContent.value(forKey: "result") as AnyObject) as! NSArray
        print("suggestionListArray>>",suggestionListArray)
        if suggestionListArray.count < 5
        {
            print("contentListArray >>>")
            suggestionTblView.frame = CGRect(x:suggestionTblView.frame.origin.x,y:suggestionTblView.frame.origin.y,width:suggestionTblView.frame.size.width,height:CGFloat(suggestionListArray.count * 30))
        }
        else
        {
            suggestionTblView.frame = CGRect(x:suggestionTblView.frame.origin.x,y:suggestionTblView.frame.origin.y,width:suggestionTblView.frame.size.width,height:200)
        }
        if suggestionListArray.count > 0 {
            blurView.isHidden = false
            suggestionTblView.isHidden = false
            suggestionTblView.reloadData()
        }
        else
        {
            blurView.isHidden = true
            suggestionTblView.isHidden = true
            suggestionTblView.reloadData()
        }
        
        bResultFound = false
        //dictContent=responseDict.mutableCopy() as! NSMutableDictionary
    }
    //getSearchSugestResponse
    func call_cList()
    {
        
        if bSearch == true
        {
            
        }
        else
        {
            self.createLoader()
        }
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            
            //http://staging.multitvsolution.com:9001/automatorapi/v6/content/list/token/58cfdeb8438eb/device/ios/current_offset/10/max_counter/10/cat_id/1767
            
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as! [String:String]
            print("idArray>>>%@",json)
            var url = String(format: "%@%@device/ios/current_offset/0/max_counter/100/search_tag/%@/", LoginCredentials.Listapi,Constants.APP_Token,searchBar.text! as String)
            url = url.trimmingCharacters(in: .whitespaces)
            url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
         print(url)
             objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSearchResponse")
          //  objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSearchResponse" )
        }
        else
        {
            let json = [:] as! [String:String]
            print("idArray>>>%@",json)
            var url = String(format: "%@%@device/ios/current_offset/0/max_counter/100/search_tag/%@/", LoginCredentials.Listapi,Constants.APP_Token,searchBar.text! as String)
            url = url.trimmingCharacters(in: .whitespaces)
            url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
             objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSearchResponse")
        }
        bResultFound = true
    }
    @objc func getSearchResponse(notification: NSNotification)
    {
        if bSearch == true
        {
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
                let alert = UIAlertController(title: "Message", message: "No search record found.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }

        
        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        self.bResultFound = false
        print(dictContent)
        print(arrayTempContent)
        print("arrayTempContent >>>",arrayTempContent.count)
        
        if arrayTempContent.count > 0 {
            if bSearch == true
            {
                if arrayTempContent.count < 5
                {
                    print("contentListArray >>>")
                    suggestionTblView.frame = CGRect(x:suggestionTblView.frame.origin.x,y:suggestionTblView.frame.origin.y,width:suggestionTblView.frame.size.width,height:CGFloat(arrayTempContent.count * 30))
                }
                else
                {
                    suggestionTblView.frame = CGRect(x:suggestionTblView.frame.origin.x,y:suggestionTblView.frame.origin.y,width:suggestionTblView.frame.size.width,height:200)
                }
                blurView.isHidden = false
                suggestionListArray = arrayTempContent.mutableCopy() as! NSMutableArray
                suggestionTblView.isHidden = false
                suggestionTblView.reloadData()
            }
            else
            {
                blurView.isHidden = true
                contentListArray = arrayTempContent.mutableCopy() as! NSMutableArray
                suggestionTblView.isHidden = true
                searchTblView.reloadData()
            }
        }
        else
        {
            contentListArray.removeAllObjects()
            suggestionTblView.reloadData()
            searchTblView.reloadData()
            suggestionTblView.isHidden = true
            if bSearch == true
            {
            }
            else
            {
                let alert = UIAlertController(title: "Message", message: "No search record found.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        bResultFound = false
        // var arrayTempContent:NSArray=NSArray()
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if bSearch == true
        {
            return 30
        }
        else
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
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if bSearch == true
        {
            return suggestionListArray.count
        }
        else
        {
            return contentListArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if bSearch == true
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell")! as UITableViewCell
            //cell.backgroundColor  =  UIColor.clear
            // print("sddsdsds>>>>>>>%@",(suggestionListArray.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String)
            let headingLbl:UILabel = cell.viewWithTag(301)! as! UILabel
            headingLbl.text = suggestionListArray.object(at:indexPath.item) as? String
            
            return cell
        }
        else
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchViewCell")! as UITableViewCell
            //cell.backgroundColor  =  UIColor.clear
            //  print("print isss>>>",((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject))
            //print("print >>>",((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)
            let logoImgVw:UIImageView = cell.viewWithTag(101)! as! UIImageView
            // logoImgVw.image = nil
            
            
            if let val = ((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
            {
                
                
                if(Common.isNotNull(object: (contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs") as AnyObject))
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
            
            
            
            
           // let imgBaseUrl = (((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
         //   let imgThumbUrl = (((contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
            // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
            //let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
            // print("downloadUrl >>>",downloadUrl)
          //  let urlImg = URL(string:imgThumbUrl)
            
            
       //     logoImgVw.kf.setImage(with: urlImg,
        //                          placeholder: nil,
          //                        options: [.transition(ImageTransition.fade(1))],
           //                       progressBlock: { receivedSize, totalSize in
                                    // print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
         //   },
             //                     completionHandler: { image, error, cacheType, imageURL in
                                    //  print("\(indexPath.row + 1): Finished")
       //     })
            
            let headingLbl:UILabel = cell.viewWithTag(102)! as! UILabel
            headingLbl.text = (contentListArray.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "notload"
        if bSearch == true
        {
            searchBar.text = suggestionListArray.object(at:indexPath.item) as? String
            searchBar.resignFirstResponder()
            bSearch = false
            blurView.isHidden = true
            // contentListArray.removeAllObjects()
            // contentListArray.add(suggestionListArray.object(at: indexPath.row))
            suggestionTblView.isHidden = true
            searchTblView.reloadData()
            searchTblView.isHidden = false
            
            self.call_cList()
        }
        else
        {
            suggestionTblView.isHidden = true
            blurView.isHidden = true
            arrayContentDetail.removeAllObjects()
            for item in 0..<contentListArray.count {
                arrayContentDetail.add(contentListArray.object(at: item))
            }
            //arrayContentDetail.removeObject(at: indexPath.item)
            dictDetail = contentListArray.object(at:indexPath.item) as! NSDictionary
            let arrayCatId = dictDetail.object(forKey: "category_ids") as! NSArray
            print("dictDetail>>>",dictDetail)
            if arrayCatId.count>0 {
                category_ids = arrayCatId.object(at: 0) as! String as NSString!
            }
            else
            {
                category_ids = "1223789892389"
            }
            self.performSegue(withIdentifier: "searchDetail", sender: self)
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "searchDetail"
        {
            let vc = segue.destination as! DetailViewController
            vc.dictDetail = dictDetail
            vc.contentArray = arrayContentDetail
            vc.strCatID = category_ids
        }
        else if segue.identifier == "searchLogin"
        {
            
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @IBAction func searchBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func back_Btn_Action(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
