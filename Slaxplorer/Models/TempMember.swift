//
//  TempMember.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

// Struct to hold data of a temporary member before
// it goes into persistent storage (Core Data)

public class TempMember: NSObject, Printable {
  var id: String = ""
  var username: String = ""
  var isActive: Bool = false
  var isAdmin: Bool = false
  var isOwner: Bool = false
  var image48URL: String = ""
  var image192URL: String = ""
  var optFirstName: String? = nil
  var optLastName: String? = nil
  var optRealName: String? = nil
  var optEmail: String? = nil
  
  override init() {
    super.init()
  }
  
  public override var description: String {
    return "ID \(id): \(username)"
  }
}
