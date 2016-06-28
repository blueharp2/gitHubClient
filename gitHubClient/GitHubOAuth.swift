//
//  GitHubOAuth.swift
//  gitHubClient
//
//  Created by Lindsey on 6/27/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import UIKit

let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURL = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GitHubOAuthCompletion = (sucess:Bool) -> ()

enum GitHubOAuthError: ErrorType{
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporaryCode(String)
    case ResponseFromGitHub(String)
}

enum SaveOptions: Int{
    case userDefaults
}


class GitHubOAuth{
    static let shared = GitHubOAuth()

    private init(){}
    
    
    func oAuthRequestWith(parameters: [String : String]){
        var parameterString = String()
        
        for parameter in parameters.values{
            parameterString = parameterString.stringByAppendingString(parameter)
        }
        
        if let requestURL = NSURL(string: "\(kOAuthBaseURL)authorize?client_id=\(kGitHubClientID)&scope=\(parameterString)"){
           print(requestURL)
            
            UIApplication.sharedApplication().openURL(requestURL)
        }
    }
    
    
    func temporaryCodeFromCallback(url:NSURL)throws -> String{
        print(url.absoluteString)
        
        guard let termporaryCode = url.absoluteString.componentsSeparatedByString("=").last else{
            throw GitHubOAuthError.ExtractingTemporaryCode("Error: Extraction of Temporary Code Failed")
        }
        print(termporaryCode)
        
        return termporaryCode
    }
    
    
    func stringWith(data:NSData) ->String?{
        let byteBuffer:UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
    
        let result = String(bytes:byteBuffer, encoding: NSASCIIStringEncoding)
        
        return result
    }
    
    
    func accessTokenFromString(string:String)throws -> String?{
        do{
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: .CaseInsensitive)
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            
            if matches.count > 0{
                for(_,value)in matches.enumerate(){
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
            
        }catch _{
            throw GitHubOAuthError.ExtractingTokenFromString("Could Not Extract Token From String")
        }
        return nil
    }
    
    
    func someAccessTokenToUserDefaluts(accessToken:String) -> Bool{
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func tokenRequestWithCallback(url:NSURL, options: SaveOptions, completion: GitHubOAuthCompletion){
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            
            let requestString = "\(kOAuthBaseURL)access_token?client_id=\(kGitHubClientID)&client_secret =\(kGitHubClientLicense)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString){
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) in
                    if let _ = error{
                        NSOperationQueue.mainQueue().addOperationWithBlock({ 
                            completion(sucess: false);
                            return
                        })
                    }
                    if let data = data{
                        if let tokenString = self.stringWith(data){
                            do{
                                if let token = try self.accessTokenFromString(tokenString){
                                    NSOperationQueue.mainQueue().addOperationWithBlock({ 
                                        completion(sucess: self.someAccessTokenToUserDefaluts(token))
                                    })
                                }
                            } catch _{
                                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                                    completion(sucess: false)
                                })
                            }
                        }
                    }
                }).resume()
            }
        } catch _{
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                completion(sucess: false)
            })
        }
    }
    
    func accessToken() throws ->String?{
        
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else{
            throw GitHubOAuthError.MissingAccessToken("There is no Access Token saved.")
        }
        return accessToken
    }
        
        
}