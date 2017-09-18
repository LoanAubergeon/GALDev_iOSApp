//
//  ViewController.swift
//  GetALiftDev
//
//  Created by Loan Aubergeon on 10/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit

var ServerAdress : String = "http://169.254.174.170"

// ----------------------------------------------------------------------------------------------------------------------------------------------------------------

// First page when you open the app
class Home: UIViewController {
    
    @IBOutlet var texteTest :UILabel!
    
    // TextField to enter identifier
    @IBOutlet var usernameField :UITextField!
    @IBOutlet var passwordField :UITextField!
    
    // Structure to access token, and user's informations
    struct GlobalsVariables {
        static var userToken : String = ""
        static var userName : String = ""
        static var user : NSDictionary = [:]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Function to manage the authentification
    @IBAction func authentification(sender :UIButton){
        
        let username = usernameField.text
        let password = passwordField.text
        
        if (username == "") || (password == "") {
            self.texteTest.textColor = UIColor.red
            self.texteTest.text = "Please enter your username"
            return
        }
        
        let login = "name="+username!+"&password="+password!
        
        let url = NSURL(string: ServerAdress+":3000/api/auth")!
        
        var request = URLRequest(url: url as URL)
        
        do {
            // Set the request content type to JSON
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // The magic...set the HTTP request method to POST
            request.httpMethod = "POST"
            
            // Add the JSON serialized login data to the body
            request.httpBody = login.data(using: String.Encoding.utf8)

            
            // Execute the request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                // Check for error
                if error != nil
                {
                    print("Error")
                    return
                }
                // Convert server json response to NSDictionary
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        DispatchQueue.main.async() { // Permet de mettre a jour l'UI sans attendre la fin du task
                            let messageTest = parseJSON["message"] as? String
                            self.texteTest.text=messageTest
                            
                            let token = parseJSON["token"] as? String
                            
                            let user = (parseJSON["user"]) as! NSDictionary
                            print(user)
                            
                            let username = user["username"] as! String
                            
                            let success = parseJSON["success"] as? Bool
                            
                            if success == true {
                                // show the first view with a delay !
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                                    //On récupère Main.storyboard
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    //On crée une instance d'Exercice à partir du storyboard
                                    let transitionPage = storyboard.instantiateViewController(withIdentifier: "transitionPage") as! SWRevealViewController
                                    //On montre le nouveau controller
                                    GlobalsVariables.userToken = token!
                                    GlobalsVariables.userName = String(describing: username)
                                    GlobalsVariables.user = user 
                                    self.present(transitionPage, animated: true, completion: nil)
                                })
                            } else {
                                self.texteTest.textColor = UIColor.red
                                self.texteTest.text = "Authentification failed"
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            task.resume()
        }
        
    }
    
    // Fonction pour creer des popup
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Fonction pour cacher le clavier quand on touche sur l'ecrans
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

