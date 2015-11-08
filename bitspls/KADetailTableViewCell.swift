//
//  KADetailTableViewCell.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class KADetailTableViewCell: UITableViewCell {

    
    var detail: KADetail? {
        didSet {
            guard let newDetail = detail else { return }
            titleLabel.text = newDetail.title
            nameLabel.text = newDetail.text
            firstActionButton.setBackgroundImage(newDetail.buttonIcon, forState: .Normal)
            secondActionButton.setBackgroundImage(newDetail.buttonIcon2, forState: .Normal)
            firstActionButton.hidden = newDetail.buttonAction == nil
            secondActionButton.hidden = newDetail.buttonAction2 == nil
        }
    }
    
    weak var viewController: UIViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var firstActionButton: UIButton! {
        didSet {
            firstActionButton.hidden = true
            firstActionButton.setTitle(nil, forState: .Normal)
        }
    }
    
    @IBOutlet weak var secondActionButton: UIButton! {
        didSet {
            secondActionButton.hidden = true
            secondActionButton.setTitle(nil, forState: .Normal)

        }
    }
    
    
    @IBAction func firstButtonTapped() {
        detail?.buttonAction?()
    }

    
    @IBAction func secondButtonTapped() {
        detail?.buttonAction2?()

    }
    
}


struct KADetail {
    let title: String
    let text: String
    let buttonIcon: UIImage?
    let buttonAction: (() -> Void)?
    let buttonIcon2: UIImage?
    let buttonAction2: (() -> Void)?
    
    init(title: String, text: String) {
        self.init(title: title, text: text, icon: nil, action: nil)
    }
    
    init(title: String, text: String, icon: UIImage?, action: (() -> Void)?) {
        self.init(title: title, text: text, icon: icon, action: action, icon2: nil, action2: nil)
    }
    
    init(title: String, text: String, icon: UIImage?, action: (() -> Void)?, icon2: UIImage?, action2: (() -> Void)?) {
        self.title = title
        self.text = text
        self.buttonIcon = icon
        self.buttonAction = action
        self.buttonIcon2 = icon2
        self.buttonAction2 = action2
    }
}