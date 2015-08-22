//
//  CollectionViewController.swift
//  Portrait
//
//  Created by Chao Ju on 8/22/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//
import Foundation

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var myCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize=CGSizeMake(dimension, dimension)
        myCollection.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes=appDelegate.memes
        myCollection.reloadData()
    }

    @IBAction func addPhoto(sender: UIBarButtonItem) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! myCollectionCellStyle
        let meme = memes[indexPath.item]
        cell.imgv.image = meme.memedImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        controller.ig = memes[indexPath.item].memedImage
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    


}
