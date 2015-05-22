//
//  FetchControllerDelegate.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

//  Helper class to forward NSFetchedResultsControllerDelegate to a tableView

import CoreData
import UIKit

@objc public class FetchControllerDelegate: NSFetchedResultsControllerDelegate {
  
  private var sectionsBeingAdded: [Int] = []
  private var sectionsBeingRemoved: [Int] = []
  private let tableView: UITableView
  
  public var onCellUpdate: ((cell: UITableViewCell, object: AnyObject) -> Void)?
  public var onUpdateDone: (() -> ())?
  public var ignoreNextUpdates: Bool = false
  
  init(tableView: UITableView) {
    self.tableView = tableView
  }
  
  public func controllerWillChangeContent(controller: NSFetchedResultsController)  {
    if ignoreNextUpdates {
      return
    }
    sectionsBeingAdded = []
    sectionsBeingRemoved = []
    tableView.beginUpdates()
  }
  
  public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)  {
    if ignoreNextUpdates {
      return
    }
    
    switch type {
    case .Insert:
      sectionsBeingAdded.append(sectionIndex)
      tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    case .Delete:
      sectionsBeingRemoved.append(sectionIndex)
      self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    default:
      return
    }
  }
  
  public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    if ignoreNextUpdates {
      return
    }
    
    switch type {
    case .Insert:
      tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
    case .Delete:
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
    case .Update:
      onCellUpdate?(cell: tableView.cellForRowAtIndexPath(indexPath!)!, object: anObject)
    case .Move:
      // Stupid and ugly, rdar://17684030
      if !contains(sectionsBeingAdded, newIndexPath!.section) && !contains(sectionsBeingRemoved, indexPath!.section) {
        tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        onCellUpdate?(cell: tableView.cellForRowAtIndexPath(indexPath!)!, object: anObject)
      } else {
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
      }
    default:
      return
    }
  }
  
  public func controllerDidChangeContent(controller: NSFetchedResultsController)  {
    if ignoreNextUpdates {
      ignoreNextUpdates = false
    } else {
      tableView.endUpdates()
      onUpdateDone?()
    }
  }
}
