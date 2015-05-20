//
//  LoginVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
  
  var dataStack: DataStack!
  
  convenience init() {
    self.init(nibName: "LoginVC", bundle: nil)
    dataStack = DataStack.sharedInstance
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}