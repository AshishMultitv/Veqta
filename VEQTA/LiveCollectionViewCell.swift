//
//  LiveCollectionViewCell.swift
//  VEQTA
//
//  Created by Cybermac002 on 23/03/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class LiveCollectionViewCell: UICollectionViewCell {
    var videoItem:AVPlayerItem!
    var videoPlayer:AVPlayer!
    
    
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var timeBgView: UIView!
    @IBOutlet var upcomingHeading: UILabel!
    @IBOutlet var lblUpcoming: UILabel!
    @IBOutlet var upcomingBg: UIView!
    @IBOutlet var logoImgView: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    var avLayer:AVPlayerLayer!
    let playerViewController = AVPlayerViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        upcomingBg.layer.cornerRadius = 3
        upcomingBg.layer.borderWidth = 2
        upcomingBg.layer.borderColor = UIColor.red.cgColor
        
        timeBgView.layer.cornerRadius = 3
       // timeBgView.layer.borderWidth = 2
       // timeBgView.layer.borderColor = UIColor.red.cgColor
    }

}
