//
//  OAuthTooClient.swift
//  OAuthTooClient
//
//  Created by Kieran Graham on 14/05/2015.
//  Copyright (c) 2015 Kieran Graham. All rights reserved.
//

import Foundation
import XCTest
import OAuthToo

import Quick
import Nimble

class OAuth2ClientSpec: QuickSpec {
  override func spec() {

    it("assigns client ID and client secret") {
      let client = OAuth2Client(clientID: "client_id", clientSecret: "client_secret")
      expect(client.clientID)     == "client_id"
      expect(client.clientSecret)  == "client_secret"
    }
  }
}

class OAuth2ClientCredentialsStrategySpec: QuickSpec {
  var client: OAuth2Client?

  override func spec() {

    beforeEach {
      self.client = OAuth2Client(clientID: "client_id", clientSecret: "client_secret")
    }

    it("generates an HTTP Basic Authorization header value from client ID & secret") {
      expect(self.client!.authorizationHeaderValue) == "Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ="
    }
  }
}