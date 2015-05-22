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
  
  // MARK: - Team Functionality
  
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
    fetchRequest.predicate = NSPredicate(format: "id == %@", tempTeam.id)
    var error: NSError?
    if let results = dataStack.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Team] {
      switch results.count {
      case 0:
        // Create a new Team
        team = NSEntityDescription.insertNewObjectForEntityForName(Team.entityName(), inManagedObjectContext: dataStack.managedObjectContext) as! Team
        team.id = tempTeam.id
      case 1:
        // Found team
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
  
  // Log out current team
  // Note: Wheter we should maintain the team's data in CoreData is up to the app's
  // usage patterns. In this case and due to the small amount of data, I'm keeping the data intact.
  func logOutActiveTeam() {
    if let team = loggedInTeam() {
      team.loggedIn = false
      dataStack.saveMainContext()
    }
  }
  
  // Fetch logged in team if exists
  func loggedInTeam() -> Team? {
    
    // Fetch all loggedIn teams
    let fetchRequest = NSFetchRequest(entityName: Team.entityName())
    fetchRequest.predicate = NSPredicate(format: "loggedIn == %@", true)
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
  
  // MARK: - Members Functionality
  
  // Sync temp team members from cloud into local team
  // Note: on iOS 8 we can enjoy using NSBatchUpdateRequest to efficiently update the team's members.
  //       But in this case, the order of mangnitude of elements does not justify such complex optimization.
  func syncTeamWithTempMembers(team: Team, members: [TempMember]) {
    // First fetch background Team object
    let fetchRequest = NSFetchRequest(entityName: Team.entityName())
    fetchRequest.predicate = NSPredicate(format: "id == %@", team.id)
    var error: NSError?
    var localTeam: Team!
    if let results = dataStack.backgroundManagedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Team] {
      switch results.count {
      case 0:
        // Should never happen
        assertionFailure("Unable to find Team with provided Team \(team)")
      case 1:
        localTeam = results.first!
      default:
        assertionFailure("There must be at most 1 team with ID \(team.id)")
      }
    } else {
      println("Could not fetch \(error!), \(error!.userInfo)")
      assertionFailure("Could not fetch")
    }
    
    // Utility generic to convert an array to a dictionary with a given transformer
    func toDictionary<E, K, V>(array: [E], transformer: (element: E) -> (key: K, value: V)?) -> Dictionary<K, V> {
      return array.reduce([:]) {
        (var dict, e) in
        if let (key, value) = transformer(element: e) {
          dict[key] = value
        }
        return dict
      }
    }
    
    // Form sets to figure out which team members need update, addition, or deletion
    let idToMemberMap = toDictionary(Array(localTeam.members as! Set<Member>)) {($0.id, $0)}
    let idToTempMemberMap = toDictionary(members) {($0.id, $0)}
    let idSet = Set(Array(localTeam.members as! Set<Member>).map {$0.id})
    let tempIDSet = Set(members.map {$0.id})
    let idsToUpdate = tempIDSet.intersect(idSet)
    let idsToDelete = idSet.subtract(tempIDSet)
    let idsToAdd = tempIDSet.subtract(idSet)
    
    // Update existing members
    println("-START UPDATE-")
    for id in idsToUpdate {
      let member = idToMemberMap[id]!
      let tempMember = idToTempMemberMap[id]!
      updateMemberWithTempMember(member, tempMember: tempMember)
      println("UPDATING \(member.username)")
    }
    // Add new members
    for id in idsToAdd {
      let member = NSEntityDescription.insertNewObjectForEntityForName(Member.entityName(), inManagedObjectContext: dataStack.backgroundManagedObjectContext) as! Member
      member.id = id
      let tempMember = idToTempMemberMap[id]!
      updateMemberWithTempMember(member, tempMember: tempMember)
      localTeam!.addMembersObject(member)
      println("ADDING \(tempMember.username)")
    }
    // Delete unnecessary members
    for id in idsToDelete {
      let member = idToMemberMap[id]!
      localTeam.removeMembersObject(member)
      println("DELETING \(member.username)")
    }
    println("-END UPDATE-")
    
    // Phew... Now save the background context
    dataStack.saveBackgroundContext()
  }
  
  // Updates a local Member object with properties from a TempMember object.
  private func updateMemberWithTempMember(member: Member, tempMember: TempMember) {
    member.username = tempMember.username
    member.isActive = tempMember.isActive
    member.isAdmin = tempMember.isAdmin
    member.isOwner = tempMember.isOwner
    member.image48URL = tempMember.image48URL
    member.image192URL = tempMember.image192URL
    member.optFirstName = tempMember.optFirstName
    member.optLastName = tempMember.optLastName
    member.optRealName = tempMember.optRealName
    member.optEmail = tempMember.optEmail
  }

}
