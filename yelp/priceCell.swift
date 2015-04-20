//
//  priceCell.swift
//  yelp
//
//  Created by Sherman Leung on 4/18/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

protocol PriceCellDelegate {
  func setPrices(priceCell: priceCell, price: String)
}
class priceCell: UITableViewCell {
  var delegate : PriceCellDelegate?
  @IBOutlet var priceControl: UISegmentedControl!
  
  @IBAction func priceChanged(sender: AnyObject) {
    delegate?.setPrices(self, price: self.priceControl.titleForSegmentAtIndex(priceControl.selectedSegmentIndex)!)
  }
}
