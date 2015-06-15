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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func viewWillAppear() {
        self.reloadTableData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memes_count = self.memes?.count {
            if memes_count == 0 {
                println("memes = 0, need meme")
                self.getMeme()
            }
        } else {
            println("self.memes not set, reloading")
            self.reloadTableData()
            
        }
    }
    
    func getMeme(){
        var controller = self.storyboard?.instantiateViewControllerWithIdentifier("makeMemeViewController") as! UIViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func reloadTableData(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        self.memes = applicationDelegate.memes
        println("Loaded \(self.memes.count) memes")
        self.collectionView.reloadData()
    }
    
    // Delegates
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let meme_count = self.memes?.count {
            return meme_count
        }else{
            self.reloadTableData()
            
        }
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