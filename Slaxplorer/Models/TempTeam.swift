//
//  TempTeam.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

// Struct to hold data of a temporary team before
// it goes into persistent storage (Core Data)

public struct TempTeam: Printable {
  let id: String
  let name: String
  let token: String
  
  public var description: String {
    return "ID \(id): \(name)"
  }
}
