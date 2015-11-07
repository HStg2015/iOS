//
//  CollectionViewCell.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import AlamofireImage

class KACollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
        //    titleLabel.textColor = UIColor.whiteColor()
        }
    }
    
    var item: KAItem? {
        didSet {
            
            if let imageURL = item?.imageURL {
                imageView.af_setImageWithURL(imageURL, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageView.image = UIImage(named: "placeholder")
            }
            titleLabel.text = item?.title
        }
    }
    
    override func awakeFromNib() {
       // self.backgroundColor = UIColor.bitsplsOrangeDark()
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor(red: 202/255, green: 202/255, blue: 202/255, alpha: 0.4).CGColor
        self.layer.borderWidth = 1.0
    }
}
