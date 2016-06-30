//
//  Setup.swift
//  gitHubClient
//
//  Created by Lindsey on 6/29/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import Foundation


protocol Setup {
    static var id: String {get}
    func setup()
    func setupAppearance()
}

extension Setup{
    static var id:String{
        return String(self)
    }
}
