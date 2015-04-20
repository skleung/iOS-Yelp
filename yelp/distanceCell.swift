//
//  distanceCell.swift
//  yelp
//
//  Created by Sherman Leung on 4/18/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

protocol DistanceCellDelegate {
  func setDistance(cell: distanceCell)
}

class distanceCell: UITableViewCell {
  var delegate: DistanceCellDelegate?
  
  @IBOutlet var distanceControl: UISegmentedControl!
  @IBAction func distanceChanged(sender: UISegmentedControl) {
    delegate?.setDistance(self)
  }
}
