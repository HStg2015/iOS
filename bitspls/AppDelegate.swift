//
//  AppDelegate.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit



@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let vc = KAViewController() as UIViewController

    var shortcutItem: UIApplicationShortcutItem?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if let viewController = self.window?.rootViewController as? KAViewController{
            
            self.vc.navigationController?.navigationBar.barTintColor = UIColor.bitsplsOrangeBright()
            self.vc.navigationController?.navigationBar.barStyle = UIBarStyle.Black
            self.vc.navigationController?.setNeedsStatusBarAppearanceUpdate()
        }
        
        var performShortcutDelegate = true
        
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                
                print("Application launched via shortcut")
                self.shortcutItem = shortcutItem
                
                performShortcutDelegate = false
                
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        return performShortcutDelegate
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
        handleShortcut(shortcut)
        
        self.shortcutItem = nil
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let urlString = "\(url)"
        
        if urlString == "donaid://addDonation"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let navVC = storyboard.instantiateViewControllerWithIdentifier("addDonation") as! UINavigationController
            
            self.window?.rootViewController?.presentViewController(navVC, animated: true, completion: nil)
        }
        return true
    }
    
    @available(iOS 9.0, *)
    func handleShortcut( shortcutItem:UIApplicationShortcutItem ) -> Bool {
        print("Handling shortcut")
        
        var succeeded = false
        
        if( shortcutItem.type == "com.donaid.iOS.addDonation" ) {
            
            // Add your code here
            print("- Handling \(shortcutItem.type)")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateViewControllerWithIdentifier("addDonation") as! UINavigationController
            self.window?.rootViewController?.presentViewController(navVC, animated: true, completion: nil)

            
            
            succeeded = true
            
        }
        
        return succeeded
        
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        print("Application performActionForShortcutItem")
        completionHandler( handleShortcut(shortcutItem) )
        
    }
}
