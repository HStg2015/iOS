//
//  KADetailTableViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage
class KADetailTableViewController: UITableViewController {
    
    private struct CellIdentifier {
        static let Description = "bitspls.cell.description"
        static let Phone = "bitspls.cell.phone"
    }
    
    
    private enum Section {
        case Title(String)
        case Description(text: String)
        case Detail(details: [(String, String)])
        case Map(center: CLLocationCoordinate2D)
        
        var rows: Int {
            switch self {
            case .Title(_): return 1
            case .Description(_): return 1
            case .Detail(let details): return details.count
            case .Map(_): return 1
            }
        }
        
        var identfier: String {
            switch self {
            case .Title(_): return "bitspls.cell.title"
            case .Description(_): return "bitspls.cell.description"
            case .Detail(_): return "bitspls.cell.detail"
            case .Map(_): return "bitspls.cell.map"
            }
        }
        
        var headerText: String? {
            switch self {
            case .Description(_): return "Beschreibung"
            default: return nil
            }
        }
        
    }
    
    
    var item: KAItem? {
        didSet {
            guard let newItem = self.item else { return }
            sections = [.Title(newItem.title), .Description(text: newItem.description),
                .Detail(details: newItem.details)]
            let mapRequest = MKLocalSearchRequest()
            mapRequest.naturalLanguageQuery = item?.city
            let search = MKLocalSearch(request: mapRequest)
            search.startWithCompletionHandler { response, error in
                guard let mapItem = response?.mapItems.first,
                    loc = mapItem.placemark.location else {
                        print(error)
                        return
                }
                self.sections.append(.Map(center: loc.coordinate))
                self.tableView.beginUpdates()
                self.tableView.insertSections(NSIndexSet(index: self.sections.count - 1), withRowAnimation: .Bottom)
                self.tableView.endUpdates()
                
                //                NSOperationQueue.mainQueue().addOperationWithBlock {
                //                    options.size = CGSize(width: self.tableView.bounds.width, height: cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height)
                //                    let snapshotter = MKMapSnapshotter(options: options)
                //                    snapshotter.startWithCompletionHandler { snapshot, error in
                //                        guard let mapSnapshot = snapshot else {
                //                            print(error)
                //                            return
                //                        }
                //                        NSOperationQueue.mainQueue().addOperationWithBlock {
                //
                //
                //                        }
                //                    }
                //                }
            }
        }
    }
    
    private var sections: [Section] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addParallaxWithImage(UIImage(), andHeight: 200)
        if let url = item?.imageURL {
            self.tableView.parallaxView.imageView.af_setImageWithURL(url)
        }
        self.title = item?.title
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
        case (.Title(let t), let titleCell as KATitleTableViewCell):
            titleCell.titleLabel.text = t
        case (.Description(let text), let desCell as KADescriptionTableViewCell):
            desCell.label.text = text
        case (.Detail(let details), let detailCell as KADetailTableViewCell):
            detailCell.titleLabel.text = details[indexPath.row].0
            detailCell.nameLabel.text = details[indexPath.row].1
        case (.Map(let loc), let mapCell as KAMapTableViewCell):
            mapCell.coordiante = loc
        default: break
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerText
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
