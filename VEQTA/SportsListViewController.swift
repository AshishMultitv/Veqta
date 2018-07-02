//
//  SportsListViewController.swift
//  VEQTA
//
//  Created by Cybermac002 on 11/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import SDWebImage
import Nuke
import Kingfisher
import CoreData
class SportsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSourcePrefetching {
    var detailContentArray:NSMutableArray = NSMutableArray()
    var cellBanner:BannerTblViewCell = BannerTblViewCell()
    var dictSports:NSDictionary = NSDictionary()
    var spinner:UIActivityIndicatorView!
    var arrayList:NSMutableArray = NSMutableArray()
    var contentArray:NSMutableArray = NSMutableArray()
    var featureArray:NSMutableArray = NSMutableArray()
    var homeListArray:NSArray = NSArray()
    var sendListCount:Int!
    var subCatIndexScroll:Int!
    var gameCell:GameTableViewCell = GameTableViewCell()
    var sportsBannerDetailDict:NSDictionary=NSDictionary()
    var idArray:NSMutableArray = NSMutableArray()
    var allkeyArray:NSMutableArray = NSMutableArray()
    var keysArray:NSMutableArray = NSMutableArray()
    var listArray:NSArray=NSArray()
    var offSetStart:Int!
    var strDetailType:NSString!
    var offSetEnd:Int!
    var startPoint:Int!
    var strMoreID:NSString!
    var objLoader : LoaderView = LoaderView()
    var sportsDetailDict:NSDictionary=NSDictionary()
    var sportsDetailArray:NSMutableArray=NSMutableArray()
    @IBOutlet var sportsListTblView: UITableView!
    var bLoadMore:Bool!
    var isNewDataNewsLoading:Bool = Bool()
    var isNewDataLoading:Bool = Bool()
    var strID:NSString!
    var strHeading:NSString!
    var sport_id:String!
    
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var sideMenuBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    var contentListArray:NSMutableArray = NSMutableArray()
    var objWeb = AFNetworkingWebServices()
    var idStr:NSString!
    
