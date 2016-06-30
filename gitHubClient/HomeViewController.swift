//
//  HomeViewController.swift
//  gitHubClient
//
//  Created by Lindsey on 6/29/16.
//  Copyright © 2016 Lindsey Boggio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }



}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
}