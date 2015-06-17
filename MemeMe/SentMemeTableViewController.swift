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
    
    @IBOutlet weak var tableView: UITableView!
    
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
            println("self.memes not set")
            getMeme()
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
        tableView.reloadData()
    }
    
    //Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes_count = memes?.count {
            return memes_count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
}