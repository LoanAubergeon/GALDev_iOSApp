//
//  CreateAccount.swift
//  GetALiftDev
//
//  Created by Loan Aubergeon on 17/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit


/// View for create on account one the database
class CreateAccount : UIViewController {
    
    /// User's informations
    @IBOutlet var usernameF : UITextField!
    @IBOutlet var passwordF : UITextField!
    @IBOutlet var nameF : UITextField!
    @IBOutlet var surnameF : UITextField!
    @IBOutlet var emailF : UITextField!
    @IBOutlet var mobileNumberF : UITextField!
    
    /// The requeste on the database
    @IBAction func createAccount (sender:UIButton){
        
        let username = usernameF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let password = passwordF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let name = nameF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let surname = surnameF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let email = emailF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let mobileNumber = mobileNumberF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        
        let account = "username="+username!+"&password="+password!+"&name="+name!+"&surname="+surname!+"&email="+email!+"&mobileNumber="+mobileNumber!
        
        let url = NSURL(string: ServerAdress+":3000/api/users")!
        
        var request = URLRequest(url: url as URL)
        
        // All textfield must be completed
        if (username != "") && (password != "") && (name != "") && (surname != "") && (email != "") && (mobileNumber != ""){
            do {
                // Set the request content type to JSON
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
                // The magic...set the HTTP request method to POST
                request.httpMethod = "POST"
            
                // Add the JSON serialized login data to the body
                request.httpBody = account.data(using: String.Encoding.utf8)
            
            
                // Execute the request
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                
                    // Check for error
                    if error != nil
                    {
                        print("Error")
                        self.errorAlert(title: "Error",message: "Bad coonection")
                    }
                    // Convert server json response to NSDictionary
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                        if let parseJSON = json {
                            DispatchQueue.main.async() { // Permet de mettre a jour l'UI sans attendre la fin du task
                            
                                let success = parseJSON["success"] as? Bool
                                // Display an alert if the user has been created
                                if success! {
                                    self.errorAlert(title: "Success", message: "User has been added")
                                }
                                // After that we display the Home page
                                self.performSegue(withIdentifier: "backSegue", sender: nil)
                            }
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                task.resume()
            }
        } else {
            self.errorAlert(title: "Error",message: "Please complete all fields")
        }
    }
    
    func errorAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    // Ferme le clavier quand l'utilisateur touche l'ecran
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
