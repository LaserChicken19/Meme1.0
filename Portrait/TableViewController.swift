//
//  TableViewController.swift
//  Portrait
//
//  Created by Chao Ju on 8/21/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object=UIApplication.sharedApplication().delegate
        let appDelegate=object as! AppDelegate
        memes=appDelegate.memes
        myTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell") as! MyCellStyle
        cell.img.image = memes[indexPath.row].memedImage
        cell.myLabel.text = memes[indexPath.row].topText + "..." + memes[indexPath.row].bottomText
        return cell
    }
    
    @IBAction func goToMeme(sender: UIBarButtonItem) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller=self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        controller.ig=memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
