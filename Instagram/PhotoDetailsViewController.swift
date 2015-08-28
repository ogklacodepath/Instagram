//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Golak Sarangi on 8/26/15.
//  Copyright (c) 2015 Golak Sarangi. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var imageUrlString: String!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 640;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("bigImageCell", forIndexPath: indexPath) as! PhotoDetailTableCell
        println(imageUrlString)
        var url = NSURL(string: imageUrlString)!
        cell.instagramImageView.setImageWithURL(url)
        return cell
    }
}
