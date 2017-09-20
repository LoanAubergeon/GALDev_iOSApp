///
///  ViewController.swift
///  GetALiftDev
///
///  Created by Loan Aubergeon on 10/08/2017.
///  Copyright © 2017 Loan Aubergeon. All rights reserved.
///

import UIKit

/// The address of the server user
var ServerAdress : String = "http://169.254.63.107"


///The first page that opens when you launch the application
class Home: UIViewController {
    
    //  #################### Variables ####################
    
    ///Test label to write informations
    @IBOutlet var texteTest :UILabel!
    
    ///TextFields to enter identifiers
    @IBOutlet var usernameField :UITextField!
    @IBOutlet var passwordField :UITextField!
    
    
    //  #################### Structures ####################
    
    
    ///Structure to access token, and informations about the user who are connected
    ///  - Parameters :
    ///    - userToken : The user's Token given by the database.
    ///    - userName : The user's username.
    ///    - user : Informations from the database about the user.
    struct GlobalsVariables {
        static var userToken : String = ""
        static var userName : String = ""
        static var user : NSDictionary = [:]
    }
    

    //  #################### Functions ####################
    
    ///Function to manage the authentification
    @IBAction func authentification(sender :UIButton){
        
        /// Recovery of identifiers
        let username = usernameField.text
        let password = passwordField.text
        
        /// If they are null we display an error
        if (username == "") || (password == "") {
            self.texteTest.textColor = UIColor.red
            self.texteTest.text = "Please enter your username"
            return
        }
        
        /// String to transmit the identifiers to the request
        let login = "name="+username!+"&password="+password!
        
        /// The URL
        let url = NSURL(string: ServerAdress+":3000/api/auth")!
        
        /// The request
        var request = URLRequest(url: url as URL)
        
        do {
            /// Set the request content type to JSON
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            /// Set the HTTP request method to POST
            request.httpMethod = "POST"
            
            /// Add the JSON serialized login data to the body
            request.httpBody = login.data(using: String.Encoding.utf8)

            /// Execute the request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                /// Check for error
                if error != nil
                {
                    print("Error")
                    return
                }
                /// Convert server json response to NSDictionary
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        /// The application is not expected to be completed
                        DispatchQueue.main.async() {
                            
                            /// Recovery of the user's token
                            let token = parseJSON["token"] as? String
                            GlobalsVariables.userToken = token!
                            
                            /// Recovery of user's information
                            let user = (parseJSON["user"]) as! NSDictionary
                            GlobalsVariables.user = user
                            
                            /// Recovery of user's name
                            let username = user["username"] as! String
                            GlobalsVariables.userName = String(describing: username)
                            
                            /// Recovery of request state
                            let success = parseJSON["success"] as? Bool
                            
                            /// If the request has worked
                            if success == true {
                                
                                /// show the first view with a delay !
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                                    
                                    /// Recovery Main.storyboard
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    /// Create a transition page to access the main page
                                    let transitionPage = storyboard.instantiateViewController(withIdentifier: "transitionPage") as! SWRevealViewController
                                    
                                    /// Acces to the main page
                                    self.present(transitionPage, animated: true, completion: nil)
                                })
                            } else { /// If the request hasn't worked we show the error
                                self.texteTest.textColor = UIColor.red
                                self.texteTest.text = "Authentification failed"
                            }
                        }
                    }
                } catch let error as NSError { /// If the request hasn't worked we show the error
                    print(error.localizedDescription)
                }
                
            }
            task.resume()
        }
        
    }
    
    
    
    /// To create alerts in the app
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Function to hide the keyboard when touching on the screens
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

