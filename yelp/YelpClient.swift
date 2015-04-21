//
//  YelpClient.swift
//  yelp
//
//  Created by Sherman Leung on 4/17/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//


import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
  var accessToken: String!
  var accessSecret: String!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
    self.accessToken = accessToken
    self.accessSecret = accessSecret
    var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
    super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
    
    var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
    self.requestSerializer.saveAccessToken(token)
  }
  
  func searchWithTerm(term: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    var parameters = ["term": term, "location": "San Francisco"]

    return self.GET("search", parameters: parameters, success: success, failure: failure)
  }
  
  func advancedSearch(term: String, sortMode: Int, radius: Double, dealsFlag: Bool, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    var parameters = ["term": term, "location": "San Francisco", "sort": sortMode, "radius_filter": radius, "deals_filter": dealsFlag == true ? "true" : "false"]
    println("searching with parameters!")
    println(parameters)
    return self.GET("search", parameters: parameters, success: success, failure: failure)
  }
  
}