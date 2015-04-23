//
//  mainView.swift
//  yelp
//
//  Created by Sherman Leung on 4/16/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class mainView: UIViewController, FiltersViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var client: YelpClient!
    var refreshControl: UIRefreshControl!
    var searchActive : Bool = false
    var useFilters : Bool = false
    var filters = [String:Bool]()
    var searchWord : String! = "Thai"
    var radius_filter : Double = 100
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
      tableView.rowHeight = UITableViewAutomaticDimension
      
      //get location

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
      // adds HUD
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)

      
      tableView.dataSource = self
      tableView.delegate = self
      searchBar.delegate = self
    }
  
  func onRefresh() {
    search("Thai")
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 113
  }
  
  func search(query: String) {
    client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    if (useFilters) {
      // implement sort (best match, distance, highest rated), radius (meters), deals (on/off).
      var sortMode = 0
      if (filters.indexForKey("Distance") != nil && filters["Distance"]!) {
        sortMode = 1
      }
      if (filters.indexForKey("Highest Rated") != nil && filters["Highest Rated"]!) {
        sortMode = 2
      }
      
      var dealsFlag = false
      if (filters.indexForKey("Offering a Deal") != nil && filters["Offering a Deal"]!) {
        dealsFlag = true
      }
      client.advancedSearch(query, sortMode: sortMode, radius: radius_filter, dealsFlag: dealsFlag, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        self.results = response["businesses"] as! [NSDictionary]
        println(self.results)
        self.tableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
          self.errorView.hidden = false
          self.errorText.text = "\(error)"
          MBProgressHUD.hideHUDForView(self.view, animated: true)
      }
      
    } else {
      client.searchWithTerm(query, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        self.results = response["businesses"] as! [NSDictionary]
        self.tableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
          self.errorView.hidden = false
          self.errorText.text = "\(error)"
          MBProgressHUD.hideHUDForView(self.view, animated: true)
      }
    }
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchActive = true;
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
    searchWord = searchBar.text
    search(searchWord)
    searchBar.resignFirstResponder()
  }
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    searchWord = searchText
    search(searchWord)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func filterViewController(filtersViewControllers: filterView, didUpdateFilters filters:[String:Bool], radiusFilter: Double) {
      // run the search with the new filters
      self.filters = filters
      self.radius_filter = radiusFilter
      useFilters = true
      println(radiusFilter)
      search(searchWord)
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
