//
//  KAAddFormViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 08/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import Eureka
import BusyNavigationBar

class KAAddFormViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.addParallaxWithImage(UIImage(named: "placeholder"), andHeight: 150)
        form +++ Section()
            <<< ImageRow("image") {
                $0.title = "Bild"
                }.onChange {
                    if let image = $0.value {
                        self.tableView?.addParallaxWithImage(image, andHeight: 150)
                    }
        }
        
        form +++ Section()
            <<< TextFloatLabelRow("title") {
                $0.title = "Title"
        }
        
        form +++ Section("Beschreibung")
            <<< TextAreaRow("description") {
                $0.placeholder = "Beschreibe es..."
        }
        form +++ Section()
            
            <<< PickerInlineRow<String>("category") {
                $0.title = "Kategorie"
                $0.options = KAItem.Category.Strings
            }
            
            <<< TextFloatLabelRow("location") {
                $0.title = "PLZ oder Stadt"
            }
            <<< TextFloatLabelRow("tel") {
                $0.title = "Telefon"
                $0.cell.textField.keyboardType = .PhonePad
            }
            <<< TextFloatLabelRow("mail") {
                $0.title = "E-Mail"
                $0.cell.textField.keyboardType = .EmailAddress
                $0.cell.textField.autocorrectionType = .No
        }
        
        
        
        
        setupStatusBar()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func done(sender: UIBarButtonItem) {
        guard let title: String = form.rowByTag("title")?.value,
        des: String = form.rowByTag("description")?.value,
            category = (form.rowByTag("category") as? PickerInlineRow<String>)?.value.flatMap({ KAItem.Category.Strings.indexOf($0) }),
        loc: String = form.rowByTag("location")?.value,
        phone: String = form.rowByTag("tel")?.value,
        mail: String = form.rowByTag("mail")?.value else {
            let alert = UIAlertController(title: "Error", message: "Alle Felder ausfüllen", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in })
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let image = (form.rowByTag("image") as? ImageRow)?.value
        
        startNavBarLoading()

        KAModel.saveItem(title, description: des, category: category + 1, location: loc, phone: phone, mail: mail, image: image) { error in
            self.navigationController?.navigationBar.stop()
            if let e = error {
                let alert = UIAlertController(title: "Error", message: (e as NSError).localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in })
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("addedItem", object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func startNavBarLoading() {
        let options = BusyNavigationBarOptions()
        options.animationType = .Stripes
        options.color = UIColor.redColor()
        options.alpha = 1
        options.barWidth = 20
        options.gapWidth = 30
        options.speed = 1
       // options.transparentMaskEnabled = true
        
        self.navigationController?.navigationBar.start(options)
        
    }
    
    func setupStatusBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.bitsplsOrangeBright()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}



