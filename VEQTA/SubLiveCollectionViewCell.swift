//
//  SubLiveCollectionViewCell.swift
//  VEQTA
//
//  Created by Cybermac002 on 07/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class SubLiveCollectionViewCell: UICollectionViewCell {

    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var timeBgView: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var logoImgView: UIImageView!
    @IBOutlet var Upcominglabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeBgView.layer.cornerRadius = 3
       // timeBgView.layer.borderWidth = 2
      //  timeBgView.layer.borderColor = UIColor.red.cgColor
        
        bgView.layer.cornerRadius = 3
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.red.cgColor
    }

}
