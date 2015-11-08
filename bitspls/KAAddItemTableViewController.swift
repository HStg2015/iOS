//
//  KAAddItemTableViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 08/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class KAAddItemTableViewController: UITableViewController {
    
    private enum Row {
        case Title(String?)
        case Description(String?)
        case Category(Int, open: Bool)
        case Location(String?)
        case Phone(String?)
        case EMail(String?)
        case Image(UIImage?)
        
        
        var identfier: String {
            switch self {
            case .Category(_): return "bitspls.cell.segmented"
            case .Image(_): return "bitspls.cell.image"
            case .Description(_): return "bitspls.cell.textview"
            default: return "bitspls.cell.textfield"
            }
        }
        
        var headerText: String? {
            switch self {
            case .Title(_): return "Was möchtest du spenden"
            case .Description(_): return "Beschreibung"
            case .Category(_): return "Beschreibung"
            case .Location(_): return "Beschreibung"
            case .Phone(_): return "Beschreibung"
            case .EMail(_): return "Beschreibung"
            case .Image(_): return "Beschreibung"

            }
        }
        
        var rows: Int {
            switch self {
            case .Category(_, let open): return open ? 2 : 1
            default: return 1
            }
        }
        
        var placeholder: String? {
            switch self {
            case .Title(_): return "Was möchtest du spenden"
            case .Description(_): return "Beschreibung"
            case .Location(_): return "Beschreibung"
            case .Phone(_): return "Beschreibung"
            case .EMail(_): return "Beschreibung"
            default: return nil
            }
        }
        
        var text: String? {
            switch self {
            case .Title(let t): return t
            case .Description(let t): return t
            case .Location(let t): return t
            case .Phone(let t): return t
            case .EMail(let t): return t
            default: return nil
            }
        }
    }
    
    private weak var descriptionTextView: UITextView?
    
    private var rows: [Row] = [.Title(nil), .Description(nil), .Category(0, open: false), .Location(nil), .Phone(nil), .EMail(nil), .Image(nil)]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return rows.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].rows
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rows[indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier(row.identfier, forIndexPath: indexPath)
//        switch (row, cell) {
//        case (.Description(let t), let c as KATextViewTableViewCell):
//            c.textView.text = t
//            descriptionTextView = c.textView
//        ca
//        }
        return cell
    }

}
