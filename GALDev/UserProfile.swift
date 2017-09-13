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
    
    var userDictionary = Home.GlobalsVariables.user
    
    @IBOutlet var firstNameLabel : UILabel!
    @IBOutlet var lastNameLabel : UILabel!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var mobileNumberLabel : UILabel!
    @IBOutlet var emailLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        firstNameLabel.text = userDictionary["name"] as? String
        lastNameLabel.text = userDictionary["surname"] as? String
        usernameLabel.text = userDictionary["username"] as? String
        mobileNumberLabel.text = userDictionary["mobileNumber"] as? String
        emailLabel.text = userDictionary["email"] as? String
        
    }
}
