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
            guard let newItem = self.item else {
                imageView.image = nil
                titleLabel.text = nil
                return
            }
            
            imageView.af_setImageWithURL(newItem.imageURL)
            titleLabel.text = newItem.title
        }
    }
}
