//
//  RestaurantCell.swift
//  yelp
//
//  Created by Sherman Leung on 4/17/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

  @IBOutlet var distanceLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var photoView: UIImageView!
  @IBOutlet var categoryLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var reviewsLabel: UILabel!
  @IBOutlet var ratingImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setDetails(details: NSDictionary) {
    nameLabel.text = details["name"] as! String
    var url = NSURL(string: details["image_url"] as! String)
    photoView.setImageWithURL(url!)
    var addressArray = details.valueForKeyPath("location.address") as! [String]
    var address = addressArray[0]
    address = address + ", " + (details.valueForKeyPath("location.city") as! String)
    addressLabel.text = address
    var rating_url = details["rating_img_url"] as! String
    ratingImage.setImageWithURL(NSURL(string: rating_url)!)
    reviewsLabel.text = NSString(format: "%ld Reviews", details["review_count"] as! Int) as! String
    distanceLabel.text = "0.07 mi."//NSString(format: "%.2f mi", details["distance"] as! CGFloat)
  }
  
  override func layoutSubviews() {
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
  }
}
