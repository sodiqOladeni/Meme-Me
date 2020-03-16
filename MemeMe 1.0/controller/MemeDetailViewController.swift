//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by sodiqOladeni on 15/03/2020.
//  Copyright © 2020 NotZero Technologies. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeDetailImage: UIImageView!
    var meme:Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newImage = meme?.newImage {
            memeDetailImage.image = newImage
        }
    }
}
