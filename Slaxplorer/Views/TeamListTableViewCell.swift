//
//  TeamListTableViewCell.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var constraintUsernameLabelYFromCenter: NSLayoutConstraint! {
    didSet {
      originalUsernameLabelOffset = constraintUsernameLabelYFromCenter.constant
    }
  }
  
  static let reuseIdentifier = "TeamListTableViewCell"
  var originalUsernameLabelOffset: CGFloat = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
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
    
    // Set image
    profileImageView.image = MemberProfilePhoto.thumbPhotoForID(member.id)
    
    setNeedsDisplay()
  }
}
