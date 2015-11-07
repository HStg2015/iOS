//
//  KAAddItemViewController.swift
//  bitspls
//
//  Created by Sam Eckert on 07.11.15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class KAAddItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var plzField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var thumbnailView: UIButton!


    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupStatusBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupStatusBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.bitsplsOrangeBright()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLayoutSubviews() {
        
        self.scrollView.scrollEnabled = true
        var contentHeight:CGFloat = 0.0
        
        let subViews = self.scrollView.subviews
        for subview in subViews{
            
            if subview.frame.origin.y + subview.frame.size.height > contentHeight {
                
                contentHeight = subview.frame.origin.y + subview.frame.size.height
            }
        }
        
        contentHeight += 70
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, contentHeight)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
