//
//  TeamListTableViewCell.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

class TeamListDetailedTableViewCell: TeamListTableViewCell {
  static let reuseIdentifier = "TeamListDetailedTableViewCell"
}

class TeamListConciseTableViewCell: TeamListTableViewCell {
  static let reuseIdentifier = "TeamListConciseTableViewCell"
  
}

class TeamListEmptyTableViewCell: TeamListTableViewCell {
  static let reuseIdentifier = "TeamListEmptyTableViewCell"
  
}