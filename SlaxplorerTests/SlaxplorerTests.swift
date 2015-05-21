//
//  SlaxplorerTests.swift
//  SlaxplorerTests
//
//  Created by  Eithan Shavit on 5/19/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//

import UIKit
import Slaxplorer
import Quick
import Nimble

class LoginVCSpec: QuickSpec {
  
  override func spec() {
    
    describe("LoginVC") {
      
      var loginVC: Slaxplorer.LoginVC!
      
      beforeEach {
        loginVC = Slaxplorer.LoginVC()
        loginVC.view.setNeedsLayout()
        loginVC.view.layoutIfNeeded()
      }
      
      it("should have a default token") {
        expect(loginVC.tokenTextView.text).to(equal(Slaxplorer.Secrets.defaultAPIToken))
      }
        
      context("handles responses from cloud") {
        
        var mockCM: MockCloudManager!
        
        class MockCloudManager: Slaxplorer.CloudManager {
          var mocks: (team: TempTeam?, dataStatus: TeamDataStatus, connectionStatus: CloudManagerConnectionStatus)!
          private override func requestTeamInfoWithToken(token: String, completion: (TempTeam?, TeamDataStatus, CloudManagerConnectionStatus) -> Void) {
            completion(mocks.team, mocks.dataStatus, mocks.connectionStatus)
          }
        }
        
        beforeEach {
          mockCM = MockCloudManager()
          loginVC.cloudManager = mockCM
        }
        
        it("should handle account inactive") {
          mockCM.mocks = (nil, .AccountInactive, .OK)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("The team you're interested in was deleted"))
        }
        
        it("should handle not authed") {
          mockCM.mocks = (nil, .Unknown, .NotAuth)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("Apologies, no access token was provided"))
        }
        
        it("should handle invalid auth") {
          mockCM.mocks = (nil, .Unknown, .InvalidAuth)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("Apologies, invalid access token was provided"))
        }
        
        it("should handle connection failure") {
          mockCM.mocks = (nil, .Unknown, .ConnectionFailure)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("Apologies, unable to connect at the moment"))
        }
        
        it("should handle parse failure") {
          mockCM.mocks = (nil, .Unknown, .ParseFailure)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("Apologies, unable to get data from web"))
        }
        
        it("should handle unknown failure") {
          mockCM.mocks = (nil, .Unknown, .UnknownFailure)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("Hmmm, something happened, but I'm not sure what"))
        }
        
        it("should handle robots") {
          mockCM.mocks = (nil, .UserIsBot, .OK)
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).to(equal("It appears you are a robot"))
        }
        
      }
      
    }
  }
}