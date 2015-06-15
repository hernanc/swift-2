//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by HernanGCalabrese on 6/15/15.
//  Copyright (c) 2015 Ouiea. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    
    func viewWillAppear() {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        self.memes = applicationDelegate.memes
        
        
        
        println("SentMemeTableViewController Loaded \(self.memes.count) memes")
    }

    //Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes_count = self.memes?.count {
            return memes_count
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}