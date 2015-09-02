//
//  OAuth2AccessToken.swift
//  OAuthToo
//
//  Created by Kieran Graham on 14/05/2015.
//  Copyright (c) 2015 Kieran Graham. All rights reserved.
//

import Dollar
import Alamofire
import SwiftyJSON

public struct OAuth2AccessToken {
  public let accessToken: String
  public let refreshToken: String?
  public let tokenType: String
  public let scopes: [String]
  public let expiresIn: Int?
  public let createdAt: NSDate

  public init(json: JSON) {
    accessToken   = json["access_token"].stringValue
    refreshToken  = json["refresh_token"].string
    tokenType     = json["token_type"].stringValue
    scopes        = json["scope"].stringValue.componentsSeparatedByString(" ")
    expiresIn     = json["expires_in"].int
    createdAt     = NSDate(timeIntervalSince1970: NSTimeInterval(json["created_at"].intValue))
  }

  public var expiresAt: NSDate? {
    if let expiresIn = expiresIn {
      return NSDate(timeInterval: NSTimeInterval(expiresIn), sinceDate: createdAt)
    }
    else {
      return nil
    }
  }

  public func willExpire() -> Bool {
    return expiresIn != nil
  }

  public func isExpired() -> Bool {
    guard let expiresAt = expiresAt else {
      return false
    }

    return willExpire() && NSDate(timeIntervalSinceNow: 0).compare(expiresAt) == .OrderedDescending
  }

  public func isRefreshable() -> Bool {
    return refreshToken != nil
  }

  public func refresh(client: OAuth2Client, callback: OAuth2AccessTokenCallback) {
    let params = [
      "grant_type": "refresh_token",
      "refresh_token": refreshToken ?? ""
    ]

    client.tokenRequest(params, callback: callback)
  }
}
