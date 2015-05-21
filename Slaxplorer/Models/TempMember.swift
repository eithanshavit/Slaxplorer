//
//  TempMember.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

// Struct to hold data of a temporary member before
// it goes into persistent storage (Core Data)

public struct TempMember {
  let id: String
  let username: String
  let isActive: Bool?
  let isAdmin: Bool
  let isOwner: Bool
  let image48Url: String
  let image192Url: String
  let optFirstName: String?
  let optLastName: String?
  let optRealName: String?
  let optEmail: String?
}
