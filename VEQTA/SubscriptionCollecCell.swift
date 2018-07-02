//
//  SubscriptionCollecCell.swift
//  VEQTA
//
//  Created by multitv on 18/04/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit

class SubscriptionCollecCell: UICollectionViewCell
{
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPlan: UILabel!
    @IBOutlet weak var viewSubPlan:UIView!
    @IBOutlet weak var viewSubscriptionPlan:UIView!
    @IBOutlet var checkImg: UIImageView!
     @IBOutlet var ClickHerelabel: UILabel!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        //viewSubscriptionPlan.layer.borderWidth = 0.5
        //viewSubscriptionPlan.layer.borderColor = UIColor.white.cgColor
        // Initialization code
    }

}
