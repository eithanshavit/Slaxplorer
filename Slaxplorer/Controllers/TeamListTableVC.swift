//
//  TeamListTableVC.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/20/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit

class TeamListTableVC: UIViewController {
  
  // MARK: - State
  
  // MARK: Outlets
  @IBOutlet weak var loaderContainer: UIView!
  @IBOutlet weak var teamNameLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: General
  var dataStack: DataStack!
  var cloudManager: CloudManager!
  var team: Team!
  
  // MARK: - Life Cycle
  
  convenience init(team: Team) {
    self.init(nibName: "TeamListTableVC", bundle: nil)
    self.team = team
    dataStack = DataStack.sharedInstance
    cloudManager = CloudManager.mainManager
  }
  
  override func viewDidLoad() {
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
    updateData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Data
  
  func updateData() {
    cloudManager.requestTeamMemberList(team, completion: handleMembersResponse)
  }
  
  // Handle response from team member list request
  private func handleMembersResponse(members: [TempMember]?, memberListDataStatus: MemberListDataStatus, connectionStatus: CloudManagerConnectionStatus) {
    DataManager.mainManager.syncTeamWithTempMembers(team, members: members!)
  }
  
  // MARK: - Actions
  
  @IBAction func logoutButtonTap(sender: AnyObject) {
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
    fetchRequest.predicate = NSPredicate(format: "team == %@", self.team)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    var error: NSError?
    if !controller.performFetch(&error) {
      println("Unable to fetch from fetchedResultsController \(error)")
      assertionFailure("Unable to fetch from fetchedResultsController")
    }
    controller.delegate = self.fetchControllerDelegate
    return controller
    }()
  
  private lazy var fetchControllerDelegate: FetchControllerDelegate = {
    let controller = FetchControllerDelegate(tableView: self.tableView)
    return controller
    }()
  
}

// MARK: - UITableViewDelegate

extension TeamListTableVC: UITableViewDelegate {
  
}

// MARK: - UITableViewDataSource

extension TeamListTableVC: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let info = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
    return info.numberOfObjects
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let member = fetchedResultsController.objectAtIndexPath(indexPath) as? Member {
      
    }
    return UITableViewCell()
    
  }
}