//
//  KAItemPrintPageRenderer.swift
//  bitspls
//
//  Created by Leonard Mehlig on 10/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit


class KAItemPrintPageRenderer: UIPrintPageRenderer {
    
    let item: KAItem
    let image: UIImage?
    
    init(item: KAItem, image: UIImage?) {
        self.item = item
        self.image = image
        super.init()
        self.headerHeight = CGFloat(1).points
    }
    
    override func numberOfPages() -> Int {
        return 1
    }
    
    let headerAttributes: [String : AnyObject] = [
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont.systemFontOfSize(11)
    ]
    
    override func drawHeaderForPageAtIndex(pageIndex: Int, inRect headerRect: CGRect) {
        (item.email as NSString).drawInRect(headerRect, withAttributes: headerAttributes)
        
    }
    override func drawContentForPageAtIndex(pageIndex: Int, inRect contentRect: CGRect) {
        switch pageIndex {
        case 0:
            switch (contentRect.width.inches, contentRect.height.inches) {
            case (0...1.5, 0...3):
                break
            case (1.5...5, 3...7):
                break
            default:
                drawLarge(contentRect)
            }
            
            
            
        default: break
        }
    }
    
    //MARK: Drawing
    
    private func drawLarge(contentRect: CGRect) {
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .Center
        let titleAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.boldSystemFontOfSize(30),
            NSParagraphStyleAttributeName : titleParagraphStyle
    ]
    
        let descriptionAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(14)
        ]
        
        let padding: CGFloat = 12
        
     
        //Title sizing and drawing
        let titleSize = (item.title as NSString).boundingRectWithSize(contentRect.size, options: .UsesLineFragmentOrigin, attributes: titleAttributes, context: nil)
        let titleRect = CGRect(origin: contentRect.origin, size: CGSize(width: contentRect.width, height: titleSize.height))
        (self.item.title as NSString).drawInRect(titleRect, withAttributes: titleAttributes)

        //Calculate remaing height for image and setting details and description size
        let detailHeight = ("Phone" as NSString).sizeWithAttributes(descriptionAttributes).height
        let fullDetailHeight = (detailHeight + padding) * 3
        let descriptionSize = (item.description as NSString).boundingRectWithSize(CGSize(width: contentRect.width, height: contentRect.maxY - titleRect.maxY - fullDetailHeight), options: .UsesLineFragmentOrigin, attributes: descriptionAttributes, context: nil)
        
        //Sizing image
        let imageRect: CGRect = image.map {
            let size = $0.size.scaleMin(width: contentRect.width, height: (contentRect.maxY - titleRect.maxY) - padding * 2 - descriptionSize.height - fullDetailHeight)
            return CGRect(x: contentRect.minX + (contentRect.width - size.width) / 2, y: titleRect.maxY + padding, width: size.width, height: size.height)
            } ?? titleRect
        
        //Drawing image
        if let i = image { i.drawInRect(imageRect) }

        
        
        //Drawing description
        let descriptionRect = CGRect(x: contentRect.minX, y: imageRect.maxY + padding, width: descriptionSize.width, height: descriptionSize.height)
        (self.item.description as NSString).drawWithRect(descriptionRect, options: .UsesLineFragmentOrigin, attributes: descriptionAttributes, context: nil)
        
        //Calculation details size
        //Phone detail
        let phoneName = NSLocalizedString("Phone:", comment: "phone details text")
        let phoneNameSize = (phoneName as NSString).sizeWithAttributes(descriptionAttributes)
        let phoneNameY = descriptionRect.maxY + padding
        (phoneName as NSString).drawAtPoint(CGPoint(x: contentRect.minX, y: phoneNameY), withAttributes: descriptionAttributes)
        
        //Mail details
        let mailName = NSLocalizedString("Mail:", comment: "mail details text")
        let mailNameSize = (mailName as NSString).sizeWithAttributes(descriptionAttributes)
        let mailNameY = phoneNameY + padding + phoneNameSize.height
        (mailName as NSString).drawAtPoint(CGPoint(x: contentRect.minX, y: mailNameY), withAttributes: descriptionAttributes)

        //Location details
        let locationName = NSLocalizedString("Location:", comment: "location details text")
        let locationNameSize = (locationName as NSString).sizeWithAttributes(descriptionAttributes)
        let locationNameY = mailNameY + padding + mailNameSize.height
        (locationName as NSString).drawAtPoint(CGPoint(x: contentRect.minX, y: locationNameY), withAttributes: descriptionAttributes)

        //Value labels
        let detailsX = contentRect.minX + max(phoneNameSize.width, mailNameSize.width, locationNameSize.width) + padding
        (self.item.phone as NSString).drawAtPoint(CGPoint(x: detailsX, y: phoneNameY), withAttributes: descriptionAttributes)
        (self.item.email as NSString).drawAtPoint(CGPoint(x: detailsX, y: mailNameY), withAttributes: descriptionAttributes)
        (self.item.city as NSString).drawAtPoint(CGPoint(x: detailsX, y: locationNameY), withAttributes: descriptionAttributes)

        
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

extension CGFloat {
    private static let POINTS_PER_INCH: CGFloat = 72
    
    var inches: CGFloat {
        return self / CGFloat.POINTS_PER_INCH
    }
    
    var points: CGFloat {
        return self * CGFloat.POINTS_PER_INCH
    }
}
