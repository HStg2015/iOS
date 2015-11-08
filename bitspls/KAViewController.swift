//
//  ViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class KAViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // IBOutlets:
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    // IBActions:
    @IBAction func addAction(sender: AnyObject) {
    }
    
    private struct Storyboard {
        static let KACell = "bitspls.ka.cell"
        static let DetailSegue = "bitspls.ka.detail.segue"
    }
    private let refreshControl = UIRefreshControl()
    private var items: [(KAItem.Category, [KAItem])]? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: Selector("loadItems"), forControlEvents: .ValueChanged)
        self.collectionView?.addSubview(refreshControl)
        self.collectionView?.alwaysBounceVertical = true
        updateItemSizeForSizeClass(self.traitCollection)
        setupNavigationBar()
        loadItems()
    }
    
    
    func loadItems() {
        self.refreshControl.beginRefreshing()
        KAModel.loadItems({
            self.refreshControl.endRefreshing()
            self.items = $0
            }) { error in
                print(error)
                self.refreshControl.endRefreshing()
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                }
        }
    }
    

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return items?.count ?? 0
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?[section].1.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.KACell, forIndexPath: indexPath)
        guard let itemCell = cell as? KACollectionViewCell else { return cell }
        itemCell.item = items?[indexPath.section].1[indexPath.row]
        return itemCell
    }
    
    
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ ctx in
            self.updateItemSizeForSizeClass(newCollection)
            }, completion: nil)
    }
    
    private func updateItemSizeForSizeClass(newCollection: UITraitCollection) {
        (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width = newCollection.horizontalSizeClass == .Compact ? 150 : 250
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier,
            cell = sender as? KACollectionViewCell else {
                super.prepareForSegue(segue, sender: sender)
                return
        }
        
        switch identifier {
        case Storyboard.DetailSegue:
            guard let detailVC = segue.destinationViewController as? KADetailTableViewController else { break }
            detailVC.item = cell.item
        default: break
        }
    }
  
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.bitsplsOrangeBright()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}

