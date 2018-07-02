//
//  EditProfileVC.swift
//  VeqtaMyProfile
//
//  Created by multitv on 02/05/17.
//  Copyright © 2017 multitv. All rights reserved.
//

import UIKit
import AFNetworking

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate
    
{
    @IBOutlet weak var btnSave:UIButton!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var imgViewProfile:UIImageView!
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtEmailId:UITextField!
    @IBOutlet weak var txtGender:UITextField!
    @IBOutlet weak var btnGenderDropDown:UIButton!
    @IBOutlet weak var btnBirthdayDropDown:UIButton!
    @IBOutlet weak var txtAboutUs:UITextField!
    @IBOutlet weak var txtMobileNumber:UITextField!
    var objLoader : LoaderView = LoaderView()
    @IBOutlet var pickerBgView: UIView!
    var strSelected:NSString = NSString()
    var imgData:Data!
    ///Anamika
    @IBOutlet weak var btnProfileImageChange:UIButton!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var btnMale:UIButton!
    @IBOutlet weak var btnFemale:UIButton!
    @IBOutlet weak var viewGenderList:UIView!
    var strImgData = String()
    var objWeb = AFNetworkingWebServices()
    var userIdStr:NSString = NSString()
    var Isuserupdateprofile:Bool = false
    
    @IBOutlet weak var btnDone: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait)
        self.registerForKeyboardNotifications()
        let decoded  = UserDefaults.standard.object(forKey: "userIfo") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        let first = nullToNil(value: decodedTeams.object(forKey: "first_name") as AnyObject)
        let last = nullToNil(value: decodedTeams.object(forKey: "last_name") as AnyObject)
        self.txtFirstName.text = first as? String
        self.txtLastName.text = last as? String
        self.txtEmailId.text = decodedTeams.object(forKey: "email") as? String
         let singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
        singletap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singletap)
        
      //  self.txtFirstName.attributedPlaceholder = NSAttributedString(string: decodedTeams.object(forKey: "first_name") as! String,
        //                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
       // self.txtLastName.attributedPlaceholder = NSAttributedString(string: decodedTeams.object(forKey: "last_name") as! String,
       //                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
      //  self.txtEmailId.attributedPlaceholder = NSAttributedString(string: decodedTeams.object(forKey: "email") as! String,
        //                                                           attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        let gender = nullToNil(value: decodedTeams.object(forKey: "gender") as AnyObject)
        self.txtGender.text = gender as? String
        self.txtMobileNumber.text = decodedTeams.object(forKey: "contact_no") as? String
        self.txtAboutUs.text = decodedTeams.object(forKey: "about_me") as? String
        let image_mode = nullToNil(value: decodedTeams.object(forKey: "image") as AnyObject)
        self.imgViewProfile.sd_setImage(with: URL(string: (image_mode as? String)!), placeholderImage: UIImage(named: "userProfile"))
       // self.imgViewProfile.downloadFrom(link: decodedTeams.object(forKey: "image") as? String, contentMode: UIViewContentMode.scaleToFill)
        self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.height/2
        self.imgViewProfile.clipsToBounds = true
        self.imgViewProfile.layer.masksToBounds = true
        self.imgViewProfile.image = self.cropToBounds(image: imgViewProfile.image!, width: 100, height: 100)
         self.btnProfileImageChange.layer.cornerRadius = self.imgViewProfile.frame.height/2
        
        self.btnProfileImageChange.clipsToBounds = true
        self.btnProfileImageChange.layer.masksToBounds = true
        btnDone.isHidden = true
        
        self.viewGenderList.isHidden = true
        
        ///For  Update Profile
        NotificationCenter.default.addObserver(self,selector: #selector(getUpdateProfileResponse),name: NSNotification.Name(rawValue: "getUpdateEditProfileResponse"),object: nil)
        let defaults = UserDefaults.standard
        userIdStr = defaults.value(forKey: "loginData") as! String as NSString
        //(defaults.(forKey: "loginData") as? NSString)!
        print(userIdStr)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
         print("after seleteting pic")
    }
    
    func singleTapped()  {
        self.viewGenderList.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        //    print("TextField should return method called")
        textField.resignFirstResponder()
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtMobileNumber
        {
            strSelected = "mobile"
        }
        if textField == txtFirstName
        {
            strSelected = "firstname"
        }
        if textField == txtLastName
        {
            strSelected = "lastname"
        }
        if textField == txtEmailId
        {
            strSelected = "email"
        }
        if textField == txtAboutUs
        {
            strSelected = "aboutus"
        }
    }
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0
            {
                if strSelected == "mobile" || strSelected == "firstname" || strSelected == "lastname" || strSelected == "email"
                {
                if(strSelected == "lastname")
                {
                   self.view.frame.origin.y -= 30
                }
                }
                else
                {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            self.view.frame.origin.y = 0
            
            
            if view.frame.origin.y != 0 {
                if strSelected == "mobile" || strSelected == "firstname" || strSelected == "lastname" || strSelected == "email"
                {
                    
                }
                else
                {
                    self.view.frame.origin.y = 0
                }
                
            }
            else {
                
            }
        }
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
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    @IBAction func btnBackAction()
    {
        _ = navigationController?.popViewController(animated: true)
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
    
    
    func converimagetobase64(image:UIImage)
    {
        // image.resizeByByte(maxByte: 100)
        print(strImgData)
        let tmpData: NSData? = image.jpeg(.lowest) as NSData?
        strImgData = (tmpData?.base64EncodedString(options: .lineLength64Characters))!
        print(strImgData)
  
        
    }
    
    
    @IBAction func btnSaveAction()
    {
        
       // imgData = UIImageJPEGRepresentation(imgViewProfile.image!, 0.1)
       // let imageData = UserDefaults.standard.object(forKey: "profileImage") as! NSData
        //strImgData = imgData.base64EncodedString(options: .endLineWithLineFeed)
        print(strImgData as String)
        let strFirstName = txtFirstName.text! as String
        let strLastName = txtLastName.text! as String
        
        if strFirstName == "" || strLastName == ""
        {
            let alert = UIAlertController(title: "Message", message: "Please enter firstname and lastname.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       else
        {
            self.createLoader()
            var json = [String:String]()
            if(Isuserupdateprofile)
            {
                      json = ["device":"ios","id":userIdStr as String,"first_name":txtFirstName.text! as String,"last_name":txtLastName.text! as String,"gender":txtGender.text! as String,"contact_no":txtMobileNumber.text! as String,"pic":strImgData as String,"ext":"png","dob":"0000-00-00" as String,"about_me":self.txtAboutUs.text! as String]
            }
            else
            {
                      json = ["device":"ios","id":userIdStr as String,"first_name":txtFirstName.text! as String,"last_name":txtLastName.text! as String,"gender":txtGender.text! as String,"contact_no":txtMobileNumber.text! as String,"pic":"","ext":"","dob":"0000-00-00" as String,"about_me":self.txtAboutUs.text! as String]
            }
             print(json)
            let defaults = UserDefaults.standard
            defaults.set(json, forKey: "getUpdateProfileResponse")
            var url = String(format: "%@%@", LoginCredentials.Editapi,Constants.APP_Token)
            url = url.trimmingCharacters(in: .whitespaces)
              let manager = AFHTTPSessionManager()
            manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                let dict = responseObject as! NSDictionary
                print(dict)
                self.Isuserupdateprofile = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUpdateEditProfileResponse"), object: dict)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                self.removeLoader()
                
            })
            
             //objWeb.postRequestAndGetResponse(urlString: url as NSString, param: json as NSDictionary, info: "getUpdateEditProfileResponse")
        }
    }
    
    @objc func getUpdateProfileResponse(notification: NSNotification)
    {
        self.removeLoader()
        //print("notification.object as! NSDictionary ",notification.object as! NSDictionary)
        var responseDict:NSDictionary=NSDictionary()
        var dictContent:NSMutableDictionary=NSMutableDictionary()
        responseDict=notification.object as! NSDictionary
        dictContent=responseDict.mutableCopy() as! NSMutableDictionary
        print("user detail>>>>",dictContent)
        if((dictContent.value(forKey: "code")) != nil)
        {
        if((dictContent.value(forKey: "code") as! NSNumber) == 0)
        {
        
        let alert = UIAlertController(title: "Message", message: "Getting issue in updating your profile right now. Please try after some time.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
       
        }
        }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: dictContent.value(forKey:"result") as! NSDictionary)
        UserDefaults.standard.setValue(encodedData, forKey: "userIfo")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        let id = (dictContent.object(forKey: "result") as! NSDictionary).value(forKey: "id") as! NSNumber
        print(id)
        
        UserDefaults.standard.setValue(id.stringValue, forKey: "loginData")
        UserDefaults.standard.setValue(id.stringValue, forKey: "UserID")
         _ = navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @objc func getFavListResponse(notification: NSNotification)
    {
    }
    @IBAction func btnGenderDropDownAction()
    {
        self.viewGenderList.isHidden = false
    }
    
    ///Anamika
    //MARK:- Imagepicker delegates
    @IBAction func btndoneAction()
    {
        btnDone.isHidden = true
    }
    
    @IBAction func  btnProfileImageChangeAction()
    {
        
        
        
        
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.openCamera()
                
        })
        
        let deleteAction = UIAlertAction(title: "Gallery", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.openGallary()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
        
        
        
        
         //imagePicker.allowsEditing = true
       // imagePicker.sourceType = .photoLibrary
       // present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    func openCamera()
    {
        
        
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.imgViewProfile.image = pickedImage.fixOrientation()
            self.converimagetobase64(image: imgViewProfile.image!)
            self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.height/2
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.masksToBounds = true
            self.imgViewProfile.image = self.cropToBounds(image: self.imgViewProfile.image!, width: 100, height: 100)
            let defaults = UserDefaults.standard
            let tempData = UIImageJPEGRepresentation(self.imgViewProfile.image!, 1.0)
             defaults.set(tempData, forKey: "profileImage")
            self.Isuserupdateprofile = true

        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    ///MARK:- For Gender Selection
    
    @IBAction func  btnMaleAction()
    {
        txtGender.text = self.btnMale.titleLabel?.text
        self.viewGenderList.isHidden = true
    }
    @IBAction func  btnFemaleAction()
    {
        
        txtGender.text = self.btnFemale.titleLabel?.text
        self.viewGenderList.isHidden = true
    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
  
    
    
}
