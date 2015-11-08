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
        refreshControl.addTarget(self, action: Selector("refreshItems"), forControlEvents: .ValueChanged)
        self.collectionView?.addSubview(refreshControl)
        self.collectionView?.alwaysBounceVertical = true
        
        self.tabBarController?.tabBarItem.title = "Kleinanzeigen"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadItems", name: "addedItem", object: nil)
        updateItemSizeForSizeClass(self.traitCollection)
        setupNavigationBar()
        loadItems()
    }
    
    
    func refreshItems() {
        KAModel.clearItemCache()
        loadItems()
    }
    
    func loadItems() {
        self.refreshControl.beginRefreshing()
        KAModel.loadItems({ (items, add) in
            self.refreshControl.endRefreshing()
            if add {
                print(items.count)
                print(items)
                let t: [KAItem] = items.flatMap { $0.1 }
                let sorted = t.reduce(self.items ?? []) {
                    return KAModel.sortInCategories($1, categories: $0 ?? [])
                    }.map {
                        ($0.0, $0.1.sort {
                            $0.date.earlierDate($1.date) == $0.date
                            })
                }

                self.items = sorted
            } else {
                self.items = items
                self.collectionView?.reloadData()

            }
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
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "bitspls.ka.header", forIndexPath: indexPath) as? KAHeaderView,
                category = self.items?[indexPath.section] {
                    header.label.text = KAItem.Category.Strings[category.0.rawValue - 1]
                    return header
            }
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
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
        print("segue ´")
        guard let identifier = segue.identifier,
            cell = sender as? KACollectionViewCell else {
                super.prepareForSegue(segue, sender: sender)
                return
        }
        
        switch identifier {
        case Storyboard.DetailSegue:
            guard let detailVC = segue.destinationViewController as? KADetailTableViewController else { break }
            if detailVC.item == nil {
                detailVC.item = cell.item
            }
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

