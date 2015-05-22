//
//  TempTeam.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  Class to hold data of a temporary team before
//  it goes into persistent storage (Core Data)

public class TempTeam: NSObject, Printable {
  var id: String
  var name: String
  var token: String
  
  init(id: String, name: String, token: String) {
    self.id = id
    self.token = token
    self.name = name
    super.init()
  }
  
  public override var description: String {
    return "ID \(id): \(name)"
  }
}
