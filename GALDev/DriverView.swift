//
//  DriverView.swift
//  GALDev
//
//  Created by Loan Aubergeon on 18/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit
import MessageUI


class DriverView : UIViewController, MFMailComposeViewControllerDelegate {
    
    var userTasks = UserTasks()
    var routeTasks = RouteTasks()
    
    var token = Home.GlobalsVariables.userToken
    
    var driverId : Int!
    
    var driverEmail = ""
    var mobileNumber = ""
    
    var driver: [Int] = []
    
    @IBOutlet var firstNameLabel : UILabel!
    @IBOutlet var lastNameLabel : UILabel!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var mobileNumberLabel : UILabel!
    @IBOutlet var emailLabel : UILabel!
    
    override func viewDidLoad() {
        
        self.routeTasks.route(completionHandler: { (status, success) -> Void in
            if success {
                
                self.driver = self.routeTasks.driver
            }
        })
        
        self.driverId = self.driver[myIndex]
        
        self.userTasks.user(driverId: self.driverId, completionHandler: { (status, success) -> Void in
            if success {
                self.firstNameLabel?.text = self.userTasks.name
                self.lastNameLabel?.text = self.userTasks.surname
                self.usernameLabel?.text = self.userTasks.username
                self.mobileNumberLabel?.text = self.userTasks.mobileNumber
                self.driverEmail = self.userTasks.email
                self.mobileNumber = self.userTasks.mobileNumber
                self.emailLabel?.text = self.userTasks.email
            }
        })
        
        
        
    }
    
    
    @IBAction func mailCompose (sender: Any){
        
        //Envoie d'un mail
        //On crée un composeur de mails
        let mc = MFMailComposeViewController()
        //On lui donne son "délégué"
        mc.mailComposeDelegate = self
        //On donne des destinataires au mail
        mc.setToRecipients([driverEmail])
        //On donne un sujet
        mc.setSubject("From my first app")
        //Et on peut même écrire le corps du texte
        mc.setMessageBody("Hi there,\n I am interested in your route", isHTML: false)
        //On le montre
        self.present(mc, animated: true, completion: nil)
        
    }
    
    // Appelée lorsque l'utilisateur a fini avec ses mails
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func phoneCompose (sender: Any){
        if let url = URL(string: "tel://\(mobileNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
