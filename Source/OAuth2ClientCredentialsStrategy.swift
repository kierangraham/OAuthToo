//
//  OAuth2ClientCredentialsStrategy.swift
//  OAuthToo
//
//  Created by Kieran Graham on 14/05/2015.
//  Copyright (c) 2015 Kieran Graham. All rights reserved.
//
import Dollar
import Alamofire
import SwiftyJSON

public class OAuth2ClientCredentialsStrategy: OAuth2Strategy {

  let client: OAuth2Client
  private let defaultParams:OAuth2Options = [
    "grant_type": "client_credentials",
  ]

  public required init(client: OAuth2Client) {
    self.client = client
  }

  public func getToken(params: OAuth2Options, callback: OAuth2AccessTokenCallback) {
    client.tokenRequest($.merge(defaultParams, params), callback: callback)
  }

}
