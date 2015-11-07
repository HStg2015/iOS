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
    
    @IBOutlet private weak var titleLabel: UILabel!
    
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
}
