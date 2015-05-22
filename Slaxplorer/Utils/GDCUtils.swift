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