//
//  Errors.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import Foundation

func makeError(code: Int, userInfo: [NSObject : AnyObject]?) -> NSError {
  
  /*
  Error code legend:
  1XX: Failure to work with Core Data
  101: MOC save failure
  102: MOC fetch failure
  111: Background MOC save failure
  2XX: Failure to work with Cloud
  201: DataSync task cancelled
  202: DataSync task failed
  */
  return NSError(domain: "com.eithanshavit.Slaxplorer", code: code, userInfo: userInfo)
}