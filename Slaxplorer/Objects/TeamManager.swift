//
//  TeamManager.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import Foundation

class TeamManager: NSObject {
  
  // Registers a temporary team to CoreData and sets it as logged-in
  class func logInTemporaryTeam(tempTeam: TempTeam, dataStack: DataStack) -> Team {
    
    // Log out current team
    if let loggedTeam = loggedInTeam(dataStack) {
      loggedTeam.loggedIn = false
    }
    
    // Create or update a Team from temporary team
    
    // Log in
    //team.loggedIn = true
    return Team()
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
      assertionFailure("There must be at most 1 logged-in team")
    }
    assertionFailure("Not a valid code path")
    return nil
  }

}
