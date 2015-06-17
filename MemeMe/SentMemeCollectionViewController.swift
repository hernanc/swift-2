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

    var memes: [Meme]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func viewWillAppear() {
        reloadTableData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memes_count = memes?.count {
            if memes_count == 0 {
                println("memes = 0, need meme")
                getMeme()
            }
        } else {
            println("self.memes not set, reloading")
            reloadTableData()
            
        }
    }
    
    func getMeme(){
        var controller = storyboard?.instantiateViewControllerWithIdentifier("makeMemeViewController") as! UIViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func reloadTableData(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        println("Loaded \(memes.count) memes")
        collectionView.reloadData()
    }
    
    // Delegates
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let meme_count = memes?.count {
            return meme_count
        }else{
            reloadTableData()
            
        }
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeTopLabel.text = meme.topText
        cell.memeBottomLabel.text = meme.bottomText
        cell.memeImageView?.image = meme.image
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }

    
    
    
    
}