//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by HernanGCalabrese on 6/15/15.
//  Copyright (c) 2015 Ouiea. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {

    var meme: Meme!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("MemeDetailViewController loaded")
        println(meme.topText)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = meme.memedImage
    }
    
}