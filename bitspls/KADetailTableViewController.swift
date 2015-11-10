//
//  KADetailTableViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
import MessageUI

class KADetailTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
   
    private enum Section {
        case Title(String)
        case Description(text: String)
        case Detail(details: [KADetail])
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
            case .Map(_): return "Karte"
            default: return nil
            }
        }
        
    }
    
    
    var item: KAItem? {
        didSet {
            guard let newItem = item else { return }
            sections = [.Title(newItem.title), .Description(text: newItem.description),
                .Detail(details: newItem.detailsForController(self))]
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
                //self.tableView.reloadData()
               self.tableView.beginUpdates()
                self.tableView.insertSections(NSIndexSet(index: self.sections.count - 1), withRowAnimation: .Bottom)
                self.tableView.endUpdates()
            }
        }
    }
    
    private var sections: [Section] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addParallaxWithImage(UIImage(named: "placeholder"), andHeight: 200)
        if let url = item?.imageURL {
            self.tableView.parallaxView.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"))
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
            detailCell.detail = details[indexPath.row]
            detailCell.viewController = self
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
    
    
    //MARK: Actions

    //Mail action
    func composeMail() {
        if let i = self.item where MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
                vc.setToRecipients([i.email])
            vc.setSubject(i.title)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //Phone action
    func makeCall() {
        item?.phoneURL.map { UIApplication.sharedApplication().openURL($0) }
    }
    
    //Message action
    func writeMessage() {
        if let number = item?.phone where MFMessageComposeViewController.canSendText() {
            let vc = MFMessageComposeViewController()
            vc.messageComposeDelegate = self
            vc.recipients = [number]
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    //Print action
    @IBAction func printItem(sender: UIBarButtonItem) {
        guard let i = self.item else { return }
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = i.title
        printInfo.outputType = .General
        
        let printController = UIPrintInteractionController.sharedPrintController()
        printController.printInfo = printInfo
        printController.printPageRenderer = KAItemPrintPageRenderer(item: i, image: self.tableView.parallaxView.imageView.image)
        printController.presentAnimated(true, completionHandler: nil)
    }
}

extension KAItem {
    func detailsForController(controller: KADetailTableViewController) -> [KADetail] {
        let loc = KADetail(title: "Location", text: self.city)
        let mail = KADetail(title: "E-Mail", text: self.email, icon: UIImage(named: "mail"), action: MFMailComposeViewController.canSendMail() ? controller.composeMail : nil)
        let phone = KADetail(title: "Telefon", text: self.phone, icon: UIImage(named: "phone"),
            action: (self.phoneURL.map { UIApplication.sharedApplication().canOpenURL($0)  } ?? false) ? controller.makeCall : nil, icon2: UIImage(named: "message"),
            action2: MFMessageComposeViewController.canSendText() ? controller.writeMessage : nil)
        return [loc, mail, phone].flatMap { $0 }

    }
    
    
    
}




