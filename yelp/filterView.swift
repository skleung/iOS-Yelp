//
//  filterView.swift
//  yelp
//
//  Created by Sherman Leung on 4/16/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate {
  func filterViewController(filtersViewControllers: filterView, didUpdateFilters filters:[String:Bool], radiusFilter: Double);
}

class filterView: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, PriceCellDelegate, DistanceCellDelegate  {

  @IBOutlet var tableView: UITableView!
  var prices = [String]()
  var delegate: FiltersViewDelegate?
  var headerTitles = ["Price", "Most Popular", "Distance", "Sort by", "General Features"]
  var mostPopularTitles = ["Open Now", "Delivery", "Offering a Deal", "Hot and New"]
  var mostPopularStates = [String:Bool]()
  var sortByTitles = ["Best Match", "Distance", "Highest Rated"]
  var generalFeatureTitles = ["Online Reservations", "Order Pickup or Delivery", "Online Booking", "Good For Groups", "Takes Reservations"]
  var sortByStates = [String: Bool]()
  var generalFeatureStates = [String: Bool]()
  var possibleDistances = [0.3, 1, 5, 20]
  var distance : Double! = 5.0
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // change text color in nav bar
      tableView.allowsSelection = false
      var nav = navigationController
      nav?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
      
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func searchButtonPressed(sender: AnyObject) {
    var cellState = [String:Bool]()
    for (key, value) in mostPopularStates {
      cellState[key] = value
    }
    for (key, value) in generalFeatureStates {
      cellState[key] = value
    }
    for (key, value) in sortByStates {
      cellState[key] = value
    }
    println(distance)
    delegate?.filterViewController(self, didUpdateFilters: cellState, radiusFilter: distance)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func setDistance(cell: distanceCell) {
    println("call me!")
    distance = possibleDistances[cell.distanceControl.selectedSegmentIndex]
    println(distance)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0 || section == 2) { return 1 }
    if (section == 1) {return self.mostPopularTitles.count }
    if (section == 3) {return self.sortByTitles.count }
    return self.generalFeatureTitles.count
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 65
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if (indexPath.section == 0) {
      let cell = tableView.dequeueReusableCellWithIdentifier("priceCell", forIndexPath: indexPath) as! priceCell
      return cell
    }
    if (indexPath.section == 1) {
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      
      cell.labelView.text = mostPopularTitles[indexPath.row]
      setUpSwitchCell(cell, row: indexPath.row)
      return cell
    }
    if (indexPath.section == 2) {
      let cell = tableView.dequeueReusableCellWithIdentifier("distanceCell", forIndexPath: indexPath) as! distanceCell
      // sets the delegate so that the cell knows who to send the function response to
      cell.delegate = self
      return cell
    }
    if (indexPath.section == 3) {
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      // sets the delegate so that the cell knows who to send the function response to
      cell.labelView.text = sortByTitles[indexPath.row]
      setUpSortSwitchCell(cell, row: indexPath.row)
      return cell
    }
    if (indexPath.section == 4) {
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      // sets the delegate so that the cell knows who to send the function response to
        cell.labelView.text = generalFeatureTitles[indexPath.row]
        setUpGeneralCell(cell, row: indexPath.row)
        return cell
      }
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      return cell
  }
  
  func setUpSwitchCell(cell: SwitchCell, row: Int) {
    cell.delegate = self
    let switchState = mostPopularStates[mostPopularTitles[row]]
    if let state = switchState {
      cell.settingsSwitch.on = state
    } else {
      cell.settingsSwitch.on = false
      mostPopularStates[mostPopularTitles[row]] = false
    }
  }
  func setUpGeneralCell(cell: SwitchCell, row: Int) {
    cell.delegate = self
    let switchState = generalFeatureStates[generalFeatureTitles[row]]
    if let state = switchState {
      cell.settingsSwitch.on = state
    } else {
      cell.settingsSwitch.on = false
      generalFeatureStates[generalFeatureTitles[row]] = false
    }
  }
  
  func setUpSortSwitchCell(cell: SwitchCell, row: Int) {
    cell.delegate = self
    let switchState = sortByStates[sortByTitles[row]]
    if let state = switchState {
      cell.settingsSwitch.on = state
    } else {
      cell.settingsSwitch.on = false
      sortByStates[sortByTitles[row]] = false
    }
  }
  
  func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
    let indexPath = tableView.indexPathForCell(switchCell)
    if (indexPath!.section == 1) {
      mostPopularStates[mostPopularTitles[indexPath!.row]] = value
    } else if (indexPath!.section == 3) {
      sortByStates[sortByTitles[indexPath!.row]] = value
    } else {
      generalFeatureStates[generalFeatureTitles[indexPath!.row]] = value
    }
    
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 5
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return headerTitles[section]
  }
  
  func setPrices(cell: priceCell, price: String) {
      prices.append(price)
//    var selectedIndicies = cell.priceControl.selectedIndexes()
//    for i in selectedIndicies {
//      prices.append(cell.priceControl!.titleForSegmentAtIndex(i as! Int))
//    }
    
  }
  
  
  
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
