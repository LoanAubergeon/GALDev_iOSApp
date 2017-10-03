//
//  DriverView.swift
//  GALDev
//
//  Created by Loan Aubergeon on 18/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit
import MessageUI


class DriverView : UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var userTasks = UserTasks()
    var routeTasks = RouteTasks()
    
    var token = Home.GlobalsVariables.userToken
    
    var driverId : Int!
    
    var driverEmail = ""
    var mobileNumber = ""
    
    var driver: [Int] = []
    
    var time : String! = SearchRoute.TransfertDonnee.timeT
    var date : String! = SearchRoute.TransfertDonnee.dateT
    
    @IBOutlet var firstNameLabel : UILabel!
    @IBOutlet var lastNameLabel : UILabel!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var mobileNumberLabel : UILabel!
    @IBOutlet var emailLabel : UILabel!
    
    
    
    override func viewDidLoad() {
        
        let fullDate : String = date+""+time
        self.routeTasks.route(date: fullDate, completionHandler: { (status, success) -> Void in
            
            if success {
                
                self.driver = self.routeTasks.driver
                
                // Position anormale
                self.driverId = self.driver[myIndex]
                
                // Position anormale
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
        })
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Hello, I am interested for traveling this route with you";
        messageVC.recipients = [self.mobileNumber]
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
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
