//
//  mainView.swift
//  yelp
//
//  Created by Sherman Leung on 4/16/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class mainView: UIViewController, FiltersViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var client: YelpClient!
    var refreshControl: UIRefreshControl!
  
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    @IBOutlet var errorText: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var errorView: UIView!
    var results = [NSDictionary]()
      required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width as! CGFloat, height: 30))
    override func viewDidLoad() {
      super.viewDidLoad()
      // set navigation view color text
      self.navigationItem.titleView = searchBar
      var nav = navigationController
      nav?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
      
      client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
      
      client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        self.results = response["businesses"] as! [NSDictionary]
        self.tableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
          self.errorView.hidden = false
          self.errorText.text = "\(error)"
          MBProgressHUD.hideHUDForView(self.view, animated: true)
      }
      refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      tableView.rowHeight = UITableViewAutomaticDimension
      // adds HUD
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)

      
      tableView.dataSource = self
      tableView.delegate = self
    }
  
  func onRefresh() {
    client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      self.results = response["businesses"] as! [NSDictionary]
      self.tableView.reloadData()
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        self.errorView.hidden = false
        self.errorText.text = "\(error)"
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func filterViewController(filtersViewControllers: filterView, didUpdateFilters filters:[String:Bool], possiblePrices: [String]) {
      // run the search with the new filters
      NSLog("received: \(filters)")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "PresentFilters" {
        let filtersNC = segue.destinationViewController as! UINavigationController
        let filtersVC = filtersNC.viewControllers[0] as! filterView
        filtersVC.delegate = self
      }
    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      var cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantCell
      cell.setDetails(results[indexPath.row])
      return cell
  }


}
