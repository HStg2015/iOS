//
//  KAPrintView.swift
//  bitspls
//
//  Created by Leonard Mehlig on 10/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class KAPrintView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    class func fromNibWithFrame() -> KAPrintView {
        return NSBundle.mainBundle().loadNibNamed("KAPrintView", owner: nil, options: nil).first as! KAPrintView
    }
}
