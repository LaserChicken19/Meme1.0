//
//  MemeEditorController.swift
//  Portrait
//
//  Created by Chao Ju on 8/15/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
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
        topTextField.defaultTextAttributes=self.myMemeAttributes
        topTextField.borderStyle=UITextBorderStyle.None
        topTextField.delegate=myTFDelegate
        topTextField.textAlignment=NSTextAlignment.Center
        topTextField.text="TOP"
        bottomTextField.defaultTextAttributes=self.myMemeAttributes
        bottomTextField.borderStyle=UITextBorderStyle.None
        bottomTextField.delegate=myTFDelegate
        bottomTextField.textAlignment=NSTextAlignment.Center
        bottomTextField.text="BOTTOM"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if  mainImage.image==nil {
            shareButton.enabled=false
        } else { shareButton.enabled=true }
        
        cameraButton.enabled=UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    @IBAction func Cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        let controller=UIImagePickerController()
        controller.delegate = self
        controller.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage {
                mainImage.image=image
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
        
        topToolBar.hidden=true
        bottomToolBar.hidden=true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topToolBar.hidden=false
        bottomToolBar.hidden=false
        return memedImage
    }
    
    func save() {
        var meme=Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: mainImage.image!, memedImage: self.generatedImg)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
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
        self.view.frame.origin.y = -getKeyboardHeight(notification)
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

