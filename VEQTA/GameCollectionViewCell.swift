//
//  GameCollectionViewCell.swift
//  VEQTA
//
//  Created by Cybermac002 on 12/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import SDWebImage
class GameCollectionViewCell: UICollectionViewCell {
    var initialLoad = true
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var imgLogo: UIImageView!
    var strUrl:String!
    var strTitle:NSString = NSString()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("strUrl >>",strTitle)
        bgView.layer.cornerRadius = 3
        
    }
    override func prepareForReuse() {
        initialLoad = true
    }
    internal func configureCell(imgUrl:String,title:String) {
        
        if initialLoad {
            // set your image here
//            if self.imgLogo.image == nil
//            {
                imgLogo.sd_setImage(with: URL(string:imgUrl as String)) { (image, error, imageCacheType, imageUrl) in
                    if image != nil
                    {
                        self.imgLogo.image = image
                        // highlightCell.imgLogo.image = image?.thumbnailImage(600, transparentBorder: 0, cornerRadius: 0, interpolationQuality: .low)//self.cropToSportsBounds(image: image!, width: 600, height: 340)
                    }else
                    {
                        print("image not found")
                    }
                }
//            }
//           else
//            {
//                imgLogo.image = imgLogo.image
//            }
            
        }
        else
        {
            
        }
        initialLoad = false
        self.lblTitle.text = title as String
        // do everything else here
    }
    func showData(imgUrl:String,title:String)
    {
        
//        if (self.imgLogo.image?.size)!.equalTo(CGSize(width: 0, height: 0)) {
//            print(" not nil")
//            imgLogo.sd_setImage(with: URL(string:imgUrl as String)) { (image, error, imageCacheType, imageUrl) in
//                if image != nil {
//                    self.imgLogo.image = image
//                    // highlightCell.imgLogo.image = image?.thumbnailImage(600, transparentBorder: 0, cornerRadius: 0, interpolationQuality: .low)//self.cropToSportsBounds(image: image!, width: 600, height: 340)
//                }else
//                {
//                    print("image not found")
//                }
//            }
//            self.lblTitle.text = title as String
//        }
        if self.imgLogo.image == nil
        {
             print(" not nil")
            imgLogo.sd_setImage(with: URL(string:imgUrl as String)) { (image, error, imageCacheType, imageUrl) in
                if image != nil {
                    self.imgLogo.image = image
                    // highlightCell.imgLogo.image = image?.thumbnailImage(600, transparentBorder: 0, cornerRadius: 0, interpolationQuality: .low)//self.cropToSportsBounds(image: image!, width: 600, height: 340)
                }else
                {
                    print("image not found")
                }
            }
            self.lblTitle.text = title as String
        }
        
        
        
    }
}
