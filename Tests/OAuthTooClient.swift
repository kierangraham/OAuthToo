//
//  OAuthTooClient.swift
//  OAuthTooClient
//
//  Created by Kieran Graham on 14/05/2015.
//  Copyright (c) 2015 Kieran Graham. All rights reserved.
//

import Foundation
import OAuthToo

import Quick
import Nimble
import SwiftyJSON

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

class OAuth2TokenSpec: QuickSpec {
  override func spec() {
    it("Token should be determined to be expired") {
      var json: [String: AnyObject] = [
        "access_token": "abc",
        "refresh_token": "123",
        "token_type": "bearer",
        "scopes": "public",
        "expires_in": 7200,
        "created_at": 0
      ]

      let expiredToken = OAuth2AccessToken(json: JSON(json))
      expect(expiredToken.isExpired()) == true
    }
  }
}