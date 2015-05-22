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
import OHHTTPStubs

class TeamListTableVC: QuickSpec {
  
  override func spec() {
    
    describe("TeamListTableVC") {
      
      var teamListTableVC: Slaxplorer.TeamListTableVC!
      
      beforeEach {
        teamListTableVC = Slaxplorer.TeamListTableVC()
        teamListTableVC.cloudManager = Slaxplorer.CloudManager.mainManager
      }
      
      context("handles bad responses from cloud") {
      
        it("should handle account inactive") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "account_inactive"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          teamListTableVC.updateData("someToken")
          expect(teamListTableVC.toastText).toEventually(equal("The team you're interested in was deleted"), timeout: 3)
        }
        
        it("should handle unknown failure ") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "bad key"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          teamListTableVC.updateData("someToken")
          expect(teamListTableVC.toastText).toEventually(equal("Hmmm, something's wrong, but I'm not sure what"), timeout: 3)
        }
        
        it("should handle post connection failure 1") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "not_authed"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          teamListTableVC.updateData("someToken")
          expect(teamListTableVC.toastText).toEventually(equal("Apologies, unable to connect"), timeout: 3)
        }
        
        it("should handle post connection failure 2") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "invalid_auth"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          teamListTableVC.updateData("someToken")
          expect(teamListTableVC.toastText).toEventually(equal("Apologies, unable to connect"), timeout: 3)
        }
        
        it("should handle post connection parse failure") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": true, "badkey": "badvalue"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          teamListTableVC.updateData("someToken")
          expect(teamListTableVC.toastText).toEventually(equal("Apologies, unable to connect"), timeout: 3)
        }
        
        it("should handle connection failure") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": true, "badkey": "badvalue"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:999, headers:nil)
          })
          teamListTableVC.updateData("someToken")
          expect(teamListTableVC.toastText).toEventually(equal("Apologies, unable to connect at the moment"), timeout: 3)
        }
      }
    }
  }
}

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
        
      context("handles bad responses from cloud") {
        
        it("should handle account inactive") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "account_inactive"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("The team you're interested in was deleted"), timeout: 3)
        }
        
        it("should handle not authed") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "not_authed"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("Apologies, no access token was provided"), timeout: 3)
        }
        
        it("should handle invalid auth") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "invalid_auth"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("Apologies, invalid access token was provided"), timeout: 3)
        }
        
        it("should handle connection failure") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "invalid_auth"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:999, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("Apologies, unable to connect at the moment"), timeout: 3)
        }
        
        it("should handle parse failure") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["wrongkey": false, "wrongkey2": "invalid_auth"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("Apologies, unable to get data from web"), timeout: 3)
        }
        
        it("should handle unknown failure") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "wrongerror"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("Hmmm, something happened, but I'm not sure what"), timeout: 3)
        }
        
        it("should handle robots") {
          OHHTTPStubs.stubRequestsPassingTest({
            (request: NSURLRequest) -> Bool in
              return request.URL!.host == Slaxplorer.CloudManager.URLHost
            }, withStubResponse: {
              (request: NSURLRequest) -> OHHTTPStubsResponse in
              let obj = ["ok": false, "error": "user_is_bot"]
              return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
          })
          loginVC.nextButtonTap(NSObject())
          expect(loginVC.promptLabel.text).toEventually(equal("It appears you are a robot"), timeout: 3)
        }
      }
    }
  }
}