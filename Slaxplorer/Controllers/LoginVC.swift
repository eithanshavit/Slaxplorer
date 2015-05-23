//
//  LoginVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

//  Description:
//  LogicVC controls the log-in process using an API access token.

import UIKit

let LoginTeamLoggedOutNotification = "LoginTeamLoggedOutNotification"

public class LoginVC: UIViewController {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet public weak var promptLabel: UILabel!
  @IBOutlet weak var promptContainer: UIView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var clipboardButton: UIButton!
  @IBOutlet public weak var tokenTextView: UITextView!
  
  // MARK: General
  enum ClipboardButtonState {
    case Clipboard
    case Default
  }
  var clipboardButtonState = ClipboardButtonState.Clipboard
  
  enum NextButtonState {
    case Idle
    case Loading
    case Error
  }
  var nextButtonState = NextButtonState.Idle
  
  var dataStack: DataStack!
  public var cloudManager: CloudManager!
  
  // MARK: - Life Cycle
  
  convenience init() {
    self.init(nibName: "LoginVC", bundle: nil)
    dataStack = DataStack.sharedInstance
    cloudManager = CloudManager.mainManager
    
    // Register for logout notification
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "loggedOut:",
      name: LoginTeamLoggedOutNotification,
      object: nil)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    tokenTextView.text = Secrets.defaultAPIToken
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Next button
  
  // Animates the next button to a desired NextButtonState
  private func changeNextButtonToState(state: NextButtonState, animated: Bool) {
    switch state {
    case .Loading:
      UIView.animateWithDuration(
        animated ? 0.2 : 0,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseIn,
        animations: {
          () -> Void in
          self.nextButton.setTitle("thinking", forState: UIControlState.Normal)
          self.nextButton.backgroundColor = UIColor(red:1.0, green:0.55, blue:0.2, alpha:1.0)
        },
        completion: {
          (Bool) -> Void in
          self.nextButton.enabled = false
        })
    case .Idle:
      UIView.animateWithDuration(
        animated ? 0.2 : 0,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseIn,
        animations: {
          () -> Void in
          self.nextButton.setTitle("next", forState: UIControlState.Normal)
          self.nextButton.backgroundColor = UIColor(red:1.0, green:0.56, blue:0.56, alpha:1.0)
        },
        completion: {
          (Bool) -> Void in
          self.nextButton.enabled = true
        })
    case .Error:
      UIView.animateWithDuration(
        animated ? 0.2 : 0,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseIn,
        animations: {
          () -> Void in
          self.nextButton.setTitle("hmmm, problems", forState: UIControlState.Normal)
          self.nextButton.backgroundColor = UIColor(red:0.97, green:0.91, blue:0.11, alpha:1.0)
        },
        completion: {
          (Bool) -> Void in
          self.nextButton.enabled = false
        })
    }
    
  }
  
  @IBAction public func nextButtonTap(sender: AnyObject) {
    switch nextButtonState {
    case .Idle:
      // Button is idle
      // Switch to Loading
      nextButtonState = .Loading
      changeNextButtonToState(nextButtonState, animated: true)
      // Fetch team info
      cloudManager.requestTeamInfoWithToken(tokenTextView.text, completion: handleTeamResponse)
    default:
      break
    }
  }
  
  // MARK: - Team
  
  // Handle response from team info request
  private func handleTeamResponse(team: TempTeam?, teamDataStatus: TeamDataStatus, connectionStatus: CloudManagerConnectionStatus) {
    switch (connectionStatus, teamDataStatus) {
    case (.OK, .OK):
      loginTeam(team!)
    case (.OK, .AccountInactive):
      showError("The team you're interested in was deleted")
    case (.OK, .UserIsBot):
      showError("It appears you are a robot")
    case (.OK, .Unknown), (.UnknownFailure, _):
      showError("Hmmm, something happened, but I'm not sure what")
    case (.NotAuth, _):
      showError("Apologies, no access token was provided")
    case (.InvalidAuth, _):
      showError("Apologies, invalid access token was provided")
    case (.ConnectionFailure, _):
      showError("Apologies, unable to connect at the moment")
    case (.ParseFailure, _):
      showError("Apologies, unable to get data from web")
    default:
      assertionFailure("Invalid code path")
    }
  }
  
  private func loginTeam(tempTeam: TempTeam) {
    let team = DataManager.mainManager.logInTemporaryTeam(tempTeam)
    
    // Push TeamListTableVC
    let teamListVC = TeamListTableVC(team: team)
    navigationController?.pushViewController(teamListVC, animated: true)
  }
  
  // MARK: - Clipboard
  
  @IBAction func clipboardButtonTap(sender: AnyObject) {
    switch clipboardButtonState {
    case .Clipboard:
      // Populate token text view with clipboard content
      tokenTextView.text = UIPasteboard.generalPasteboard().string
      clipboardButtonState = .Default
      clipboardButton.setTitle("default token", forState: UIControlState.Normal)
    case .Default:
      // Populate token text view with default content
      tokenTextView.text = Secrets.defaultAPIToken
      clipboardButtonState = .Clipboard
      clipboardButton.setTitle("paste from clipboard", forState: UIControlState.Normal)
    }
  }
  
  // MARK: - Prompt Pop
  
  @IBAction func promptButtonTap(sender: AnyObject) {
    nextButtonState = .Idle
    changeNextButtonToState(nextButtonState, animated: true)
    hidePrompt()
  }
  
  private func showPrompt(text: String) {
    promptLabel.text = text
    promptContainer.alpha = 0
    promptContainer.hidden = false
    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        () -> Void in
        self.promptContainer.alpha = 1
      },
      completion: {
        (Bool) -> Void in
      })
  }
  
  private func hidePrompt() {
    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        () -> Void in
        self.promptContainer.alpha = 0
      },
      completion: {
        (Bool) -> Void in
        self.promptContainer.hidden = true
      })
  }
  
  // MARK: - Error reporting
  
  private func showError(text: String) {
    showPrompt(text)
    nextButtonState = .Error
    changeNextButtonToState(nextButtonState, animated: true)
  }
  
  // MARK: - Log out
  
  func loggedOut(notification: NSNotification) {
    if let nextButton = nextButton {
      nextButtonState = .Idle
      changeNextButtonToState(nextButtonState, animated: false)
      hidePrompt()
    }
  }

}