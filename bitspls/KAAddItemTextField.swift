//
//  KAAddItemTextField.swift
//  bitspls
//
//  Created by Sam Eckert on 07.11.15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

@IBDesignable class KAAddItemTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    @IBInspectable let paddingSide: CGFloat = 5.0
    
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: paddingSide, bottom: 0, right: paddingSide)
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
}
