//
//  MainNavigationVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  Application's main navigation view controller

import UIKit

class MainNavigationVC: UINavigationController {
  
  var dataStack: DataStack!
  
  init() {
    super.init(nibName: nil, bundle: nil)
    dataStack = DataStack.sharedInstance
    
    if let team = DataManager.mainManager.loggedInTeam() {
      setViewControllers([LoginVC(), TeamListTableVC(team: team)], animated: false)
    } else {
      setViewControllers([LoginVC()], animated: false)
    }
    
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}