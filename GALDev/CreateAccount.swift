//
//  CreateAccount.swift
//  GetALiftDev
//
//  Created by Loan Aubergeon on 17/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit

class CreateAccount : UIViewController {
    
    @IBOutlet var usernameF : UITextField!
    @IBOutlet var passwordF : UITextField!
    @IBOutlet var nameF : UITextField!
    @IBOutlet var surnameF : UITextField!
    @IBOutlet var emailF : UITextField!
    @IBOutlet var mobileNumberF : UITextField!
    
    
    @IBAction func createAccount (sender:UIButton){
        
        let username = usernameF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let password = passwordF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let name = nameF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let surname = surnameF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let email = emailF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        let mobileNumber = mobileNumberF.text?.replacingOccurrences(of:" ", with: "").replacingOccurrences(of: ",", with: "")
        
        
        if (username == "") || (password == "") || (name == "") || (surname == "") || (email == "") || (mobileNumber == ""){
            //retourner message erreur
            return
        }
        
        let account = "username="+username!+"&password="+password!+"&name="+name!+"&surname="+surname!+"&email="+email!+"&mobileNumber="+mobileNumber!
        
        let url = NSURL(string: "http://169.254.111.193:3000/api/users")!
        
        var request = URLRequest(url: url as URL)
        
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
                    return
                }
                // Convert server json response to NSDictionary
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        DispatchQueue.main.async() { // Permet de mettre a jour l'UI sans attendre la fin du task
                            
                            let success = parseJSON["success"] as? Bool
                            if success! {
                                print("Utilisateur ajouté")
                            }
                            self.performSegue(withIdentifier: "backSegue", sender: nil)
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            task.resume()
        }
    }
    
    // Ferme le clavier quand l'utilisateur touche l'ecran
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
