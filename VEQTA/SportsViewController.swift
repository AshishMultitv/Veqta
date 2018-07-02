//
//  SportsViewController.swift
//  VEQTA
//
//  Created by SSCyberlinks on 13/01/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import SDWebImage
class SportsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet var sportsTblView: UITableView!
    var strTitle:NSString = NSString()
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var sportCollectionView: UICollectionView!
    var sportsDetailDict:NSDictionary = NSDictionary()
    var objWeb = AFNetworkingWebServices()
    var objLoader : LoaderView = LoaderView()
    var strType:NSString = NSString()
    var arrayContent:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frostedViewController.panGestureEnabled = false
        // self.sportsTblView!.register(UINib(nibName: "SportsViewTableViewCell", bundle: nil), forCellReuseIdentifier: "SportsViewCell")
        NotificationCenter.default.addObserver(self,selector: #selector(getsportsShowResponse),name: NSNotification.Name(rawValue: "getsportsShowResponse"),object: nil)
        // Do any additional setup after loading the view.
        lblTitle.text = strType.uppercased
        sportCollectionView.reloadData()
        NotificationCenter.default.addObserver(self,selector: #selector(afterSessionLogin),name: NSNotification.Name(rawValue: "afterSessionSportsLogin"),object: nil)
        //self.get_CatList()
    }
    func afterSessionLogin()
    {//listSportsLogin
       // self.performSegue(withIdentifier: "listSportsLogin", sender: self)
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        addChildViewController(controller)
        // controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.strRedirstNotify = "afterSessionSportsLogin"
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    func createLoader()
    {
        self.objLoader.frame=CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        self.objLoader.createLoader()
        UIApplication.shared.delegate!.window!?.addSubview(self.objLoader)
        UIApplication.shared.delegate!.window!?.bringSubview(toFront:self.objLoader)
    }
    func removeLoader()
    {
        self.objLoader.removeFromSuperview()
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func get_CatList()
    {
        self.createLoader()
        if UserDefaults.standard.value(forKey: "loginData") as? String != nil
        {
            let strID = UserDefaults.standard.value(forKey: "loginData") as! String
            let json = ["device_unique_id":"dfsfdfd","device":"ios","display_offset":"0","display_limit":"20","content_count":"20","user_id":strID]
            print("json >>",json)
            var url = String(format: "%@%@", LoginCredentials.catlistapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)

            self.objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getsportsShowResponse" )
           // objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getsportsShowResponse" )
        }
        else
        {
            let json = ["device_unique_id":"dfsfdfd","device":"ios","display_offset":"0","display_limit":"20","content_count":"20","user_id":"0"]
            print("json >>",json)
            var url = String(format: "%@%@", LoginCredentials.catlistapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)

            self.objWeb.getRequestAndHeartResponse(urlString: url as NSString, param: json as NSDictionary, info:"getsportsShowResponse" )
            //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info:"getsportsShowResponse" )
        }
    }
    @objc func getsportsShowResponse(notification: NSNotification)
    {
        var responseDict:NSDictionary=NSDictionary()
        self.removeLoader()
        var dictHome:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictHome=responseDict.mutableCopy() as! NSMutableDictionary// as! NSMutableDictionary//as! NSMutableDictionary
        var arrayVod:NSArray=NSArray()
        arrayVod = (dictHome.value(forKey: "vod") as AnyObject) as! NSArray
        var arraySports:NSArray=NSArray()
        if arrayVod.count > 0
        {
            if let val = ((dictHome.value(forKey: "vod") as AnyObject).object(at: 0) as AnyObject).object(forKey: "children")
            {
                arraySports = ((dictHome.value(forKey: "vod") as AnyObject).object(at: 0) as AnyObject).object(forKey: "children") as! NSArray
                if strType == "sports" {
                    arrayContent = arraySports.mutableCopy() as! NSMutableArray
                }
                else
                {
                    
                }
            }
        }
        
        if arrayVod.count > 1
        {
            var arrayShows:NSArray=NSArray()
            if let val = ((dictHome.value(forKey: "vod") as AnyObject).object(at: 1) as AnyObject).object(forKey: "children")
            {
                arrayShows = ((dictHome.value(forKey: "vod") as AnyObject).object(at: 1) as AnyObject).object(forKey: "children") as! NSArray
                if strType == "shows" {
                    arrayContent = arrayShows.mutableCopy() as! NSMutableArray
                }
                else
                {
                    
                }
            }
        }
        
        sportCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TableView View Delegates and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1;
    }
    
    @IBAction func logo_Back_btn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SportsViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SportsViewCell") as! SportsViewTableViewCell
        cell.sportsCollectionCell!.register(UINib(nibName: "SportsViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SportsViewCollectionViewCell")
        cell.sportsCollectionCell.tag = 100
        cell.sportsCollectionCell.delegate = self
        cell.sportsCollectionCell.dataSource = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let screenSize = self.view.frame.size.width
        
        if screenSize < 330
        {
            return 200
        }
        else  if screenSize < 385
        {
            return 240
        }
        else
        {
            return 220
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let showsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportsCell", for: indexPath)
        
        let logoImgVw:UIImageView = showsCell.viewWithTag(101)! as! UIImageView
        
        
        
        let strUrl = (((arrayContent.object(at:indexPath.item) as AnyObject).value(forKey:"thumbnails")! as AnyObject).object(at: 0) as? String)
        logoImgVw.sd_setImage(with: URL(string:strUrl!)) { (image, error, imageCacheType, imageUrl) in
            if image != nil {
                logoImgVw.image = image//self.cropToBounds(image: image!, width: 275, height: 380)
            }else
            {
                print("image not found")
            }
        }
        
        let descLbl:UILabel = showsCell.viewWithTag(102)! as! UILabel
        
        descLbl.text = (arrayContent.object(at:indexPath.item) as AnyObject).value(forKey:"name") as? String
        
        return showsCell
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var sizeCalculate = self.view.frame.size.width / 2
        sizeCalculate = sizeCalculate - 10
        let screenSize = self.view.frame.size.width
        
        print("collectionView.frame.size.height>>>",sizeCalculate)
        if screenSize < 330
        {
            return CGSize(width: 150, height: 220)
        }
        else  if screenSize > 385
        {
            return CGSize(width: sizeCalculate, height: 280)
        }
        else
        {
            return CGSize(width: sizeCalculate, height: 260)
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrayContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        sportsDetailDict = arrayContent.object(at:indexPath.item) as! NSDictionary
        print("homeDetailDict >>>>",sportsDetailDict)
        
        self.performSegue(withIdentifier: "sportsListPush", sender: self)
    }
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
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
        if segue.identifier == "sportsListPush"
        {
            UserDefaults.standard.setValue("back", forKey: "sportsButton")
            let vc = segue.destination as! SportsListViewController
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: sportsDetailDict)
            UserDefaults.standard.setValue(encodedData, forKey: "sportsDict")
            vc.dictSports = sportsDetailDict
            vc.sport_id = sportsDetailDict.value(forKey:"id") as? String
        }
        else if segue.identifier == "listSportsLogin"
        {
            
        }
    }
    
    
}
extension UIImageView
{
    func downloadSportsBigFrom(link:String?, contentMode mode: UIViewContentMode)
    {
        contentMode = mode
        if link == nil
        {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!)
        {
            
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    
                    return
                    
                }
                DispatchQueue.main.async { () -> Void in
                    
                    self.image = UIImage(data: data)
                    self.image = self.cropForBounds(image: self.image!, width: 275, height: 380)
                }
            }).resume()
        }
        else
        {
            self.image = UIImage(named: "default")
        }
    }
    
    func cropForBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
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
}
