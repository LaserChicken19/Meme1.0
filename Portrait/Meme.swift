//
//  Meme.swift
//  Portrait
//
//  Created by Chao Ju on 8/17/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//

import UIKit

struct Meme {
    
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText=topText
        self.bottomText=bottomText
        self.image=image
        self.memedImage=memedImage
    }
}