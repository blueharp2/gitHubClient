//
//  ViewController.swift
//  gitHubClient
//
//  Created by Lindsey on 6/27/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestToken(sender: AnyObject) {
        GitHubOAuth.shared.oAuthRequestWith(["scope" : "email, user"])
    }
    
    @IBAction func printToken(sender: AnyObject) {
        do{
            let token = try GitHubOAuth.shared.accessToken()
            print(token)
            
        }catch let error{
            print(error)
        }
    }

}

