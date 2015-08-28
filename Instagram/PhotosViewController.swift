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
        
        refreshTable(true)
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
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.mediaDict != nil) {
            return self.mediaDict!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x:0, y:0 , width: 50, height:50))
        headerView.backgroundColor = UIColor(white:1, alpha:0.9)
        var profileView = UIImageView(frame: CGRect(x:10, y:10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        var url = getImageAtIndex(section)
        profileView.setImageWithURL(url)
        headerView.addSubview(profileView)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30);
    }
    
    func getImageAtIndex(index: Int) -> NSURL{
        let mediaObj = mediaDict![index] as NSDictionary
        var imageUrl = mediaObj.valueForKeyPath("images.low_resolution.url") as! String
        var url = NSURL(string: imageUrl)!
        return url
    }
    
    func refreshTable (append : Bool) {
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=8f8f7c19b14c4a548330197a139d8ce8")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue:  NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                if (self.mediaDict == nil) {
                    self.mediaDict = json["data"] as? [NSDictionary]
                } else {
                    var mergedDict: [NSDictionary]?
                    var toMergeDict: [NSDictionary]?
                    if (append) {
                        mergedDict = self.mediaDict
                        toMergeDict = json["data"] as? [NSDictionary]
                    } else {
                        toMergeDict = self.mediaDict
                        mergedDict = json["data"] as? [NSDictionary]
                    }
                    for (var i=0; i < toMergeDict!.count; i++){
                        var eachMedia = toMergeDict![i] as NSDictionary
                        mergedDict!.append(eachMedia);
                    }
                    self.mediaDict = mergedDict
                }
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var currentLimit = mediaDict?.count
        if (indexPath.section == currentLimit! - 1) {
            refreshTable(true);
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("MediaCell", forIndexPath: indexPath) as! PhotoTableCell
        var url = getImageAtIndex(indexPath.section)
        cell.instagramImageView.setImageWithURL(url)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let mediaObj = mediaDict![indexPath!.section] as NSDictionary
        vc.imageUrlString = mediaObj.valueForKeyPath("images.standard_resolution.url") as! String
    }
    
    func onRefresh() {
        refreshTable(false);
    }

}
