//
//  ViewController.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit

class KAViewController: UICollectionViewController {
    
    private struct Storyboard {
        static let KACell = "bitspls.ka.cell"
        static let DetailSegue = "bitspls.ka.detail.segue"
    }
    
    lazy var testData: [KAItem] = {
        return (0...20).map { KAItem(test: "Test \($0)") }
    }()
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.KACell, forIndexPath: indexPath)
        guard let kaCell = cell as? KACollectionViewCell where testData.count > indexPath.row else { return cell }
        kaCell.item = testData[indexPath.row]
        return kaCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier,
            cell = sender as? KACollectionViewCell else {
                super.prepareForSegue(segue, sender: sender)
                return
        }
        
        switch identifier {
        case Storyboard.DetailSegue:
            guard let detailVC = segue.destinationViewController as? KADetailViewController else { break }
            detailVC.item = cell.item
        default: break
        }
    }
}

