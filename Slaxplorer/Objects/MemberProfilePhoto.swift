//
//  MemberProfilePhoto.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/21/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  Helper class for effecient 1 to 1 team member 
//  and temporary profile photo mapping and allocation.

import UIKit

class MemberProfilePhoto: NSObject {
  
  static let thumbs = [
    UIImage(named: "profile-cyan-48"),
    UIImage(named: "profile-red-48"),
    UIImage(named: "profile-orange-48"),
    UIImage(named: "profile-green-48")
  ]
  
  static let photos = [
    UIImage(named: "profile-cyan-192"),
    UIImage(named: "profile-red-192"),
    UIImage(named: "profile-orange-192"),
    UIImage(named: "profile-green-192")
  ]
  
  class func thumbPhotoForID(id: String) -> UIImage {
    return thumbs[abs(id.hashValue) % thumbs.count]!
  }
  
  class func photoForID(id: String) -> UIImage {
    return photos[abs(id.hashValue) % photos.count]!
  }

}
