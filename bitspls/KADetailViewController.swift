//
//  KADetailViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import AlamofireImage

class KADetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    
    @IBOutlet weak var leadingImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingImageConstraint: NSLayoutConstraint!
    
    var item: KAItem? {
        didSet {
            displayData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
    }
    
    
    private func displayData() {
        guard let newItem = item else { return }
        
        imageView?.af_setImageWithURL(newItem.imageURL)
        descriptionLabel?.text = newItem.description
        nameLabel?.text = newItem.identifier
        self.title = newItem.title
        
        
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        leadingImageConstraint.constant = -scrollView.contentOffset.y
//        trailingImageConstraint.constant = -scrollView.contentOffset.y
//        
//        scrollView.layoutIfNeeded()
//    }
    
}
