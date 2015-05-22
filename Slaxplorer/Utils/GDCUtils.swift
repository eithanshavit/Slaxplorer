//
//  GDCUtils.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/21/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  Some nice utilites for GCD in swift

import Foundation

func delayExec(delay: Double, closure: ()->()) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}

func mainExec(closure: ()->()) {
  dispatch_async(dispatch_get_main_queue(), closure)
}

func highPriorityQueueExec(closure: ()->()) {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), closure)
}

func defaultPriorityQueueExec(closure: ()->()) {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
}