//
//  RouteTasks.swift
//  GALDev
//
//  Created by Loan Aubergeon on 29/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation

class RouteTasks {
    
    var token = Home.GlobalsVariables.userToken
    
    var mapTasks = MapTasks()
    
    
    // Variable de stockage
    var nameOfRoutesStart: [String] = []
    var nameOfRoutesEnd: [String] = []
    var driver: [Int] = []
    var routeId: [Int] = []
    
    func route(date: String, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        
        let url = NSURL(string: ServerAdress+":3000/api/search?date="+date)!
        
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
                
                var compteur = 0
                
                if (jsonResult).count > 0 {
                    for index in 0...(jsonResult).count-1 {
                        
                        DispatchQueue.main.async(execute: {
                            
                            let jsonObjects = (jsonResult[index]) as AnyObject
                            
                            let startingPoint = jsonObjects["startingPoint"] as AnyObject
                            let endPoint = jsonObjects["endPoint"] as AnyObject
                            
                            self.driver.append(jsonObjects["driver"] as! Int)
                            
                            self.routeId.append(jsonObjects["route"] as! Int)
                            
                            let xStart = startingPoint["x"] as! Float
                            let yStart = startingPoint["y"] as! Float
                            let xEnd = endPoint["x"] as! Float
                            let yEnd = endPoint["y"] as! Float
                            
                            let addressStart = String(xStart)+" "+String(yStart)
                            let addressEnd = String(xEnd)+" "+String(yEnd)
                            
                            //print(jsonObjects)
                            //print(addressStart)
                            //print(addressEnd)
                            //print(self.routeId)
                            
                            self.mapTasks.getDirections(origin: addressStart, destination: addressEnd, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                                //print(" ###################### ETAPE : "+String(index)+" #########################")
                                if success{
                                    //print(status)
                                    //print("Etape1 : Ajout du nom des routes")
                                    //print(self.nameOfRoutesStart.count)
                                    self.nameOfRoutesStart.append(self.mapTasks.originAddress)
                                    self.nameOfRoutesEnd.append(self.mapTasks.destinationAddress)
                                    //print("Etape2 : Route ajouté")
                                    //print(self.nameOfRoutesStart.count)
                                    
                                    
                                    //print("Etape 3 : Verification du compteur")
                                    //print("Compteur : "+String(compteur))
                                    //print("Condition : "+String((jsonResult).count-1))
                                    
                                    if compteur == (jsonResult).count-1 {
                                        //print("Entré dans la boucle")
                                        //print(self.nameOfRoutesStart.count)
                                        //self.nameOfRoutesStart.append(self.mapTasks.originAddress)
                                        //self.nameOfRoutesEnd.append(self.mapTasks.destinationAddress)
                                        //print("Etape4 : DerniereRoute ajouté")
                                        //print(self.nameOfRoutesStart.count)
                                        completionHandler("Ok", true)
                                    }
                                    //print("Etape 5 : Fin de la boucle, #############################################")
                                    compteur = compteur + 1
                                    //print("Compteur : "+String(compteur))
                                } else {
                                    completionHandler(status, false)
                                }
                            })
                        })
                    }
                }
                
            } catch { // On catch les erreurs potentielles
                print(error)
                completionHandler(error as! String, false)
            }
            
        }
        task.resume()
        
    }
}
