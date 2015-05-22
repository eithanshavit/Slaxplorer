//
//  TeamListTableViewCell.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  A UITableViewCell for the TeamListTableVC table view.

import UIKit

class TeamListTableViewCell: UITableViewCell {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var constraintUsernameLabelYFromCenter: NSLayoutConstraint! {
    didSet {
      originalUsernameLabelOffset = constraintUsernameLabelYFromCenter.constant
    }
  }
  
  // MARK: General
  static let reuseIdentifier = "TeamListTableViewCell"
  
  let imageCache = FICImageCache.sharedImageCache()
  
  var originalUsernameLabelOffset: CGFloat = 0
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .None
  }
  
  // MARK: - Configure
  
  func configureWithMember(member: Member) {
    // Configure labels
    fullNameLabel.hidden = false
    constraintUsernameLabelYFromCenter.constant = originalUsernameLabelOffset
    if member.optRealName != nil && member.optRealName != "" {
      fullNameLabel.text = member.optRealName
    } else if member.optLastName != nil && member.optFirstName != nil && (member.optFirstName != "" || member.optLastName != "") {
      fullNameLabel.text = "\(member.optFirstName!.capitalizedString) \(member.optLastName!.capitalizedString)"
    } else {
      fullNameLabel.hidden = true
      constraintUsernameLabelYFromCenter.constant = 0
    }
    usernameLabel.text = "@" + member.username
    
    // Get photo from cache and set it if cell is still visible
    let imageExists = imageCache.retrieveImageForEntity(member, withFormatName: FastImageCacheManager.FICFormatNameProfilePhotoThumb) {
      (photoMessage, formatName, image) -> Void in
      self.profileImageView.image = image
    }
    if !imageExists {
      self.profileImageView.image = MemberProfilePhoto.thumbPhotoForID(member.id)
    }
    setNeedsDisplay()
  }
}
