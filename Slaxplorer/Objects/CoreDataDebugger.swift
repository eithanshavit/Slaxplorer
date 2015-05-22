//
//  CoreDataDebugger.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  Utility class for debuggin Core Data

import UIKit
import CoreData

class CoreDataDebugger: NSObject {
  
  static let sharedInstace = CoreDataDebugger()
  
  let dataStack = DataStack.sharedInstance
  let moc = DataStack.sharedInstance.managedObjectContext
  
  func debugStartupHook() {
    //clearAllData()
  }
  
  func clearAllData() {
    clearObjectsWithEntityName("Team")
    clearObjectsWithEntityName("Member")
  }
  
  func clearObjectsWithEntityName(name: String) {
    let fetchRequest = NSFetchRequest(entityName: name)
    var error: NSError?
    if let results = moc.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]? {
      for result in results {
        moc.deleteObject(result)
      }
    }
    else {
      println("Could not fetch \(error), \(error!.userInfo)")
    }
  }
  
  func printMembersOfTeamID(id: String) {
    var fetchRequest = NSFetchRequest(entityName: Member.entityName())
    fetchRequest.predicate = NSPredicate(format: "team.id == %@", id)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
    println("==Members of team [\(id)]===")
    let results = dataStack.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Member]
    results.map {println($0.username)}
    println("=======")
  }
  
  
}
