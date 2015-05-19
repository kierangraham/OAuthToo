//
//  OAuth2Client.swift
//  OAuthToo
//
//  Created by Kieran Graham on 14/05/2015.
//  Copyright (c) 2015 Kieran Graham. All rights reserved.
//
import Alamofire
import SwiftyJSON
import Dollar

public let OAuth2HostURL      = "hostURL"
public let OAuth2TokenURL     = "tokenURL"
public let OAuth2Scope        = "scope"

let  OAuth2ErrorDomain        = "OAuth2Error"

public typealias OAuth2Options = [String: String]
public typealias OAuth2ClientConfigureBlock = ((Void) -> OAuth2Options)
public typealias OAuth2AccessTokenCallback = (token: OAuth2AccessToken?, error: NSError?) -> Void

public enum OAuth2GrantType {
  case Password
  case ClientCredentials
}

public class OAuth2Client {
  public let clientID: String
  public let clientSecret: String

  public lazy var clientCredentials: OAuth2ClientCredentialsStrategy = {
    return OAuth2ClientCredentialsStrategy(client: self)
  }()

  public lazy var password: OAuth2PasswordStrategy = {
    return OAuth2PasswordStrategy(client: self)
  }()

  private let defaultOptions: OAuth2Options = [
    OAuth2HostURL:      "",
    OAuth2TokenURL:     "/oauth/token",
  ]
  var options: OAuth2Options

  public init(clientID: String, clientSecret: String, options: OAuth2Options? = nil) {
    self.clientID = clientID
    self.clientSecret = clientSecret

    if let options = options {
      self.options = $.merge(defaultOptions, options)
    }
    else {
      self.options = defaultOptions
    }
  }

  public lazy var authorizationHeaderValue: String = {
    let base64 = (self.clientID + ":" + self.clientSecret)
      .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
      .base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)

    return "Basic \(base64)"
  }()

  public func tokenRequest(params: OAuth2Options, callback: OAuth2AccessTokenCallback) {
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    sessionConfiguration.HTTPAdditionalHeaders = [
      "Authorization": authorizationHeaderValue
    ]

    let manager = Alamofire.Manager(configuration: sessionConfiguration)
    let url = options[OAuth2HostURL]! + options[OAuth2TokenURL]!

    manager.request(.POST, url, parameters: params, encoding: ParameterEncoding.URL)
      .responseJSON(options: .allZeros) {
        (urlRequest, urlResponse, response, error) -> Void in

        if let status = urlResponse?.statusCode, response = response as? [String: AnyObject] where status == 200 {
          let json = JSON(response)
          let token = OAuth2AccessToken(json: json)

          callback(token: token, error: nil)
        }
        else if let status = urlResponse?.statusCode, response = response as? [String: String] where status == 400 || status == 401 {
          // TODO: handle errors better
          let error = NSError(domain: OAuth2ErrorDomain, code: -status, userInfo: response)
          callback(token: nil, error: error)
        }
    }
  }
}

public enum OAuth2Error {
  case InvalidRequest
  case InvalidClient
  case InvalidToken
  case InvalidGrant
  case InvalidScope
  case UnsupportedGrantType
}