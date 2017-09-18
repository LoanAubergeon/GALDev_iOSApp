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
    
    var token = Home.GlobalsVariables.userToken
    
    var driverId = driver[myIndex]
    
    var driverEmail = ""
    var mobileNumber = ""
    
    @IBOutlet var firstNameLabel : UILabel!
    @IBOutlet var lastNameLabel : UILabel!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var mobileNumberLabel : UILabel!
    @IBOutlet var emailLabel : UILabel!
    
    override func viewDidLoad() {
        self.driverInformations()
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
    
    
    func driverInformations() {
        
        let driverIdString = String(driverId)
        
        let urlString : String = ServerAdress+":3000/api/users/"+driverIdString
        
        let url = NSURL(string: urlString)!
        
        var request = URLRequest(url: url as URL)
        
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("Error")
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                
                DispatchQueue.main.async(execute: {

                    let jsonObjects = (jsonResult[0]) as AnyObject

                    self.firstNameLabel?.text = jsonObjects["name"] as? String
                    self.lastNameLabel?.text = jsonObjects["surname"] as? String
                    self.usernameLabel?.text = jsonObjects["username"] as? String
                    self.mobileNumberLabel?.text = jsonObjects["mobileNumber"] as? String
                    self.driverEmail = (jsonObjects["email"] as? String)!
                    self.mobileNumber = (jsonObjects["mobileNumber"] as? String)!
                    self.emailLabel?.text = jsonObjects["email"] as? String
                    
                    
                    
                })
                
            } catch { // On catch les erreurs potentielles
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
}
