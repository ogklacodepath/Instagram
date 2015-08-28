//
//  PhotoModalViewController.swift
//  Instagram
//
//  Created by Golak Sarangi on 8/28/15.
//  Copyright (c) 2015 Golak Sarangi. All rights reserved.
//

import UIKit

class PhotoModalViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageUrlString: String!
    
    @IBOutlet weak var modalImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var url = NSURL(string: imageUrlString)!
        modalImageView.setImageWithURL(url)
        scrollView.contentSize = modalImageView.image!.size
        scrollView.delegate = self
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return modalImageView
    }
}
