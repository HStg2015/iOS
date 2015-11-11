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
        self.headerHeight = PageType(rect: printableRect).headerHeight
    }
    
    override func numberOfPages() -> Int {
        return 1
    }
    
    enum PageType {
        case Label, HalfSize, Large
        
        init(rect: CGRect) {
            switch (rect.width, rect.height) {
            case (0...200, 0...400):
                self = .Label
            case (200...600, 400...700):
                self = .HalfSize
            default:
                self = .Large
            }
        }
        
        var headerHeight: CGFloat {
            switch self {
            case .Label: return 0.0
            case .HalfSize: return CGFloat(0.5).points
            case .Large: return CGFloat(1).points
            }
        }
        
        func draw(contentRect: CGRect) {
            
        }
    }
    
    private lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    override func drawHeaderForPageAtIndex(pageIndex: Int, inRect headerRect: CGRect) {
        if headerRect.height > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Right
            let headerAttributes: [String : AnyObject] = [
                NSForegroundColorAttributeName : UIColor.blackColor(),
                NSFontAttributeName : UIFont.systemFontOfSize(11),
                NSParagraphStyleAttributeName : paragraphStyle
            ]
            (self.dateFormatter.stringFromDate(self.item.date) as NSString).drawInRect(headerRect, withAttributes: headerAttributes)
        }
        
    }
    override func drawContentForPageAtIndex(pageIndex: Int, inRect contentRect: CGRect) {
        switch pageIndex {
        case 0:
            print(contentRect.width, contentRect.height)
            switch PageType(rect: contentRect) {
            case .Label: break
            case . HalfSize: drawHalfSize(contentRect)
            case .Large : drawLarge(contentRect)
                
            }
            
            
            
        default: break
        }
    }
    
    //MARK: Drawing
    
    private func drawHalfSize(contentRect: CGRect) {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .Center
        let titleAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.boldSystemFontOfSize(22),
            NSParagraphStyleAttributeName : titleParagraphStyle
        ]
        
        let descriptionAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(10)
        ]
        
        let padding: CGFloat = 9
        let horizontalHalfSize = contentRect.width / 2 - padding / 2
        let halfX = contentRect.midX + padding / 2
        let titleRect = CGRect(
            origin: contentRect.origin,
            size: CGSize(
                width: contentRect.width,
                height:  (self.item.title as NSString).boundingRectWithSize(contentRect.size, options: .UsesLineFragmentOrigin, attributes: titleAttributes, context: nil).height
            )
        )
        (self.item.title as NSString).drawInRect(titleRect, withAttributes: titleAttributes)
        
        let details = [
            (NSLocalizedString("Phone:", comment: "phone details text"), self.item.phone),
            (NSLocalizedString("Mail:", comment: "mail details text"), self.item.email),
            (NSLocalizedString("Location:", comment: "location details text"), self.item.city)
        ]
        
        let detailSize = CGSize(width: horizontalHalfSize, height: (contentRect.maxY - titleRect.maxY) + padding)
        let detailRects: [((CGRect, String), (CGRect, String))] = details.reduce([]) {
            let labelY = ($0.last?.1.0.maxY ?? 0) + padding
            let labelRect = CGRect(
                origin: CGPoint(x: halfX, y: labelY),
                size: ($1.0 as NSString).boundingRectWithSize(
                    CGSize(width: detailSize.width, height: detailSize.height - labelY),
                    options: .UsesLineFragmentOrigin, attributes: descriptionAttributes, context: nil
                    ).size
            )
            let valueY = labelRect.maxY + padding / 2
            let valueRect = CGRect(
                origin: CGPoint(x: halfX + 5, y: valueY),
                size: ($1.1 as NSString).boundingRectWithSize(
                    CGSize(width: detailSize.width, height: detailSize.height - valueY),
                    options: .UsesLineFragmentOrigin, attributes: descriptionAttributes, context: nil
                    ).size
            )
            return $0 + [((labelRect, $1.0), (valueRect, $1.1))]
        }
        
        let detailHeight = detailRects.last?.1.0.maxY ?? 0.0
        
        //Sizing image
        let imageRect: CGRect = image.map {
            let size = $0.size.scaleMin(width: horizontalHalfSize, height: (contentRect.maxY - titleRect.maxY) - padding * 2 - detailHeight)
            return CGRect(x: halfX + (horizontalHalfSize - size.width) / 2, y: titleRect.maxY + padding, width: size.width, height: size.height)
            } ?? titleRect
        
        //Drawing image
        if let i = image { i.drawInRect(imageRect) }
        
        
        detailRects.forEach {
            ($0.0.1 as NSString).drawInRect($0.0.0.set(Y: $0.0.0.origin.y + imageRect.maxY + padding), withAttributes: descriptionAttributes)
            ($0.1.1 as NSString).drawInRect($0.1.0.set(Y: $0.1.0.origin.y + imageRect.maxY + padding), withAttributes: descriptionAttributes)
        }
        
        (self.item.description as NSString).drawWithRect(
            CGRect(x: contentRect.minX, y: titleRect.maxY + padding, width: horizontalHalfSize, height: contentRect.maxY - titleRect.maxY - padding),
            options: .UsesLineFragmentOrigin, attributes: descriptionAttributes, context: nil
        )
        
    }
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
        let titleRect = CGRect(
            origin: contentRect.origin,
            size: CGSize(
                width: contentRect.width,
                height:  (self.item.title as NSString).boundingRectWithSize(contentRect.size, options: .UsesLineFragmentOrigin, attributes: titleAttributes, context: nil).height
            )
        )
        (self.item.title as NSString).drawInRect(titleRect, withAttributes: titleAttributes)
        
        //Calculate remaing height for image and setting details and description size
        let fullDetailHeight = (("Phone" as NSString).sizeWithAttributes(descriptionAttributes).height + padding) * 3
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
        
        drawDetailLabels(contentRect, startX: descriptionRect.maxY, attributes: descriptionAttributes, padding: padding)
        
    }
    
    
    
    private func drawDetailLabels(contentRect: CGRect, startX: CGFloat, attributes: [String : AnyObject], padding: CGFloat = 12) {
        let details = [
            (NSLocalizedString("Phone:", comment: "phone details text"), self.item.phone),
            (NSLocalizedString("Mail:", comment: "mail details text"), self.item.email),
            (NSLocalizedString("Location:", comment: "location details text"), self.item.city)
        ]
        
        let detailLabelRects: [(CGRect, String)] = details.reduce([]) {
            let rect = CGRect(
                origin: CGPoint(x: contentRect.minX, y: ($0.last?.0.maxY ?? startX) + padding),
                size: ($1.0 as NSString).sizeWithAttributes(attributes)
            )
            ($1.0 as NSString).drawAtPoint(rect.origin, withAttributes: attributes)
            return $0 + [(rect, $1.1)]
        }
        
        let detailValueX: CGFloat = detailLabelRects.reduce(contentRect.minX) { max($0, $1.0.maxX) } + padding
        
        detailLabelRects.forEach {
            ($0.1 as NSString).drawAtPoint(CGPoint(x: detailValueX, y: $0.0.minY), withAttributes: attributes)
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

extension CGRect {
    func set(Y y: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: y, width: self.width, height: self.height)
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
