//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by HernanGCalabrese on 6/15/15.
//  Copyright (c) 2015 Ouiea. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var pickFromCameraButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber(float: 5.0)
        ]
        
        self.topText.tag = 1;
        self.topText.defaultTextAttributes = memeTextAttributes
        self.topText.hidden = true
        self.topText.textAlignment = .Center
        self.topText.text = "TOP"
        self.topText.delegate = self
        
        self.bottomText.tag = 2;
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.hidden = true
        self.bottomText.textAlignment = .Center
        self.bottomText.text = "BOTTOM"
        self.bottomText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.pickFromCameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UITextFieldDelegate Text methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            println("textFieldShouldBeginEditing TOP")
        }else{
            println("textFieldShouldBeginEditing BOTTOM")
            self.subscribeToKeyboardNotifications()
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" ||  textField.text == "TOP" {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField.tag == 1 {
                textField.text = "TOP"
            }else{
                textField.text = "BOTTOM"
            }
        }
        if textField.tag == 2 {
            self.unsubscribeFromKeyboardNotifications()
        }
        textField.text = textField.text.uppercaseString
    }
    
    // UIImagePickerControllerDelegate imagePicker methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.topText.hidden = false
            self.bottomText.hidden = false
            self.imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.navigationController?.setToolbarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
    
    func save() {
        let image = self.imagePickerView.image!
        let generatedImage = self.generateMemedImage()
        
        var meme = Meme(topText: self.topText.text, bottomText: self.bottomText.text, image: image, memedImage: generatedImage)
        println("saved")
    }
    
    // Keyboard Observer
    func keyboardWillShow(notification: NSNotification) {
        println("keyboardWillShow")

        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    func subscribeToKeyboardNotifications() {
        println("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //IB Actions
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func saveMeme(sender: AnyObject) {
        if let navController = self.navigationController {
            println("nav controller not found")
            //navController.setToolbarHidden(true, animated: false)
        }else{
            println("nav controller not found")
        }
        
        //self.navigationController?.setToolbarHidden(true, animated: false)
        
        //self.save()
    }
    
    
    
}

