//
//  AppDelegate.swift
//  gitHubClient
//
//  Created by Lindsey on 6/27/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpernURL func URL:\(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.Keychain) { (sucess) in
            if sucess{
                print("We have a token!!")
               // self.checkOAuthStatus()
            }
        }
        return true
    }
    
//        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.UserDefaults) { (sucess) in
//            if sucess{
//                print("We have a token!!")
//            }
//        }
//        return true
//    }

    func checkOAuthStatus(){
        do{
            let token = try GitHubOAuth.shared.accessToken()
            print(token)
        }catch _{ fatalError("No Token Found")}
    }

}

