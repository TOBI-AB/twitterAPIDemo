//
//  ViewController.swift
//  OAuthRevTwitterAPI
//
//  Created by AbdouEtt on 08/06/2016.
//  Copyright © 2016 AbdouEtt. All rights reserved.
//

import UIKit
import OAuthCore
import Accounts



class ViewController: UIViewController {

    var appDelegate = AppDelegate()
    var twitterAPIManager: TwitterAPIManager!
    
    var dataSource: Dictionary<String, AnyObject>? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(TwitterAPIManager.isLocalTwitterAccountAvailable)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.getAccessToken(_:)), name: "twitterAccountCredential", object: nil)
        requestToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Helpers
extension ViewController {
    
    // MARK: Request Token
    func requestToken() {
        
        let callback = NSURL(string: "demotwitterapi://oauth")?.absoluteString
        
        guard let requestTokenURL = NSURL(string: TwitterAPIURLS.tokenURLPath, relativeToURL: TwitterAPIURLS.base)?.absoluteURL else {
            return
        }
        
        let oAuthorizationHeader = OAuthorizationHeaderWithCallback(requestTokenURL, "POST", nil, TwitterAPIKeys.consumerKey, TwitterAPIKeys.consumerSecret, nil, nil, callback)
        
        let request = NSURLRequest.httpRequest(requestTokenURL, method: "POST", header: ["Authorization": oAuthorizationHeader])
        NSURLSession.sharedSession().sendHttRequest(request) { (data, error) in
           
            guard error == nil else {
                print(error?.description)
                return
            }

            guard let string = String(data: data, encoding: NSUTF8StringEncoding), tokensDict = string.transformToDictionary, oAuthToken = tokensDict["oauth_token"] as? String else {
                return
            }
          
            self.twitterAPIRequestAuthentication(oAuthToken)
        }
    }
    
    // MARK: Twitter API Authentication
    func twitterAPIRequestAuthentication(oAuthToken: String) {
        
        guard let authenticateURLComponents = NSURLComponents(string: TwitterAPIURLS.authenticationURL) else {
            print("cant get authentication URL")
            return
        }
        
        
        let query = NSURLQueryItem(name: "oauth_token", value: oAuthToken)
        authenticateURLComponents.queryItems = [query]
        
        if let authenticateURL = authenticateURLComponents.URL where UIApplication.sharedApplication().canOpenURL(authenticateURL) {
            UIApplication.sharedApplication().openURL(authenticateURL)
        } else {
            print("Can't open authenticateURL")
        }
    }
    
    func getAccessToken(notification: NSNotification) {
        guard let twitterAPICredential = notification.userInfo?["credential"] as? TwitterAccountCredential else {
            return
        }

        twitterAPIManager = TwitterAPIManager(twitterAccountCredential: twitterAPICredential)
        twitterAPIManager.delegate = self
        
    }
}

extension ViewController: TwitterAPIManagerDelegate {
    func twitterAPIManager(twitterApiManager: TwitterAPIManager, didGetUserCredentials: Dictionary<String, AnyObject>) {
        print(didGetUserCredentials)
    }
    
    func twitterAPIManager(twitterApiManager: TwitterAPIManager, didFialWithError error: NSError) {
        print(error.description)
    }
}