    var sportsDatabasedict: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        subCatIndexScroll = 200
        offSetStart = 2
        startPoint = 0
        headingLbl.adjustsFontSizeToFitWidth = true
        self.sportsListTblView.register(UINib(nibName: "BannerTblViewCell", bundle: nil), forCellReuseIdentifier: "bannerTblCell")
        self.sportsListTblView!.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameCell")
        self.sportsListTblView!.register(UINib(nibName: "HighlightTableViewCell", bundle: nil), forCellReuseIdentifier: "highlightTblCell")
        NotificationCenter.default.addObserver(self,selector: #selector(get_Sports_Response),name: NSNotification.Name(rawValue: "getSportsDataResponse"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(getSportsMoreDataResponse),name: NSNotification.Name(rawValue: "getSportsMoreDataResponse"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionSportsListLogin"),object: nil)
        
        let strBack = UserDefaults.standard.object(forKey: "sportsButton") as! String
        if strBack == "back"
        {
            
            sideMenuBtn.isHidden = true
            backBtn.isHidden = false
            self.frostedViewController.panGestureEnabled = false
        }
        else
        {
            sport_id = UserDefaults.standard.value(forKey: "sportsID") as! String
            self.frostedViewController.panGestureEnabled = false
            sideMenuBtn.isHidden = false
            backBtn.isHidden = true
        }
        let decoded  = UserDefaults.standard.object(forKey: "sportsDict") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        dictSports = decodedTeams
        headingLbl.text = (dictSports.value(forKey:"name") as? String)?.uppercased()
        
        self.getdatabaseresponse()
        //self.createSubChild()
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionSportsListLogin"
        NotificationCenter.default.addObserver(self,selector: #selector(showBannerDetail),name: NSNotification.Name(rawValue: "showBannerSportsDetail"),object: nil)
         self.sportsListTblView.tableFooterView = nil
         self.sportsListTblView.tableFooterView?.isHidden = false
         self.sportsListTblView.reloadData()
        
    }
    func afterSessionLogin()
    {
       // self.performSegue(withIdentifier: "sportsLogin", sender: self)
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
    }
    @IBAction func search_Sports_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "searchSportsPush", sender: self)
    }
    func createSubChild()
    {
        keysArray.removeAllObjects()
        arrayList.removeAllObjects()
        idArray.removeAllObjects()
        if offSetStart > 2 {
            
        }
        else
        {
            idStr = "012342323"
            allkeyArray.add("temp")
        }
        
        print(dictSports)
        var sportsArray:NSArray=NSArray()
        if let val = dictSports.value(forKey: "children")
        {
            sportsArray = dictSports.value(forKey: "children") as! NSArray
            let arraySubChild = sportsArray.mutableCopy() as! NSMutableArray
            for index in startPoint..<offSetStart {
                if index >= arraySubChild.count {
                    
                }
                else
                {
                    arrayList.add(arraySubChild.object(at: index))
                }
            }
            for item in 0..<arrayList.count
            {
                var itemArray:NSArray=NSArray()
                if let val = (arrayList.object(at: item) as AnyObject).object(forKey: "children")
                {
                    itemArray = (arrayList.object(at: item) as AnyObject).object(forKey: "children") as! NSArray
                    for index in 0..<itemArray.count
                    {
                        keysArray.add((itemArray.object(at:index) as AnyObject).value(forKey:"name") as! String)
                        let strId = (itemArray.object(at:index) as AnyObject).value(forKey:"id") as! String
                        idArray.add(strId)
                    }
                }
                else
                {
                    keysArray.add((arrayList.object(at:item) as AnyObject).value(forKey:"name") as! String)
                    let strId = (arrayList.object(at:item) as AnyObject).value(forKey:"id") as! String
                    idArray.add(strId)
                }
            }
        }
        else
        {
            keysArray.add(dictSports.value(forKey: "name") as! String)
            let strId = (dictSports.value(forKey: "name")) as! String
            idArray.adding(strId)
        }
        if keysArray.count>0
        {
            self.addIDForCategory()
        }
        else
        {
            self.sportsListTblView.tableFooterView?.isHidden = true
        }
        
    }
    func addIDForCategory()
    {
        idStr = "012342323"
        for item in 0..<offSetStart
        {
            if item >= idArray.count
            {
                
            }
            else
            {
                allkeyArray.add(keysArray.object(at: item))
                idStr = String(format:"%@,%@",idStr,idArray.object(at: item) as! CVarArg) as NSString!
            }
        }
        idStr = idStr.replacingOccurrences(of: "012342323,", with: "") as NSString!
        if keysArray.count>0
        {
            self.call_cList()
        }
        else
        {
            self.sportsListTblView.tableFooterView?.isHidden = true
        }
        
    }
    @IBAction func sideMenuAction(_ sender: Any)
    {
        self.view!.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "showBannerSportsDetail"), object: nil)
        //NotificationCenter.default.addObserver(self,selector: #selector(showBannerDetail),name: NSNotification.Name(rawValue: "showBannerSportsDetail"),object: nil)
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
    
    @IBAction func slideBackAction(_ sender: Any) {
        let strBack = UserDefaults.standard.object(forKey: "sportsButton") as! String
        if strBack == "back"
        {
            self.view!.endEditing(true)
            self.frostedViewController.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
           //  self.frostedViewController.presentMenuViewController()
        }
        else
        {
            self.view!.endEditing(true)
            self.frostedViewController.view.endEditing(true)
            self.frostedViewController.presentMenuViewController()
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @IBAction func logoBackBtn(_ sender: Any) {
        
    }
    func call_More_Clist(startInexing:String)
    {
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as! [String:String]
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getSportsMoreDataResponse")
            
            var url = String(format: "%@%@device/ios/current_offset/%@/max_counter/10/cat_id/%@/user_id/%@", LoginCredentials.Listapi,Constants.APP_Token,startInexing as String,strMoreID as String,strID)
            url = url.trimmingCharacters(in: .whitespaces)

            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSportsMoreDataResponse")
        }
        else
        {
            let json = [:] as! [String:String]
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getSportsMoreDataResponse")
            
        var url = String(format: "%@%@device/ios/current_offset/%@/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Constants.APP_Token,startInexing as String,strMoreID as String)
            url = url.trimmingCharacters(in: .whitespaces)

            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSportsMoreDataResponse")
        }
    }
    @objc func getSportsMoreDataResponse(notification: NSNotification)
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
        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        spinner.isHidden = true
        if arrayTempContent.count > 0
        {
            var homeReCat:NSMutableArray=NSMutableArray()
            homeReCat = arrayTempContent.mutableCopy() as! NSMutableArray
            isNewDataNewsLoading = false
            var temp:NSMutableArray=NSMutableArray()
            let key = allkeyArray.object(at:subCatIndexScroll) as! String
            
            let listArray:NSArray=(contentListArray.object(at:subCatIndexScroll) as AnyObject).object(forKey:key) as! NSArray
            temp  = NSKeyedUnarchiver.unarchiveObject(
                with: NSKeyedArchiver.archivedData(withRootObject: listArray)) as! NSMutableArray
            
            temp.addObjects(from: homeReCat as [AnyObject])
            
            let dictContent:NSMutableDictionary=NSMutableDictionary()
            dictContent.setObject(temp, forKey: key as NSCopying)
            
            self.contentListArray.removeObject(at: subCatIndexScroll)
            self.contentListArray.insert(dictContent, at: subCatIndexScroll)
            self.deleteAllData(entity: "SportData")
            savedataindatabase(dict: self.contentListArray)
            self.sportsListTblView.reloadData()
            gameCell.gameCollectionView.reloadData()
        }
        else
        {
        }
    }
    func call_cList()
    {
        
        if offSetStart > 2 {
            
        }
        else
        {
            self.createLoader()
        }
        
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = [:] as! [String:String]
              var url = String(format: "%@%@device/ios/current_offset/0/max_counter/10/cat_id/%@/user_id/%@", LoginCredentials.Listapi,Constants.APP_Token,idStr as String,strID)
            
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getSportsDataResponse")
            
            url = url.trimmingCharacters(in: .whitespaces)

            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSportsDataResponse")
        }
        else
        {
            let json = [:] as! [String:String]
            
        
            
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getSportsDataResponse")
            print("json >>>",json)
        var url = String(format: "%@%@device/ios/current_offset/0/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Constants.APP_Token,idStr as String)
             url = url.trimmingCharacters(in: .whitespaces)

            objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getSportsDataResponse")
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
        let headerView: UIView = scrollView.superview!
        if (scrollView.subviews[0] as? UICollectionViewCell != nil)
        {
            let bottomEdge:CGFloat = scrollView.contentOffset.x + scrollView.frame.size.width
            if (bottomEdge >= scrollView.contentSize.width) {
                let tableviewcell: GameTableViewCell = headerView.superview as! GameTableViewCell
                gameCell = tableviewcell
                let key = allkeyArray.object(at:tableviewcell.gameCollectionView.tag) as! String
                let listArray:NSArray=(contentListArray.object(at:tableviewcell.gameCollectionView.tag) as AnyObject).object(forKey:key) as! NSArray
                if subCatIndexScroll == tableviewcell.gameCollectionView.tag
                {
                    
                }
                else
                {
                    isNewDataNewsLoading = false
                }
                if isNewDataNewsLoading == true
                {
                    
                }
                else
                {
                    isNewDataNewsLoading = true
                    
                    let homeDetailDict = listArray.object(at:0) as! NSDictionary
                    
                    let cat_ID = nullToNil(value: homeDetailDict.object(forKey: "category_id") as AnyObject) as! NSString
                    if cat_ID == ""
                    {
                        let arrayID  = homeDetailDict.object(forKey: "category_ids") as! NSArray
                        if arrayID.count > 0 {
                            strMoreID = arrayID.object(at: 0) as! NSString
                        }
                    }
                    else
                    {
                        strMoreID  = homeDetailDict.object(forKey: "category_id") as! NSString!
                    }
                    
                    subCatIndexScroll = tableviewcell.gameCollectionView.tag
                    if featureArray.count>0
                    {
                    }
                    else
                    {
                        
                    }
                    spinner.isHidden = false
                    let count:Int = listArray.count
                    let strIndex = String(count)
                    self.call_More_Clist(startInexing: strIndex)
                }
            }
        }
        else
        {
            let xYsis:Int = Int(scrollView.frame.origin.x)
            let yXsis:Int = Int(scrollView.frame.origin.y)
            let height:Int = Int(scrollView.frame.size.height)
            if xYsis == 0 && yXsis == 0 && height == 220
            {
                let pageWidth:CGFloat = scrollView.frame.width
                let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
                // Change the indicator
                let Count = Int(currentPage)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrolling"), object: Count as Int)
            }
        }
        
        // Test the offset and calculate the current page after scrolling ends
        
        
    }
    @IBAction func back_Btn_Action(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @objc func get_Sports_Response(notification: NSNotification)
    {
        if offSetStart > 2 {
            self.sportsListTblView.tableFooterView?.isHidden = true
        }
        else
        {
            self.removeLoader()
        }
        var responseDict:NSDictionary=NSDictionary()
        var dictContent:NSMutableDictionary=NSMutableDictionary()
        
        responseDict=notification.object as! NSDictionary
        
        dictContent=responseDict.mutableCopy() as! NSMutableDictionary
        
        if let _ = dictContent.object(forKey: "code")
        {
            if(dictContent.object(forKey: "code") as! Int == 0)
            {
                return
            }
            
        }
        
        var arrayTempContent:NSArray=NSArray()
        arrayTempContent = (dictContent.value(forKey: "content") as AnyObject) as! NSArray
        self.contentArray.addObjects(from: arrayTempContent as [AnyObject])
        
        if isNewDataLoading == true {
            
        }
        else
        {
            var arrayTempFeature:NSArray=NSArray()
            arrayTempFeature = (dictContent.value(forKey: "feature") as AnyObject) as! NSArray
            featureArray=arrayTempFeature.mutableCopy() as! NSMutableArray
            let strKey = String(format: "feature%@", sport_id)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: featureArray)
            UserDefaults.standard.setValue(encodedData, forKey: strKey)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bannerArrayResponse"), object: featureArray)
        }
        var subCatArray:NSMutableArray=NSMutableArray()
        for item in 0..<arrayList.count
        {
            var itemArray:NSArray=NSArray()
            if let val = (arrayList.object(at: item) as AnyObject).object(forKey: "children")
            {
                itemArray = (arrayList.object(at: item) as AnyObject).object(forKey: "children") as! NSArray
                subCatArray = itemArray.mutableCopy() as! NSMutableArray
                for index in 0..<subCatArray.count
                {
                    let resultPredicate = NSPredicate(format: "SELF contains[c] %@", ((subCatArray.object(at: index) as AnyObject).object(forKey:"id") as? String)!)
                    let finalArray:NSMutableArray = NSMutableArray()
                    for containArray in contentArray
                    {
                        let arrResponse:NSArray!
                        
                        let arrRegion : NSArray = ((containArray as AnyObject).value(forKey: "category_ids")! as AnyObject) as! NSArray
                        arrResponse = arrRegion.filtered(using: resultPredicate) as NSArray!
                        if arrResponse.count > 0
                        {
                            finalArray.add(containArray)
                        }
                    }
                    let dictContent:NSMutableDictionary=NSMutableDictionary()
                    dictContent.setObject(finalArray, forKey: (subCatArray.object(at: index) as AnyObject).object(forKey: "name") as! NSCopying)
                    if finalArray.count > 0
                    {
                        contentListArray.add(dictContent.mutableCopy())
                    }
                    else
                    {
                        
                    }
                }
            }
            else
            {
                
                let resultPredicate = NSPredicate(format: "SELF contains[c] %@", ((arrayList.object(at: item) as AnyObject).object(forKey:"id") as? String)!)
                let finalArray:NSMutableArray = NSMutableArray()
                for containArray in contentArray
                {
                    let arrResponse:NSArray!
                    
                    let arrRegion : NSArray = ((containArray as AnyObject).value(forKey: "category_ids")! as AnyObject) as! NSArray
                    arrResponse = arrRegion.filtered(using: resultPredicate) as NSArray!
                    if arrResponse.count > 0
                    {
                        finalArray.add(containArray)
                    }
                }
                let dictContent:NSMutableDictionary=NSMutableDictionary()
                dictContent.setObject(finalArray, forKey: (arrayList.object(at: item) as AnyObject).object(forKey: "name") as! NSCopying)
                if finalArray.count > 0
                {
                    contentListArray.add(dictContent.mutableCopy())
                }
                else
                {
                    
                }
                
            }
            
        }
        if featureArray.count>0
        {
            if offSetStart > 2 {
                
            }
            else
            {
                let dictTempContent:NSMutableDictionary=NSMutableDictionary()
                dictTempContent.setObject("temp", forKey: "temp" as NSCopying)
                contentListArray.insert(dictTempContent, at: 0)
            }
            
        }
        else
        {
            if offSetStart > 2 {
                
            }
            else
            {
                allkeyArray.removeObject(at: 0)
            }
        }
        isNewDataLoading = false
        UserDefaults.standard.set(allkeyArray, forKey: sport_id)
        self.deleteAllData(entity: "SportData")
        self.savedataindatabase(dict: contentListArray)
        
        sportsListTblView.reloadData()
    }
    //TableView View Delegates and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1;
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return contentListArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = UITableViewCell()
        if featureArray.count>0
        {
            if(indexPath.section == 0)
            {
                var cell = tableView.dequeueReusableCell(withIdentifier: "bannerTblCell") as? BannerTblViewCell
                if cell == nil
                {
                    cell = BannerTblViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "bannerTblCell")
                }
                cell?.showSlider.delegate = self
                cell?.pageControl.currentPage = 0
                cell?.pageControl.tintColor = UIColor.red
                cell?.pageControl.pageIndicatorTintColor = UIColor.white
                cell?.pageControl.currentPageIndicatorTintColor = UIColor.red
                cell?.strType = "sportsBanner"
                let strKey = String(format: "feature%@", sport_id)
                let bannerDecode  = UserDefaults.standard.object(forKey: strKey) as! Data
                featureArray = NSKeyedUnarchiver.unarchiveObject(with: bannerDecode) as! NSMutableArray
                
                cell?.call_UI(bannerArray: featureArray)
                return cell!
            }
            else
            {
                let cells = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
                
                cells.gameCollectionView!.register(UINib(nibName: "GameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameCollectionViewCell")
                cells.gameCollectionView.tag = indexPath.section
                cells.gameCollectionView.delegate = self
                if #available(iOS 10.0, *) {
                    cells.gameCollectionView.prefetchDataSource = self
                } else {
                }
                cells.gameCollectionView.dataSource = self
                cells.gameCollectionView.reloadData()
                cell = cells
            }
        }
        else
        {
            let cells = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
            
            cells.gameCollectionView!.register(UINib(nibName: "GameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameCollectionViewCell")
            if #available(iOS 10.0, *) {
                cells.gameCollectionView.prefetchDataSource = self
            } else {
                // Fallback on earlier versions
            }
            cells.gameCollectionView.tag = indexPath.section
            cells.gameCollectionView.delegate = self
            cells.gameCollectionView.dataSource = self
            cells.gameCollectionView.reloadData()
            cell = cells
        }
        return cell
    }
    
    func loadMore()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.detailLoadMore = "load"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section==0)
        {
            if featureArray.count>0
            {
                return 1
            }
            else
            {
                return 30
            }
        }
        else
        {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var viewForHeader:UIView  =  UIView()
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 30))
        viewForHeader  =  UIView.init(frame: rect)
        
        var lblHeaderView:UILabel = UILabel()
        let rectLbl = CGRect(origin: CGPoint(x: 10,y :2), size: CGSize(width: self.view.frame.size.width-70, height: 40))
        lblHeaderView  =  UILabel.init(frame: rectLbl)
        lblHeaderView.text = (allkeyArray.object(at: section) as AnyObject).uppercased as String
        lblHeaderView.adjustsFontSizeToFitWidth = true
        lblHeaderView.font = UIFont (name: "Montserrat-Regular", size: 17)// UIFont (name: "Montserrat", size: 27)
        lblHeaderView.numberOfLines = 2
        lblHeaderView.textColor = UIColor.white
        viewForHeader.backgroundColor = UIColor.clear//(colorLiteralRed: 240.0, green: 241.0, blue: 241.0, alpha: 1.0)
        
        let moreBtn = UIButton()
        
        moreBtn.setTitle("SEE ALL>", for: .normal)
        
        moreBtn.titleLabel!.font =  UIFont.systemFont(ofSize: 10)//UIFont(name: "Montserrat", size: 10)
        moreBtn.setTitleColor(UIColor.lightText, for: .normal)
        moreBtn.tag=section
        
        moreBtn.addTarget(self, action: #selector(moreBtnAction), for: .touchUpInside)
        
        let rectMore = CGRect(origin: CGPoint(x: viewForHeader.frame.size.width-60,y :13), size: CGSize(width: 60, height: 25))
        moreBtn.frame = rectMore//CGRectMake(viewForHeader.frame.size.width-70, 5, 60, 20)
        if (section==0)
        {
            if featureArray.count>0
            {
            }
            else
            {
                viewForHeader.addSubview(moreBtn)
                viewForHeader.addSubview(lblHeaderView)
            }
        }
        else
        {
            viewForHeader.addSubview(moreBtn)
            viewForHeader.addSubview(lblHeaderView)
        }
        
        viewForHeader.backgroundColor=UIColor.clear
        return viewForHeader
    }
    @objc func showBannerDetail(notification: NSNotification)
    {
        detailContentArray = notification.object as! NSMutableArray
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        sportsBannerDetailDict = appDelegate.bannerDetailInfo
        print("sportsBannerDetailDict >>>",sportsBannerDetailDict)
        strDetailType = "banner"
        self.performSegue(withIdentifier: "sportsShowDetails", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 0)
        {
            if featureArray.count>0
            {
                if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                    return 260
                }
                else if self.view.frame.size.width > 330 {
                    return 280
                }
                else
                {
                    return 220
                }
                // return 220
            }
            else
            {
                if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                    return 260
                }
                else if self.view.frame.size.width > 380 {
                    return 270
                }
                else
                {
                    return 220
                }
                //return 220
            }
        }
        else
        {
            if self.view.frame.size.width > 330 && self.view.frame.size.width < 380{
                return 260
            }
            else if self.view.frame.size.width > 380 {
                return 270
            }
            else
            {
                return 220
            }
            // return 220
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width-40, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
            spinner.color = UIColor.red
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(cell.contentView.frame.size.width - 44), y: CGFloat(60), width: 44, height: CGFloat(44))
            cell.addSubview(spinner)
            spinner.isHidden = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let val = (contentListArray.object(at: collectionView.tag) as AnyObject).object(forKey:allkeyArray.object(at: collectionView.tag))
        {
            listArray=(contentListArray.object(at: collectionView.tag) as AnyObject).object(forKey:allkeyArray.object(at: collectionView.tag)) as! NSArray
        }
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if(tableView.indexPathsForVisibleRows?.index(of: indexPath) != nil)
        {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex
            {
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
    }
    func clearCell(cell:GameCollectionViewCell){
        if let iv = cell.imgLogo
        {
            iv.animationImages = nil
            iv.image = nil
            // iv.removeFromSuperview()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.loadMore()
        let key = allkeyArray.object(at:collectionView.tag) as! String
        homeListArray=(contentListArray.object(at:collectionView.tag) as AnyObject).object(forKey:key) as! NSArray
        sportsDetailArray = homeListArray.mutableCopy() as! NSMutableArray
        sportsDetailDict = homeListArray.object(at:indexPath.item) as! NSDictionary
        strDetailType = "sports"
        self.performSegue(withIdentifier: "sportsShowDetails", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    //Collection View Delegates and DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var detailDec:NSArray=NSArray()
        let key = allkeyArray.object(at:collectionView.tag) as! String
        if let val = (contentListArray.object(at:collectionView.tag) as AnyObject).object(forKey:key)
        {
            detailDec=(contentListArray.object(at:collectionView.tag) as AnyObject).object(forKey:key) as! NSArray
        }
        if detailDec.count>0 {
            let highlightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
           // let strUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnail")! as AnyObject).object(forKey:"large") as? String)
            let strTitle = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String)!
            var durationStr = String(format: "%@", ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"duration") as? String)!)
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
            highlightCell.lblTime.text = durationStr
            //let urlImg = URL(string:strUrl!)
            
            
            
            if let val = ((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs"))
            {
                if(Common.isNotNull(object: (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs") as AnyObject))
                {
                if(((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumbs")! as! NSArray).count > 0)
                {
                    let imgThumbUrl = ((((detailDec.object(at: indexPath.item) as AnyObject).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                
                
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
                highlightCell.imgLogo.image = nil
                highlightCell.imgLogo.kf.setImage(with: urlImg,
                                      placeholder: nil,
                                      options: [.transition(ImageTransition.fade(1))],
                                      progressBlock: { receivedSize, totalSize in
                },
                                      completionHandler: { image, error, cacheType, imageURL in
                })
            }
                else
                {
                    highlightCell.imgLogo.image = #imageLiteral(resourceName: "higlightPlaceHolder")
                    }
            }
                else
                {
                    highlightCell.imgLogo.image = #imageLiteral(resourceName: "higlightPlaceHolder")
                }
                
 
            }
            else
            {
               highlightCell.imgLogo.image = #imageLiteral(resourceName: "higlightPlaceHolder")
            }
            
            
            
         //   let imgBaseUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"base_path") as? String)!
     //       let imgThumbUrl = (((detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"thumb_url")! as AnyObject).object(forKey:"thumb_path") as? String)!
            // http://res.cloudinary.com/multitv-solution/image/upload/c_scale,h_270,q_50,w_480/v1488437769/app-images/upload/thumbs/589d6fdf2e68d.jpg
         //   let downloadUrl = String(format: "%@c_scale,h_%@,q_%@,w_%@/%@",imgBaseUrl,Constants.height,Constants.quality,Constants.width,imgThumbUrl)
           // print("downloadUrl >>>",downloadUrl)
     //       let urlImg = URL(string:imgThumbUrl)
            
          //  highlightCell.imgLogo.image = nil
       //     highlightCell.imgLogo.kf.setImage(with: urlImg,
        //                                      placeholder: nil,
         //                                     options: [.transition(ImageTransition.fade(1))],
       //                                       progressBlock: { receivedSize, totalSize in
        //    },
         //                                     completionHandler: { image, error, cacheType, imageURL in
       //     })
            highlightCell.imgLogo.kf.indicatorType = .activity
            
            
            highlightCell.lblTitle.text = (detailDec.object(at:indexPath.item) as AnyObject).value(forKey:"title") as? String
            return highlightCell
        }
        else
        {
            let highlightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
            return highlightCell
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        let headerView: UIView = scrollView.superview!
        if (scrollView.subviews[0] as? UICollectionViewCell != nil)
        {
            
        }
        else
        {
            if scrollView == sportsListTblView{
                
                if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
                {
                    if isNewDataLoading == true
                    {
                        self.sportsListTblView.tableFooterView?.isHidden = true
                    }
                    else
                    {
                        isNewDataLoading = true
                        offSetStart = offSetStart + 2
                        startPoint = startPoint + 2
                        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
                        spinner.color = UIColor.red
                        spinner.startAnimating()
                        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width:self.sportsListTblView.bounds.width, height: CGFloat(44))
                        self.sportsListTblView.tableFooterView = spinner
                        self.sportsListTblView.tableFooterView?.isHidden = false
                        self.createSubChild()
                        self.sportsListTblView.reloadData()
                        
                    }
                }
            }
        }
        
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    func cropToSportsBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "sportsShowDetails"
        {
            let vc = segue.destination as! DetailViewController
            if strDetailType == "banner" {
                vc.contentArray = detailContentArray
                vc.dictDetail = sportsBannerDetailDict
                let arrayIds = sportsBannerDetailDict.object(forKey: "category_ids") as! NSArray
                vc.strCatID = arrayIds.object(at: 0) as! NSString
            }
            else
            {
                vc.dictDetail = sportsDetailDict
                vc.contentArray = sportsDetailArray
                let arrayIds = sportsDetailDict.object(forKey: "category_ids") as! NSArray
                vc.strCatID = arrayIds.object(at: 0) as! NSString
            }
        }
        else if segue.identifier == "sportsLogin"
        {
            
        }
        else if segue.identifier == "searchSportsPush"
        {
            
        }
        else
        {
            let vc = segue.destination as! NewsListViewController
            vc.strCatID = strID
            vc.strHeading = strHeading
            vc.contentArray = sportsDetailArray
            vc.prvLoadCount = sendListCount
        }
    }
    func moreBtnAction(sender:UIButton)
    {
        //showSportsNews
        let key = allkeyArray.object(at:sender.tag) as! String
        let showArray=(contentListArray.object(at:sender.tag) as AnyObject).object(forKey:key) as! NSArray
        sportsDetailArray = showArray.mutableCopy() as! NSMutableArray
        sendListCount = showArray.count
        let homeDetailDict = showArray.object(at:0) as! NSDictionary
        let arrayID  = homeDetailDict.object(forKey: "category_ids") as! NSArray
        if arrayID.count > 0 {
            strID = arrayID.object(at: 0) as! NSString
        }
        else
        {
            strID = "32232323"
        }
        strHeading = key as NSString!
        strDetailType = "news"
        self.performSegue(withIdentifier: "showSportsNews", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Save data in database
    
    func savedataindatabase(dict: NSMutableArray)
    {
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(dict, forKey: "dictpropertyinmanagedobject")
        archiver.finishEncoding()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "SportData",
                                                    in: managedContext)!
            
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data, forKeyPath: "datadict")
            person.setValue(sport_id, forKeyPath: "id")
            
            do {
                try managedContext.save()
                sportsDatabasedict.append(person)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    // MARK: - Getdatabaseresponse
    
    
    func getdatabaseresponse()
    {
        // self.deleteAllData(entity: "SportData")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SportData")
            
            do {
                
                
                let predicate = NSPredicate(format: "(id = %@)", sport_id)
                fetchRequest.predicate = predicate
                sportsDatabasedict = try managedContext.fetch(fetchRequest)
                
                if (sportsDatabasedict.count>0)
                {
                    
                    let person = sportsDatabasedict[0]
                    
                    let data = person.value(forKeyPath: "datadict") as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    let sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject") as! NSMutableArray
                    
                    let strKey = String(format: "feature%@", sport_id)
                    let bannerDecode  = UserDefaults.standard.object(forKey: strKey) as! Data
                    
                    featureArray = NSKeyedUnarchiver.unarchiveObject(with: bannerDecode) as! NSMutableArray
                    
                    allkeyArray = (UserDefaults.standard.value(forKey: sport_id) as! NSArray).mutableCopy() as! NSMutableArray
                    contentListArray.removeAllObjects()
                    contentListArray = sportsDatabasedictnew
                    if featureArray.count > 0 {
                        startPoint = contentListArray.count - 3
                        offSetStart = contentListArray.count - 1
                    }
                    else
                    {
                        startPoint = contentListArray.count - 2
                        offSetStart = contentListArray.count
                    }
                    sportsListTblView.reloadData()
                    
                    
                }
                else
                {
                    self.createSubChild()
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        }
        else
        {
        }
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let predicate = NSPredicate(format: "(id = %@)", sport_id)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
            }
            
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}
