//
//  KAItemPrintPageRenderer.swift
//  bitspls
//
//  Created by Leonard Mehlig on 10/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

private let POINTS_PER_INCH: CGFloat = 72

class KAItemPrintPageRenderer: UIPrintPageRenderer {
    
    let item: KAItem
    let image: UIImage?
    
    private let headerAttributes: [String : AnyObject] = [
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont.systemFontOfSize(11)
    ]
    
    
    
    
    private let descriptionAttributes: [String : AnyObject] = [
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont.systemFontOfSize(13)
    ]
    init(item: KAItem, image: UIImage?) {
        self.item = item
        self.image = image
        super.init()
        self.headerHeight = 1 * POINTS_PER_INCH
    }
    
    override func numberOfPages() -> Int {
        return 1
    }
    
    override func drawHeaderForPageAtIndex(pageIndex: Int, inRect headerRect: CGRect) {
        (item.email as NSString).drawInRect(headerRect, withAttributes: headerAttributes)
        
    }
    override func drawContentForPageAtIndex(pageIndex: Int, inRect contentRect: CGRect) {
        switch pageIndex {
        case 0:
            print(contentRect)
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            let titleAttributes: [String : AnyObject] = [
                NSForegroundColorAttributeName : UIColor.blackColor(),
                NSFontAttributeName : UIFont.boldSystemFontOfSize(20),
                NSParagraphStyleAttributeName : titleParagraphStyle
            ]
            
            let titleSize = (item.title as NSString).boundingRectWithSize(contentRect.size, options: .UsesLineFragmentOrigin, attributes: titleAttributes, context: nil)
            let titleRect = CGRect(origin: contentRect.origin, size: CGSize(width: contentRect.width, height: titleSize.height))
            let imageRect: CGRect = image.map {
                let size = $0.size.scaleMin(width: contentRect.width, height: (contentRect.maxY - titleRect.maxY) / 3)
                return CGRect(x: contentRect.minX + (contentRect.width - size.width) / 2, y: titleRect.maxY + 12, width: size.width, height: size.height)
            } ?? titleRect

            
            let descriptionSize = (item.description as NSString).boundingRectWithSize(CGSize(width: contentRect.width, height: contentRect.maxY - imageRect.maxY - 12), options: .UsesLineFragmentOrigin, attributes: self.descriptionAttributes, context: nil)

            let descriptionRect = CGRect(x: contentRect.minX, y: imageRect.maxY + 12, width: descriptionSize.width, height: descriptionSize.height)
            print(descriptionRect)
            (self.item.title as NSString).drawInRect(titleRect, withAttributes: titleAttributes)
            if let i = image { i.drawInRect(imageRect) }
            (self.item.description as NSString).drawWithRect(descriptionRect, options: .UsesLineFragmentOrigin, attributes: self.descriptionAttributes, context: nil)
            
            
        default: break
        }
    }
}


//MARK: - CGSize extension
func *(size: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: size.width * factor, height: size.height * factor)
}

extension CGSize {
    func scale(height height: CGFloat) -> CGSize {
        return self * (height / self.height)
    }
    
    func scale(width width: CGFloat) -> CGSize {
        return self * (width / self.width)
    }
    
    func scaleMin(width width: CGFloat, height: CGFloat) -> CGSize {
        return self * min(width / self.width, height / self.height)
        
    }
    
    enum Orientation {
        case Vertical, Horizontal, Both
        
        var isVertical: Bool {
            return self == .Vertical || self == .Both
        }
        
        var isHorizontal: Bool {
            return self == .Vertical || self == .Both
        }
    }
    func centerInRect(rect: CGRect, orientation: Orientation = .Both) -> CGRect {
        return CGRect(origin: CGPoint(
            x: rect.origin.x + (orientation.isHorizontal ? max(0, (rect.width - self.width) / 2) : 0),
            y: rect.origin.y + (orientation.isVertical ? max(0, (rect.height - self.height) / 2) : 0)
            ), size: self)
    }
}
