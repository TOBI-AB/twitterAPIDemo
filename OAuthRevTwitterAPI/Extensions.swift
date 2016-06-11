//
//  Extensions.swift
//  OAuthRevTwitterAPI
//
//  Created by AbdouEtt on 08/06/2016.
//  Copyright © 2016 AbdouEtt. All rights reserved.
//

import Foundation

// MARK: - String Extension
extension String {
   
    var transformToDictionary: Dictionary<String, AnyObject>? {
        
        var tokenDict = Dictionary<String, AnyObject>()
        let resultArray = self.componentsSeparatedByString("&")
        
        _ = resultArray.map {
            let oauthComponent = $0.componentsSeparatedByString("=") as [String]
            
            guard let key = oauthComponent.first, value = oauthComponent.last else {
                return
            }
            
            tokenDict.updateValue(value, forKey: key)
        }
        
        return tokenDict
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~" //ALPHA, DIGIT, '-', '.', '_', '~'
        
        let allowed = NSMutableCharacterSet.alphanumericCharacterSet()
        allowed.addCharactersInString(unreserved)
        return stringByAddingPercentEncodingWithAllowedCharacters(allowed)
        
    }

}

// MARK: - NSURLRequest Extension
extension NSURLRequest {
   static func httpRequest(url: NSURL, method: String, body: NSData? = nil ,header: Dictionary<String, String>) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPShouldHandleCookies = false
        request.timeoutInterval = 30.0
        request.HTTPMethod = method
        _ = header.map {(key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPBody = body
        
        return request
    }
}

// MARK: - NSURLSession Extension
extension NSURLSession {
   
    func sendHttRequest(request: NSURLRequest, block: (data: NSData!, error: NSError!) -> Void) {
        
        self.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            guard error == nil else {
                block(data: nil, error: error)
                return
            }
            guard let serverResponse = (response as? NSHTTPURLResponse) where serverResponse.statusCode == 200 else {
                return
            }
            guard let responseData = data else {
                return
            }
            block(data: responseData, error: nil)
        }.resume()
    }
}

// MARK: - NSURL Extension
extension NSURL {
    func addParameters(parameters: Dictionary<String, AnyObject>) -> NSURL? {
        
        guard let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var queryItemsArray = Array<NSURLQueryItem>()
        _ = parameters.map {(key, value) in
            let queryItem = NSURLQueryItem(name: key, value: value as? String)
            queryItemsArray.append(queryItem)
        }
        urlComponents.queryItems = queryItemsArray
        
        guard let url = urlComponents.URL else {
            return nil
        }
        return url
    }
}





















