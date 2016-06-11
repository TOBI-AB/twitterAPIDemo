//
//  TwitterAPIManager.swift
//  OAuthRevTwitterAPI
//
//  Created by AbdouEtt on 09/06/2016.
//  Copyright © 2016 AbdouEtt. All rights reserved.
//

import Foundation
import Social
import OAuthCore

protocol TwitterAPIManagerDelegate: class {
    func twitterAPIManager(twitterApiManager: TwitterAPIManager, didGetUserCredentials: Dictionary<String, AnyObject>)
    func twitterAPIManager(twitterApiManager: TwitterAPIManager, didFialWithError error: NSError)
}

class TwitterAPIManager {
    
    weak var delegate: TwitterAPIManagerDelegate? {
        didSet {
            verfiyCredentials()
        }
    }
    let OAuthToken: String
    let OAuthTokenSecret: String
    
    init(twitterAccountCredential: TwitterAccountCredential) {
        self.OAuthToken = twitterAccountCredential.OAuthToken
        self.OAuthTokenSecret = twitterAccountCredential.OAuthTokenSecret
    }
    
    
    // MARK: isLocalTwitterAccountAvailable
    static var isLocalTwitterAccountAvailable: Bool {
        return SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
    }
    
    
    // MARK: isLocalTwitterAccountAvailable
    private func verfiyCredentials() {
        guard let credentialsURL = NSURL(string: TwitterAPIURLS.credentialsVerificationPath, relativeToURL: TwitterAPIURLS.base)?.absoluteURL else {
            return
        }
        
        let oAuthorizationHeaderString = OAuthorizationHeader(credentialsURL, "GET", nil, TwitterAPIKeys.consumerKey, TwitterAPIKeys.consumerSecret, self.OAuthToken, self.OAuthTokenSecret)
        let credentialsRequest = NSURLRequest.httpRequest(credentialsURL, method: "GET", header: ["Authorization": oAuthorizationHeaderString])
        
        NSURLSession.sharedSession().sendHttRequest(credentialsRequest) { (data, error) in
            if (error != nil) {
                print(error)
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as? Dictionary<String, AnyObject> {
                    self.delegate?.twitterAPIManager(self, didGetUserCredentials: json)
                }
            } catch let error as NSError {
                self.delegate?.twitterAPIManager(self, didFialWithError: error)
            }
        }
    }

}




















