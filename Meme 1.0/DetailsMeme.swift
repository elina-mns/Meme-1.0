//
//  DetailsMeme.swift
//  Meme 1.0
//
//  Created by Elina Mansurova on 2020-09-14.
//  Copyright © 2020 Elina Mansurova. All rights reserved.
//

import UIKit

class DetailsMeme: UIViewController {
    
    var memeDetail: Meme!

    @IBOutlet weak var imageDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageDetail.image = memeDetail.image
    }
}
