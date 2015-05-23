//
//  TeamListTableVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  TeamListTableVC controls the presentation of a list of member for a given team. 
//  It also triggers fetches from CloudManager for updated data.

import UIKit

public class TeamListTableVC: UIViewController {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet weak var toastView: UIView!
  @IBOutlet weak var toastLabel: UILabel!
  @IBOutlet weak var loaderContainer: UIView!
  @IBOutlet weak var teamNameLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: General
  var dataStack: DataStack!
  public var cloudManager: CloudManager!
  var team: Team!
  public var toastText: String = ""
  
  // MARK: - Life Cycle
  
  convenience init(team: Team) {
    self.init(nibName: "TeamListTableVC", bundle: nil)
    self.team = team
    dataStack = DataStack.sharedInstance
    cloudManager = CloudManager.mainManager
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure table view
    tableView.delegate = self
    tableView.dataSource = self
    
    // Register cells
    for (nibName, reuseId) in [
      ("TeamListTableViewCell", TeamListTableViewCell.reuseIdentifier),
    ] {
      let nib = UINib(nibName: nibName, bundle:nil)
      tableView.registerNib(nib, forCellReuseIdentifier: reuseId)
    }
    
    // Set title
    teamNameLabel.text = team.name
    
    // Show/hide loader
    showLoader(fetchedResultsController.fetchedObjects!.count == 0, animated: false)
    
    // Finally, update data
    updateData(team.token)
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Data
  
  public func updateData(token: String) {
    cloudManager.requestTeamMemberList(token, completion: handleMembersResponse)
  }
  
  // Handle response from team member list request
  private func handleMembersResponse(members: [TempMember]?, memberListDataStatus: MemberListDataStatus, connectionStatus: CloudManagerConnectionStatus) {
    switch (connectionStatus, memberListDataStatus) {
    case (.OK, .OK):
      DataManager.mainManager.syncTeamWithTempMembers(self.team, members: members!)
      return
    case (.OK, .AccountInactive):
      toastText = "The team you're interested in was deleted"
    case (.OK, .Unknown), (.UnknownFailure, _):
      toastText = "Hmmm, something's wrong, but I'm not sure what"
    case (.InvalidAuth, _), (.NotAuth, _), (.ParseFailure, _):
      toastText = "Apologies, unable to connect"
    case (.ConnectionFailure, _):
      toastText = "Apologies, unable to connect at the moment"
    default:
      assertionFailure("Invalid code path")
    }
    if let label = toastLabel {
      showToast(toastText)
    }
  }
  
  // MARK: - Actions
  
  @IBAction func logoutButtonTap(sender: AnyObject) {
    // Logout team and dismiss VC
    DataManager.mainManager.logOutActiveTeam()
    NSNotificationCenter.defaultCenter().postNotificationName(LoginTeamLoggedOutNotification, object: nil)
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: - Loader
  
  func showLoader(show: Bool, animated: Bool) {
    if animated {
      UIView.animateWithDuration(
        0.2,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseIn,
        animations: {
          () -> Void in
          self.loaderContainer.alpha = show ? 1 : 0
        },
        completion: {
          (Bool) -> Void in
        })
    } else {
      self.loaderContainer.alpha = show ? 1 : 0
    }
  }
  
  // MARK: - FetchedResultsController
  
  private lazy var fetchedResultsController: NSFetchedResultsController = {
    let moc = self.dataStack.managedObjectContext
    var fetchRequest = NSFetchRequest(entityName: Member.entityName())
    fetchRequest.predicate = NSPredicate(format: "team.id == %@", self.team.id)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    controller.delegate = self.fetchControllerDelegate
    var error: NSError?
    if !controller.performFetch(&error) {
      println("Unable to fetch from fetchedResultsController \(error)")
      assertionFailure("Unable to fetch from fetchedResultsController")
    }
    return controller
    }()
  
  private lazy var fetchControllerDelegate: FetchControllerDelegate = {
    let controller = FetchControllerDelegate(tableView: self.tableView)
    controller.onUpdateDone = self.fetchResultsControllerDidChangeContent
    return controller
    }()
  
  func fetchResultsControllerDidChangeContent() {
    let doesHaveObjects = self.fetchedResultsController.fetchedObjects!.count == 0
    self.showLoader(doesHaveObjects, animated: true)
  }
  
  // MARK: - Toast!
  
  private func showToast(text: String) {
    toastLabel.text = text
    toastView.alpha = 0
    toastView.hidden = false
    UIView.animateWithDuration(
      0.5,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        () -> Void in
        self.toastView.alpha = 1
      },
      completion: {
        (Bool) -> Void in
        delayExec(5) {
          self.hideToast()
        }
      })
  }
  
  private func hideToast() {
    UIView.animateWithDuration(
      0.3,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        () -> Void in
        self.toastView.alpha = 0
      },
      completion: {
        (Bool) -> Void in
        self.toastView.hidden = true
      })
  }
  
}

// MARK: - UITableViewDelegate

extension TeamListTableVC: UITableViewDelegate {
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let member = fetchedResultsController.objectAtIndexPath(indexPath) as! Member
    navigationController?.pushViewController(DetailMemberVC(member: member), animated: true)
  }
  
}

// MARK: - UITableViewDataSource

extension TeamListTableVC: UITableViewDataSource {
  
  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let info = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
    return info.numberOfObjects
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let member = fetchedResultsController.objectAtIndexPath(indexPath) as! Member
    let cell = tableView.dequeueReusableCellWithIdentifier(TeamListTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! TeamListTableViewCell
    cell.configureWithMember(member, indexPath: indexPath)
    return cell
  }
}