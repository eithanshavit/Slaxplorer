//
//  TeamManager.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import Foundation

class TeamManager: NSObject {
  
  // Sets a Team as current
  class func logInTeam(team: Team, dataStack: DataStack) {
    
    // Log out current team
    if let loggedTeam = loggedInTeam(dataStack) {
      loggedTeam.loggedIn = false
    }
    
    // Log in
    team.loggedIn = true
  }
  
  // Fetch logged in team if exists
  class func loggedInTeam(dataStack: DataStack) -> Team? {
    
    // Fetch all loggedIn teams
    let fetchRequest = NSFetchRequest(entityName: Team.entityName())
    let resultPredicate = NSPredicate(format: "loggedIn == %@", true)
    var error: NSError?
    if let results = dataStack.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Team] {
      switch results.count {
      case 0:
        return nil
      case 1:
        return results.first
      default:
        assertionFailure("There must be at most 1 logged-in team")
      }
    } else {
      println("Could not fetch \(error!), \(error!.userInfo)")
    }
  }

}
