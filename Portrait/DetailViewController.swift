//
//  DetailViewController.swift
//  Portrait
//
//  Created by Chao Ju on 8/21/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    var ig: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        detailImage.image=ig
    }
    
    
}
