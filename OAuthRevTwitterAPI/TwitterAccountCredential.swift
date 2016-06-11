//
//  TwitterAccountCredential.swift
//  OAuthRevTwitterAPI
//
//  Created by AbdouEtt on 10/06/2016.
//  Copyright © 2016 AbdouEtt. All rights reserved.
//

import Foundation

class TwitterAccountCredential: NSObject {
    
    let OAuthToken: String
    let OAuthTokenSecret: String
    
    init(OAuthToken: String, OAuthTokenSecret: String) {
        self.OAuthToken = OAuthToken
        self.OAuthTokenSecret = OAuthTokenSecret
    }
}