//
//  CoreDataDebugger.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDebugger: NSObject {
  
  static let sharedInstace = CoreDataDebugger()
  
  let dataStack = DataStack.sharedInstance
  let moc = DataStack.sharedInstance.managedObjectContext
  
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
  
  
}
