//
//  FeedVC.swift
//  Dobro
//
//  Created by Dev1 on 1/11/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var category: Category!
    static var imageCache = NSCache()
    let postLimit = 10
    var postSkip = 0
    var postCount = 0
    var refreshControl:UIRefreshControl!
    var loadMoreStatus = false
    var isRefreshing = false
    var preventAnimation = Set<NSIndexPath>()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeDidChangeNotification:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.postsCount()
        self.parseDataFromParse()
    }
    
    func postsCount() {
        let PostsQuery: PFQuery =  PFQuery(className:"Post")
        currentLoc = PFGeoPoint(location: MapViewLocationManager.location)
        PostsQuery.whereKey("location", nearGeoPoint: currentLoc, withinKilometers: 50)
        
        if category != nil {
            PostsQuery.whereKey("category", equalTo: PFObject(withoutDataWithClassName: "Category", objectId: category.categoryId!))
        }
        PostsQuery.countObjectsInBackgroundWithBlock {
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                self.postCount = Int(count)
            }
        }
    }
    
    func parseDataFromParse() {
        
        let PostsQuery: PFQuery =  PFQuery(className:"Post")
        currentLoc = PFGeoPoint(location: MapViewLocationManager.location)
        PostsQuery.whereKey("location", nearGeoPoint: currentLoc, withinKilometers: 50)
        PostsQuery.includeKey("category")
        PostsQuery.includeKey("user")
        PostsQuery.addDescendingOrder("createdAt")
        if category != nil {
            PostsQuery.whereKey("category", equalTo: PFObject(withoutDataWithClassName: "Category", objectId: category.categoryId!))
        }
        PostsQuery.skip = postSkip
        PostsQuery.limit = postLimit
//        PostsQuery.cachePolicy = .NetworkElseCache
        PostsQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            if !self.loadMoreStatus {
                self.posts = []
            }
            if error == nil {
                for object in objects! {
                    
                    let key = object.objectId as String!
                    let date = object.createdAt as NSDate!
                    let post = Post(postKey: key, date: date, dictionary: object)
                    self.posts.append(post)
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    func refresh(sender:AnyObject) {
        self.isRefreshing = true
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.refreshControl.endRefreshing()
                self.isRefreshing = false
        })
        
    }
    
    func refreshBegin(newtext:String, refreshEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.preventAnimation.removeAll()
                self.postSkip = 0
                self.parseDataFromParse()
                self.tableView.reloadData()
            }
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                refreshEnd(0)
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 0 {
            loadMore()
        }
    }
    
    func loadMore() {
        if !loadMoreStatus && !isRefreshing {
            self.loadMoreStatus = true
            loadMoreBegin("Load more",
                loadMoreEnd: {(x:Int) -> () in
                    self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.postSkip += self.postLimit
                if self.postSkip <= self.postCount {
                    self.parseDataFromParse()
                } else {
                    self.loadMoreStatus = true
                }
            }
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                loadMoreEnd(0)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            let tap = UITapGestureRecognizer(target: self, action: "showImageViewer:")
            cell.featuredImg.addGestureRecognizer(tap)
            cell.featuredImg.tag = indexPath.row
            
            var img: UIImage?
            
            if let url = post.featuredImg {
                
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
                
            }
            
            cell.configureCell(post, img: img)

            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            cell.alpha = 0
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                cell.alpha = 1
            })
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let post = self.posts[indexPath.row]
        
        performSegueWithIdentifier("EventVC", sender: post.postKey)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventVC" {
            if let eventVC = segue.destinationViewController as? EventVC {
                if let postKey = sender as? String {
                    eventVC.postKey = postKey
                }
            }
        }
    }


}
