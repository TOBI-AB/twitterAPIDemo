//
//  AppDelegate.swift
//  OAuthRevTwitterAPI
//
//  Created by AbdouEtt on 08/06/2016.
//  Copyright © 2016 AbdouEtt. All rights reserved.
//

import UIKit
import OAuthCore
import Accounts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        guard let urlQuery = url.query where !urlQuery.isEqual(NSNull) else {
            return false
        }
        
        if let oAuthTokenDict = urlQuery.transformToDictionary  {
            verifyAccessToken(from: oAuthTokenDict)
        }
      
        return true
    }

}

// MARK: - Helpers
extension AppDelegate {
    func verifyAccessToken(from accessTokenDict: Dictionary<String, AnyObject>) {
        
        guard let oauthToken = accessTokenDict["oauth_token"] as? String, oauthVerifier = accessTokenDict["oauth_verifier"] as? String else {
            return
        }
        
        guard let accessTokenURL = NSURL(string: TwitterAPIURLS.accessTokenURLPath, relativeToURL: TwitterAPIURLS.base)?.absoluteURL else {
            return
        }
        
        var oAuthorizationHeaderString = OAuthorizationHeader(accessTokenURL, "POST", nil, TwitterAPIKeys.consumerKey, TwitterAPIKeys.consumerSecret, oauthToken, nil)
        let encodedOAuthVerifier = oauthVerifier.stringByAddingPercentEncodingForRFC3986()!
        oAuthorizationHeaderString = oAuthorizationHeaderString.stringByAppendingFormat(", oauth_verifier=\(encodedOAuthVerifier)")
        
        let verifyAccessTokenRequest = NSURLRequest.httpRequest(accessTokenURL, method: "POST", header: ["Authorization": oAuthorizationHeaderString])
     
        NSURLSession.sharedSession().sendHttRequest(verifyAccessTokenRequest) { (data, error) in
            guard let string = String(data: data, encoding: NSUTF8StringEncoding) else {
                return
            }
            
            guard let OAuthToken = string.transformToDictionary?["oauth_token"] as? String,  OAuthTokenSecret = string.transformToDictionary?["oauth_token_secret"] as? String else {
                return
            }
            
            let twitterAccountCredential = TwitterAccountCredential(OAuthToken: OAuthToken, OAuthTokenSecret: OAuthTokenSecret)
            NSNotificationCenter.defaultCenter().postNotificationName("twitterAccountCredential", object: self, userInfo: ["credential": twitterAccountCredential])
        }
        
    }
}






















