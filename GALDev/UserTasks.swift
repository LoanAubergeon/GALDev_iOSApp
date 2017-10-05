//
//  UserTasks.swift
//  GALDev
//
//  Created by Loan Aubergeon on 29/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit

class UserTasks {
    
    var token = Home.GlobalsVariables.userToken
    
    // User's informations
    var userDictionary : NSDictionary!
    var username : String!
    var surname : String!
    var name : String!
    var email : String!
    var mobileNumber : String!
    
    func user(driverId: Int!, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
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
                        
                        self.userDictionary = jsonResult[0] as! NSDictionary
                        self.name = jsonObjects["name"] as? String
                        self.surname = jsonObjects["surname"] as? String
                        self.username = jsonObjects["username"] as? String
                        self.mobileNumber = jsonObjects["mobileNumber"] as? String
                        self.email = (jsonObjects["email"] as? String)!
                        completionHandler("Ok", true)
                        

                    })
                } catch { // On catch les erreurs potentielles
                    print(error)
                    completionHandler("", false)
                }
            }
            task.resume()
    }
}
