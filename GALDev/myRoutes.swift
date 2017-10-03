//
//  myRoutes.swift
//  GALDev
//
//  Created by Loan Aubergeon on 03/10/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation

class myRoutes : UIViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    var userDictionary = Home.GlobalsVariables.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
}
