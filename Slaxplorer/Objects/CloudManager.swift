//
//  CloudManager.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

// CloudManager class is responsible communication with the web

import UIKit
import Alamofire

enum CloudManagerConnectionStatus {
  case OK
  case NotAuth
  case InvalidAuth
  case ConnectionFailure
  case ParseFailure
  case UnknownFailure
}

class CloudManager: NSObject {
  
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
  
  override init() {
    super.init()
  }
  
  convenience init(alamofireManager: Alamofire.Manager) {
    self.init()
    self.alamofireManager = alamofireManager
  }
  
  // MARK: - Team resources
  
  // Requests Team's info using a provided <token> and calls <completion> upon completion
  func requestTeamInfoWithToken(token: String, completion: (Team?, TeamDataStatus, CloudManagerConnectionStatus) -> Void) {
    // Escape given token
    let safeToken = token.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
    
    if safeToken == nil {
      // Report error with escaping token
      
    }
    
    // Request from web
    let params = [
      "token": safeToken!
    ]
    alamofireManager!
      .request(.GET, URLTeamInfo, parameters: params)
      .validate(statusCode: 200..<201)
      .responseJSON {
        (_: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
        // Handle error
        if error != nil {
          // Error occurred
          println(error)
          completion(nil, .Unknown, .ConnectionFailure)
          return
        }
        // Check for OK status
        let resOK = data?.valueForKey("ok") as? Bool
        if resOK == nil {
          // Unable to parse OK response
          completion(nil, .Unknown, .ParseFailure)
          return
        }
        if resOK! {
          // Response ok, create Team
          let resTeam: AnyObject? = data?.valueForKey("team")
          if resTeam == nil {
            // Unable to parse team response
            completion(nil, .Unknown, .ParseFailure)
            return
          }
          let team = self.createTeamFromData(resTeam!)
          completion(team, .OK, .OK)
        } else {
          // Response not ok, figure out why
          let resError = data?.valueForKey("error") as? String
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
  
  // Creates a new Team managed object with provided <data>
  private func createTeamFromData(data: AnyObject) -> Team {
    let id = data.valueForKey("id") as! String
    let name = data.valueForKey("name") as! String
    return Team.createTeamWithID(id, name: name, inManagedObjectContext: dataStack.managedObjectContext)
  }
  
}
