//
//  Common.swift
//  OAuthRevTwitterAPI
//
//  Created by AbdouEtt on 10/06/2016.
//  Copyright © 2016 AbdouEtt. All rights reserved.
//

import UIKit

struct TwitterAPIURLS {
    static let base                        = NSURL(string: "https://api.twitter.com/")!
    static let homeTimelinePath            = "1.1/statuses/home_timeline.json"
    static let credentialsVerificationPath = "1.1/account/verify_credentials.json"
    static let tokenURLPath                = "oauth/request_token"
    static let accessTokenURLPath          = "oauth/access_token"
    static let authenticationURL           = "https://api.twitter.com/oauth/authenticate"
}

struct TwitterAPIKeys {
    static let consumerKey = "4iJdsjx9eHj7OdEVJr56D7N1C"
    static let consumerSecret = "M4n93sSayc5H4TambX7jsLieorQsz2MY15lnnxv3fFGgR3RhH6"
}