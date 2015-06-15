//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by HernanGCalabrese on 6/15/15.
//  Copyright (c) 2015 Ouiea. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    func viewWillAppear() {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        self.memes = applicationDelegate.memes
        println("SentMemeTableViewController Loaded \(self.memes.count) memes")
    }
    
    // Delegates
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.memeTopLabel.text = meme.topText
        cell.memeBottomLabel.text = meme.bottomText
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
    
    
    
}