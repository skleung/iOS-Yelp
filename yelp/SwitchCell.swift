//
//  SwitchCell.swift
//  yelp
//
//  Created by Sherman Leung on 4/17/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

// we just list the methods that should be implemented here
protocol SwitchCellDelegate {
  func switchCell (switchCell: SwitchCell, didChangeValue value:Bool);
}
class SwitchCell: UITableViewCell {

  @IBOutlet var labelView: UILabel!
  @IBOutlet var settingsSwitch: UISwitch!
  
  // doesn't have to have a delegate (why it's optional)
  // doesn't matter what class it is - being a delgate is fine
  var delegate: SwitchCellDelegate?
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func switchFlipped(sender: UISwitch) {
    delegate?.switchCell(self, didChangeValue:sender.on)
  }
}
