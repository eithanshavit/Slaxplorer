//
//  MainNavigationVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
import UIKit

class MainNavigationVC: UINavigationController {
  
  var dataStack: DataStack!
  
  init() {
    super.init(nibName: nil, bundle: nil)
    dataStack = DataStack.sharedInstance
    
    if let team = TeamManager.currentTeam(dataStack) {
    } else {
    }
    
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarHidden = true
    interactivePopGestureRecognizer.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - UIGestureRecognizerDelegate

extension MainNavigationVC: UIGestureRecognizerDelegate {
  
}