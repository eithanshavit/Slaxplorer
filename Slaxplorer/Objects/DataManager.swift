//
//  DataManager.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import Foundation

public class DataManager: NSObject {
  
  // MARK: - State
  
  var dataStack: DataStack!
  
  // MARK: - Main Instance
  
  // The main DataManager uses the shared DataStack.
  // If needed, create different DataManagers with different configs
  class var mainManager: DataManager {
    var dm = DataManager()
    dm.dataStack = DataStack.sharedInstance
    return dm
  }
  
  // MARK: - Life Cycle
  
  public override init() {
    super.init()
  }
  
  // Registers a temporary team to CoreData and sets it as logged-in
  func logInTemporaryTeam(tempTeam: TempTeam) -> Team {
    
    // Log out current team
    if let loggedTeam = loggedInTeam() {
      loggedTeam.loggedIn = false
    }
    
    // Create or update a Team from temporary team
    var team: Team!
    
    // See if team with already exists
    let fetchRequest = NSFetchRequest(entityName: Team.entityName())
    let resultPredicate = NSPredicate(format: "id == %@", tempTeam.id)
    var error: NSError?
    if let results = dataStack.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Team] {
      switch results.count {
      case 0:
        // Create a new Team
        team = NSEntityDescription.insertNewObjectForEntityForName(Team.entityName(), inManagedObjectContext: dataStack.managedObjectContext) as! Team
        team.id = tempTeam.id
      case 1:
        team = results.first
      default:
        assertionFailure("There must be at most 1 team with ID \(tempTeam.id)")
      }
    } else {
      println("Could not fetch \(error!), \(error!.userInfo)")
      assertionFailure("Could not fetch")
    }
    
    // Update team
    team.loggedIn = true
    team.name = tempTeam.name
    team.token = tempTeam.token
    
    dataStack.saveMainContext()
    
    return team
  }
  
  // Fetch logged in team if exists
  func loggedInTeam() -> Team? {
    
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
      assertionFailure("Could not fetch")
    }
    assertionFailure("Not a valid code path")
    return nil
  }
  
  // Sync temp team members with local team
  func syncTeamWithTempMembers(team: Team, members: [TempMember]) {
    
  }

}
