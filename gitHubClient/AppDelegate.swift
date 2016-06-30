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
    var oAuthViewController: OAuthViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.checkOAuthStatus()
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpernURL func URL:\(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.Keychain) { (sucess) in
            if sucess{
                //print("We have a token!!")
        
            }
        }
        return true
    }
    

    func checkOAuthStatus(){
        do{
            if let token = try GitHubOAuth.shared.accessToken(){ print(token) }
            
            
        }catch _{}
    }

    func presentOAuthViewController(){
        guard let homeViewController = self.window?.rootViewController as? HomeViewController else{fatalError("Check your Root View Controller")}
        guard let storyboard = homeViewController.storyboard else {fatalError("Check for Storyboard")}
        guard let oAuthViewController = storyboard.instantiateViewControllerWithIdentifier(OAuthViewController.id) as?
            OAuthViewController else {fatalError("Error with OAuthVC")}
        
    }
}

