//
//  userProfile.swift
//  GALDev
//
//  Created by Loan Aubergeon on 30/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit


class UserProfile : UIViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
