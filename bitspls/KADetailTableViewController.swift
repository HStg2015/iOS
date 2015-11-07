//
//  KADetailTableViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import MapKit

class KADetailTableViewController: UITableViewController {
    
    private struct CellIdentifier {
        static let Description = "bitspls.cell.description"
        static let Phone = "bitspls.cell.phone"
    }
    
    
    private enum Section {
        case Description(text: String)
        case Detail(details: [(String, String)])
        case Map(region: MKCoordinateRegion)
        
        var rows: Int {
            switch self {
            case .Description(_): return 1
            case .Detail(let details): return details.count
            case .Map(_): return 1
            }
        }
        
        var identfier: String {
            switch self {
            case .Description(_): return "bitspls.cell.description"
            case .Detail(_): return "bitspls.cell.detail"
            case .Map(_): return "bitspls.cell.map"
            }
        }
        
        
    }
    
    
    var item: KAItem?
    
    private lazy var sections: [Section] = {
        guard let newItem = self.item else { return [] }
        return [.Description(text: newItem.description),
            .Detail(details: newItem.details)]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addParallaxWithImage(UIImage(named: "test.jpg"), andHeight: 200)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier(section.identfier, forIndexPath: indexPath)
        
        switch (section, cell) {
        case (.Description(let text), let desCell as KADescriptionTableViewCell):
            desCell.label.text = text
        case (.Detail(let details), let detailCell as KADetailTableViewCell):
            detailCell.titleLabel.text = details[indexPath.row].0
            detailCell.nameLabel.text = details[indexPath.row].1
        default: break
        }
        
        return cell
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ context in
            self.tableView.parallaxView.frame.size.width = self.tableView.bounds.width
            self.tableView.parallaxView.imageView.frame.size.width = self.tableView.bounds.width
            }, completion: nil)
    }
    
}

extension KAItem {
    var details: [(String, String)] {
        return [("Postleitzahl", self.city),
            ("E-Mail", self.email), self.phone.map { ("Telefon", $0) }].flatMap { $0 }
    }
}
