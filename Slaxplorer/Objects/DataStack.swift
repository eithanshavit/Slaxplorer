//
//  DataStack.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  DataStack class encapsulates CoreData functionality and initialization.

import UIKit
import CoreData

class DataStack: NSObject {
  
  // MARK: - Singleton
  
  static let sharedInstance = DataStack()
  
  // MARK: - Life Cycle
  
  override init() {
    super.init()
    registerForNotifications()
  }
  
  // MARK: - Notifications
  
  private func registerForNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "contextDidSavePrivateQueueContext:",
      name: NSManagedObjectContextDidSaveNotification,
      object: self.backgroundManagedObjectContext)
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "contextDidSaveMainQueueContext:",
      name: NSManagedObjectContextDidSaveNotification,
      object: self.managedObjectContext)
  }
  
  // When background MOC is saved, merge to main MOC
  func contextDidSavePrivateQueueContext(notification: NSNotification) {
    dispatch_sync(lockQueue) {
      self.managedObjectContext?.performBlock {
        let updated = notification.userInfo![NSUpdatedObjectsKey] as! NSSet
        for updatedObject in updated {
          self.managedObjectContext.existingObjectWithID(updatedObject.objectID, error: nil)
        }
        self.managedObjectContext?.mergeChangesFromContextDidSaveNotification(notification)
      }
    }
  }
  
  // When main MOC is saved, merge to background MOC
  func contextDidSaveMainQueueContext(notification: NSNotification) {
    dispatch_sync(lockQueue) {
      self.backgroundManagedObjectContext?.performBlock {
        self.backgroundManagedObjectContext?.mergeChangesFromContextDidSaveNotification(notification)
      }
    }
  }
  
  // MARK: - State
  
  private let lockQueue = dispatch_queue_create("com.eithanshavit.Slaxplorer.lock", nil)
  
  lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1] as! NSURL
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("Slaxplorer", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Slaxplorer.sqlite")
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
      coordinator = nil
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
      error = makeError(100, dict)
      // We are not currently focusing on optimizing Core Data.
      // Error handling support will be added in the future
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext! = {
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return managedObjectContext
    }()
  
  lazy var backgroundManagedObjectContext: NSManagedObjectContext! = {
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return managedObjectContext
    }()
  
  // MARK: Actions
  
  func saveMainContext () {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        // This must be a programmer error, abort
        NSLog("Unresolved error \(error)")
        abort()
      }
    }
  }
  
  func saveBackgroundContext () {
    if let moc = self.backgroundManagedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        // This must be a programmer error, abort
        NSLog("Unresolved error \(error)")
        abort()
      }
    }
  }
  
}
