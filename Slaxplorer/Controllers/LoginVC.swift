//
//  LoginVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet weak var promptLabel: UILabel!
  @IBOutlet weak var promptContainer: UIView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var clipboardButton: UIButton!
  @IBOutlet weak var tokenTextView: UITextView!
  
  // MARK: General
  enum NextButtonState {
    case Idle
    case Loading
  }
  var nextButtonState = NextButtonState.Idle
  
  var dataStack: DataStack!
  
  // MARK: - Life Cycle
  
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
  
  // MARK: - Next button
  
  // Animates the next button to a desired NextButtonState
  private func animateNextButtonToState(state: NextButtonState) {
    switch state {
    case .Loading:
      UIView.animateWithDuration(
        0.3,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseIn,
        animations: {
          () -> Void in
          self.nextButton.setTitle("thinking", forState: UIControlState.Normal)
          self.nextButton.backgroundColor = UIColor(red:1.0, green:0.55, blue:0.2, alpha:1.0)
        },
        completion: {
          (Bool) -> Void in
        })
    case .Idle:
      UIView.animateWithDuration(
        0.3,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseIn,
        animations: {
          () -> Void in
          self.nextButton.setTitle("next", forState: UIControlState.Normal)
          self.nextButton.backgroundColor = UIColor(red:1.0, green:0.56, blue:0.56, alpha:1.0)
        },
        completion: {
          (Bool) -> Void in
        })
      break
    }
    
  }
  
  @IBAction func nextButtonTap(sender: AnyObject) {
    switch nextButtonState {
    case .Idle:
      // Button is idle
      // Switch to Loading
      nextButtonState = .Loading
      animateNextButtonToState(nextButtonState)
      nextButton.enabled = false
      // Fetch team info
      CloudManager.mainManager.requestTeamInfoWithToken(tokenTextView.text, completion: handleTeamResponse)
    case .Loading:
      break
    }
  }
  
  // Handle response from team info request
  private func handleTeamResponse(team: Team?, teamDataStatus: TeamDataStatus, connectionStatus: CloudManagerConnectionStatus) {
    switch connectionStatus {
    case .OK:
      break
    case .NotAuth:
      break
    case .InvalidAuth:
      break
    case .ConnectionFailure:
      break
    case .ParseFailure:
      break
    case .UnknownFailure:
      break
    }
  }
  
  // MARK: - Clipboard
  
  @IBAction func clipboardButtonTap(sender: AnyObject) {
    tokenTextView.text = UIPasteboard.generalPasteboard().string
  }
  
  // MARK: - Prompt Pop
  
  @IBAction func promptButtonTap(sender: AnyObject) {
  }
  
}