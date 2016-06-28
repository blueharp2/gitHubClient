//
//  GitHubOAuth.swift
//  gitHubClient
//
//  Created by Lindsey on 6/27/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import Foundation

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


