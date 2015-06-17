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
    
    
    @IBOutlet weak var memeContainer: UIView!
    @IBOutlet weak var pickFromCameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultTextAttributes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickFromCameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setDefaultTextAttributes() {
        var shadow = NSShadow()
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.blackColor()
        
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSShadowAttributeName : shadow
        ]
        
        topText.tag = 1;
        topText.defaultTextAttributes = memeTextAttributes
        topText.hidden = true
        topText.textAlignment = .Center
        topText.text = "TOP"
        topText.delegate = self
        
        bottomText.tag = 2;
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.hidden = true
        bottomText.textAlignment = .Center
        bottomText.text = "BOTTOM"
        bottomText.delegate = self
    }
    
    // UITextFieldDelegate Text methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == topText {
            println("textFieldShouldBeginEditing TOP")
        } else {
            println("textFieldShouldBeginEditing BOTTOM")
            subscribeToKeyboardNotifications()
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
            if textField == topText {
                textField.text = "TOP"
            } else {
                textField.text = "BOTTOM"
            }
        }
        if textField == bottomText {
            unsubscribeFromKeyboardNotifications()
        }
        textField.text = textField.text.uppercaseString
    }
    
    // UIImagePickerControllerDelegate imagePicker methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            topText.hidden = false
            bottomText.hidden = false
            memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        toolBar.hidden = true
        
        // Render view to an image
        let size = memeContainer.frame.size
        UIGraphicsBeginImageContext(size)
        
        memeContainer.drawViewHierarchyInRect(memeContainer.bounds, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        
        if let image = memeImageView.image {
            
            let generatedImage = generateMemedImage()
            
            let meme = Meme(topText: topText.text, bottomText: bottomText.text, image: image, memedImage: generatedImage)
            
            println("saved")
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
            
            println("MEMES SAVED: ")
            println((UIApplication.sharedApplication().delegate as! AppDelegate).memes.count)
            
        } else {
            println("Image does not exist, returning")
            return
        }
        
    }
    
    // Keyboard Observer
    func keyboardWillShow(notification: NSNotification) {
        println("keyboardWillShow")

        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y += getKeyboardHeight(notification)
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        shareButton.enabled = false
        
        var image = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activityType: String!, completed: Bool, items: [AnyObject]!, err:NSError!) in
            if completed {
                println("Sharing completed, saving")
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                println("Sharing cancelled")
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
        
        shareButton.enabled = true
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        println("Cancel pressed")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

