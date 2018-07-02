//
//  HighlightCollectionViewCell.swift
//  VEQTA
//
//  Created by Cybermac002 on 24/03/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class HighlightCollectionViewCell: UICollectionViewCell {
    var videoItem:AVPlayerItem!
    
    @IBOutlet var logoImgVw: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var bgView: UIView!
    var videoPlayer:AVPlayer!
    var avLayer:AVPlayerLayer!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 3
    }
}
