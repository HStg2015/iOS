//
//  IHViewController.swift
//  bitspls
//
//  Created by Sam Eckert on 07.11.15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class IHViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStatusBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupStatusBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.bitsplsOrangeBright()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
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
