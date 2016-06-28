//
//  GitHubOAuth.swift
//  gitHubClient
//
//  Created by Lindsey on 6/27/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import UIKit

let kAccessToKey = "kAccessToKey"
let kOAuthBaseURL = "htpps://github.com/login/oauth/"
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
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessToKey)
        
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func tokenRequestWithCallback(url:NSURL, options: SaveOptions, completion: GitHubOAuthCompletion){
        
    }
    
}