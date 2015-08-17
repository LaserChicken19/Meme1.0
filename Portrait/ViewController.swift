//
//  ViewController.swift
//  Portrait
//
//  Created by Chao Ju on 8/15/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let myTFDelegate = myTextFieldDelegate()
    var generatedImg: UIImage!
    
    let myMemeAttributes=[
        NSStrokeColorAttributeName:UIColor.blackColor() ,
        NSForegroundColorAttributeName: UIColor.whiteColor() ,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)! ,
        NSStrokeWidthAttributeName: -3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTextField.defaultTextAttributes=self.myMemeAttributes
        self.topTextField.borderStyle=UITextBorderStyle.None
        self.topTextField.delegate=myTFDelegate
        self.topTextField.textAlignment=NSTextAlignment.Center
        self.topTextField.text="TOP"
        self.bottomTextField.defaultTextAttributes=self.myMemeAttributes
        self.bottomTextField.borderStyle=UITextBorderStyle.None
        self.bottomTextField.delegate=myTFDelegate
        self.bottomTextField.textAlignment=NSTextAlignment.Center
        self.bottomTextField.text="BOTTOM"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.mainImage.image==nil {
            self.shareButton.enabled=false
        } else { self.shareButton.enabled=true }
        self.cameraButton.enabled=UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
        self.mainImage.image=nil
        self.shareButton.enabled=false
        self.mainImage.backgroundColor=UIColor.blackColor()
        self.topTextField.text="TOP"
        self.bottomTextField.text="BOTTOM"
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        let controller=UIImagePickerController()
        controller.delegate = self
        controller.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.mainImage.image=image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func takeAPickture(sender: AnyObject) {
        let controller=UIImagePickerController()
        controller.delegate=self
        controller.sourceType=UIImagePickerControllerSourceType.Camera
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func save() {
        var meme=Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, image: self.mainImage.image!, memedImage: self.generatedImg)
    }
    

    @IBAction func Share(sender: AnyObject) {
        self.generatedImg=generateMemedImage()
        let controller = UIActivityViewController(activityItems: [self.generatedImg], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification)->CGFloat {
        let userInfo=notification.userInfo
        let keyboardSize=userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
}

