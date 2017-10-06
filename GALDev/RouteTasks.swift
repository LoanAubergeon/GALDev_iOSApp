//
//  RouteTasks.swift
//  GALDev
//
//  Created by Loan Aubergeon on 29/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation

class RouteTasks {
    
    var token = Home.UserConnectedInformations.userToken
    
    var mapTasks = MapTasks()
    
    
    // Variable de stockage
    var routes : [Route] = []
    
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
                        
                        
                        let jsonObjects = (jsonResult[index]) as AnyObject
                        
                        let driverId = (jsonObjects["driver"] as! Int)
                        let routeId = (jsonObjects["route"] as! Int)
                        
                        let startingPoint = jsonObjects["startingPoint"] as AnyObject
                        let endPoint = jsonObjects["endPoint"] as AnyObject
                        
                        let xStart = startingPoint["x"] as! Float
                        let yStart = startingPoint["y"] as! Float
                        let xEnd = endPoint["x"] as! Float
                        let yEnd = endPoint["y"] as! Float
                        
                        let addressStart = String(xStart)+" "+String(yStart)
                        let addressEnd = String(xEnd)+" "+String(yEnd)
                        
                        self.mapTasks.getDirections(origin: addressStart, destination: addressEnd, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                            if success{
                                
                                let originName = (self.mapTasks.originAddress)
                                let destinationName = (self.mapTasks.destinationAddress)
                                
                                let route = Route.init(id: routeId, originName: originName!, destinationName: destinationName!, driver: driverId)
                                self.routes.append(route)
                                
                                if compteur == (jsonResult).count-1 {
                                    completionHandler("Ok", true)
                                }
                                
                                compteur = compteur + 1
                                
                            } else {
                                completionHandler(status, false)
                            }
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
