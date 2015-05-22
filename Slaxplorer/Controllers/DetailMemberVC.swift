//
//  DetailMemberVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/22/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  DetailMemberVC controls the presentation of the details of a single member.
//  It also triggers fetches from CloudManager for updated data.

import UIKit

class DetailMemberVC: UIViewController {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet weak var constraintSubtitleSpacing: NSLayoutConstraint!
  @IBOutlet weak var constraintSubtitleHeight: NSLayoutConstraint!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  // MARK: General
  var member: Member!
  let imageCache = FICImageCache.sharedImageCache()
  var data = [MemberProperty]()
  
  // MARK: - Life Cycle
  convenience init(member: Member) {
    self.init(nibName: "DetailMemberVC", bundle: nil)
    self.member = member
    populateData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure table view
    tableView.dataSource = self
    
    // Register cells
    for (nibName, reuseId) in [
      ("DetailMemberTableViewCell", DetailMemberTableViewCell.reuseIdentifier),
      ] {
        let nib = UINib(nibName: nibName, bundle:nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseId)
    }
    
    // Set titles
    if member.optRealName != nil && member.optRealName != "" {
      titleLabel.text = member.optRealName
      subtitleLabel.text = "@" + member.username
    } else if member.optLastName != nil && member.optFirstName != nil && (member.optFirstName != "" || member.optLastName != "") {
      titleLabel.text = "\(member.optFirstName!.capitalizedString) \(member.optLastName!.capitalizedString)"
      subtitleLabel.text = "@" + member.username
    } else {
      titleLabel.text = "@" + member.username
      constraintSubtitleSpacing.constant = 0
      constraintSubtitleHeight.constant = 0
    }
    
    // Get photo from cache and set it if cell is still visible
    let imageExists = imageCache.retrieveImageForEntity(member, withFormatName: FastImageCacheManager.FICFormatNameProfilePhotoFull) {
      (photoMessage, formatName, image) -> Void in
      self.profileImageView.image = image
    }
    if !imageExists {
      self.profileImageView.image = MemberProfilePhoto.thumbPhotoForID(member.id)
    }
    
    view.setNeedsLayout()
    view.setNeedsDisplay()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Data
  
  // Creates a list MemberProperty objects to populate table view
  private func populateData() {
    if !member.isActive.boolValue {
      data.append(MemberProperty(name: "NOTICE", value: "This member is deleted"))
    }
    if member.optEmail != nil && member.optEmail != "" {
      data.append(MemberProperty(name: "email", value: member.optEmail!))
    }
    if member.optPhoneNumber != nil && member.optPhoneNumber != "" {
      data.append(MemberProperty(name: "phone", value: member.optPhoneNumber!))
    }
    if member.optSkype != nil && member.optSkype != "" {
      data.append(MemberProperty(name: "skype", value: member.optSkype!))
    }
    if member.isOwner.boolValue {
      data.append(MemberProperty(name: "owner", value: "Yes"))
    }
    if member.isAdmin.boolValue {
      data.append(MemberProperty(name: "admin", value: "Yes"))
    }
  }
  
  // MARK: - Actions
  
  @IBAction func backButtonTap(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
}

// MARK: - UITableViewDataSource

extension DetailMemberVC: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let property = data[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier(DetailMemberTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! DetailMemberTableViewCell
    cell.configureWithProperty(property)
    return cell
  }
}

// MARK: - MemberProperty Model
struct MemberProperty {
  let name: String
  let value: String
}
