//
//  TempTeam.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

// Struct to hold data of a temporary team before
// it goes into persistent storage (Core Data)

public struct TempTeam {
  let id: String
  let username: String
  let token: String
}
