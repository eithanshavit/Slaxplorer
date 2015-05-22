//
//  CloudManager.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  CloudManager class provides an abstraction layer for web operations

import UIKit
import Alamofire
import SwiftyJSON

public enum CloudManagerConnectionStatus {
  case OK
  case NotAuth
  case InvalidAuth
  case ConnectionFailure
  case ParseFailure
  case UnknownFailure
}

public class CloudManager: NSObject {
  
  // MARK: - Constants
  
  let URLTeamInfo = "https://slack.com/api/team.info"
  let URLUsersList = "https://slack.com/api/users.list"
  
  // MARK: - State
  
  var alamofireManager: Alamofire.Manager!
  var dataStack: DataStack!
  
  // MARK: - Main Instance
  
  // The main CloudManager uses the Alamofire shared manager, and the shared DataStack.
  // If needed, create different CloudManagers with different configs
  class var mainManager: CloudManager {
    var cm = CloudManager()
    cm.alamofireManager = Alamofire.Manager.sharedInstance
    cm.dataStack = DataStack.sharedInstance
    return cm
  }
  
  // MARK: - Life Cycle
  
  public override init() {
    super.init()
  }
  
  convenience init(alamofireManager: Alamofire.Manager) {
    self.init()
    self.alamofireManager = alamofireManager
  }
  
  // MARK: - Team resources
  
  // Requests Team's info using a provided <token> and calls <completion> upon completion
  public func requestTeamInfoWithToken(token: String, completion: (TempTeam?, TeamDataStatus, CloudManagerConnectionStatus) -> Void) {
    // Escape given token
    let safeToken = token.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
    
    if safeToken == nil {
      // Report error with escaping token
      completion(nil, .Unknown, .InvalidAuth)
      return
    }
    
    // Request from web
    let params = [
      "token": safeToken!
    ]
    alamofireManager!
      .request(.GET, URLTeamInfo, parameters: params)
      .validate(statusCode: 200..<201)
      .responseJSON {
        (_: NSURLRequest, _: NSHTTPURLResponse?, json: AnyObject?, error: NSError?) -> Void in
        // Handle error
        if error != nil {
          // Error occurred
          completion(nil, .Unknown, .ConnectionFailure)
          return
        }
        let data = JSON(json!)
        
        // Check for OK status
        let resOK = data["ok"].bool
        if resOK == nil {
          // Unable to parse OK response
          completion(nil, .Unknown, .ParseFailure)
          return
        }
        if resOK! {
          // Response ok, create Team
          if let resId = data["team"]["id"].string, resName = data["team"]["name"].string {
            completion(TempTeam(id: resId, name: resName, token: safeToken!), .OK, .OK)
          } else {
            // Unable to parse team response
            completion(nil, .Unknown, .ParseFailure)
            return
          }
        } else {
          // Response not ok, figure out why
          let resError = data["error"].string
          if resError == nil {
            // Unable to parse Error in response
            completion(nil, .Unknown, .ParseFailure)
            return
          }
          switch resError! {
          case "account_inactive":
            completion(nil, .AccountInactive, .OK)
          case "not_authed":
            completion(nil, .Unknown, .NotAuth)
          case "invalid_auth":
            completion(nil, .Unknown, .InvalidAuth)
          case "user_is_bot":
            completion(nil, .UserIsBot, .OK)
          default:
            completion(nil, .Unknown, .UnknownFailure)
          }
        }
      }
  }
  
  // MARK: - Member resources
  
  // Requests user list of <team> and calls <completion> upon completion
  public func requestTeamMemberList(token: String, completion: ([TempMember]?, MemberListDataStatus, CloudManagerConnectionStatus) -> Void) {
    // Escape given token
    let safeToken = token.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
    
    if safeToken == nil {
      // Report error with escaping token
      completion(nil, .Unknown, .InvalidAuth)
      return
    }
    
    // Request from web
    let params = [
      "token": safeToken!
    ]
    alamofireManager!
      .request(.GET, URLUsersList, parameters: params)
      .validate(statusCode: 200..<201)
      .responseJSON {
        (_: NSURLRequest, _: NSHTTPURLResponse?, json: AnyObject?, error: NSError?) -> Void in
        // Handle error
        if error != nil {
          // Error occurred
          completion(nil, .Unknown, .ConnectionFailure)
          return
        }
        let data = JSON(json!)
        
        // Check for OK status
        let resOK = data["ok"].bool
        if resOK == nil {
          // Unable to parse OK response
          completion(nil, .Unknown, .ParseFailure)
          return
        }
        if resOK! {
          // Response ok, create Team
          let resMembers = data["members"]
          if resMembers == nil {
            // Unable to parse team response
            completion(nil, .Unknown, .ParseFailure)
            return
          }
          let members = self.createTempMembersWithJSON(resMembers)
          completion(members, .OK, .OK)
          
        } else {
          // Response not ok, figure out why
          let resError = data["error"].string
          if resError == nil {
            // Unable to parse Error in response
            completion(nil, .Unknown, .ParseFailure)
            return
          }
          switch resError! {
          case "account_inactive":
            completion(nil, .AccountInactive, .OK)
          case "not_authed":
            completion(nil, .Unknown, .NotAuth)
          case "invalid_auth":
            completion(nil, .Unknown, .InvalidAuth)
          default:
            completion(nil, .Unknown, .UnknownFailure)
          }
        }
    }
  }
  
  private func createTempMembersWithJSON(json: JSON) -> [TempMember] {
    var ret = [TempMember]()
    for (index: String, memberJSON: JSON) in json {
      // This next block seems scary. But it's all protected by SwiftyJSON.
      // Any optional values coming from the cloud will be registered as Swift optionals.
      let member: TempMember = {
        var m = TempMember()
        m.id = memberJSON["id"].stringValue
        m.username = memberJSON["name"].stringValue
        m.isActive = !memberJSON["deleted"].boolValue
        m.isAdmin = memberJSON["is_admin"].boolValue
        m.isOwner = memberJSON["is_owner"].boolValue
        m.image48URL = memberJSON["profile"]["image_48"].stringValue
        m.image192URL = memberJSON["profile"]["image_192"].stringValue
        m.optFirstName = memberJSON["profile"]["first_name"].string
        m.optLastName = memberJSON["profile"]["last_name"].string
        m.optRealName = memberJSON["profile"]["real_name"].string
        m.optEmail = memberJSON["profile"]["email"].string
        return m
      }()
      ret.append(member)
    }
    
    return ret
  }
  
  // MARK: - Images
  
  func downloadImageWithURL(url: NSURL, completion: (UIImage?) -> ()) {
    alamofireManager!
    .request(.GET, url)
    .validate(contentType: ["image/*"])
    .response {
      (_: NSURLRequest, _: NSHTTPURLResponse?, imageData: AnyObject?, error: NSError?) -> Void in
      if error != nil {
        // If we failed fetching the photo there's not much we can do for the user. Just return nil and the placeholder photo will stay
        completion(nil)
        return
      }
      if let uiImage = UIImage(data: (imageData as! NSData)) {
        completion(uiImage)
      } else {
        // If we failed fetching the photo there's not much we can do for the user. Just return nil and the placeholder photo will stay
        completion(nil)
      }
    }
  }
  
}
