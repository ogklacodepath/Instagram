//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Golak Sarangi on 8/26/15.
//  Copyright (c) 2015 Golak Sarangi. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var mediaDict : [NSDictionary]?
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        /*NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: <#NSData!#>, error: <#NSError!#>) -> Void in
            let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)!
            println(json);
        })*/
        
        refreshTable()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 320;
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        //self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.mediaDict != nil) {
            return self.mediaDict!.count
        } else {
            return 0
        }
    }
    
    
    func refreshTable () {
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=8f8f7c19b14c4a548330197a139d8ce8")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue:  NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                self.mediaDict = json["data"] as? [NSDictionary]
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("creating table again");
        var cell = tableView.dequeueReusableCellWithIdentifier("MediaCell", forIndexPath: indexPath) as! PhotoTableCell
        let mediaObj = mediaDict![indexPath.row] as NSDictionary
        var imageUrl = mediaObj.valueForKeyPath("images.low_resolution.url") as! String
        var url = NSURL(string: imageUrl)!
        cell.instagramImageView.setImageWithURL(url)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let mediaObj = mediaDict![indexPath!.row] as NSDictionary
        vc.imageUrlString = mediaObj.valueForKeyPath("images.standard_resolution.url") as! String
    }
    
    func onRefresh() {
        println("refreshing data");
        refreshTable();
    }

}
