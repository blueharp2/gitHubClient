//
//  ViewController.swift
//  gitHubClient
//
//  Created by Lindsey on 6/27/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController, Setup {

    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
    }

    func setup(){
        
    }
    
    func setupAppearance(){
        self.logInButton.layer.cornerRadius = 3.0
    }
    
    @IBAction func logInButtonSelected(sender: AnyObject) {
        GitHubOAuth.shared.oAuthRequestWith(["scope" : "email,user,repo"])
    }
}


