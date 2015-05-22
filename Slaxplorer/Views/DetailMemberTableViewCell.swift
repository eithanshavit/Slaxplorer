//
//  DetailMemberTableViewCell.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/22/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  A UITableViewCell for the DetailMemberVC table view.

import UIKit

class DetailMemberTableViewCell: UITableViewCell {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  // MARK: General
  static let reuseIdentifier = "DetailMemberTableViewCell"
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  // MARK: - Configure
  
  func configureWithProperty(property: MemberProperty) {
    valueLabel.text = property.value
    nameLabel.text = property.name
  }
  
}
