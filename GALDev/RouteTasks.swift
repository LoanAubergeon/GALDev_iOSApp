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
    
    func route(completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        let url = NSURL(string: ServerAdress+":3000/api/routes/")!
        
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
                
                for index in 0...(jsonResult).count-1 {
                    let jsonObjects = (jsonResult[index]) as AnyObject
                    
                    let startingPoint = jsonObjects["startingPoint"] as AnyObject
                    let endPoint = jsonObjects["endPoint"] as AnyObject
                    
                    self.driver.append(jsonObjects["driver"] as! Int)
                    
                    self.routeId.append(jsonObjects["id"] as! Int)
                    
                    let xStart = startingPoint["x"] as! Float
                    let yStart = startingPoint["y"] as! Float
                    let xEnd = endPoint["x"] as! Float
                    let yEnd = endPoint["y"] as! Float
                    
                    let addressStart = String(xStart)+" "+String(yStart)
                    let addressEnd = String(xEnd)+" "+String(yEnd)
                    
                    self.mapTasks.getDirections(origin: addressStart, destination: addressEnd, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                        if success{
                            self.nameOfRoutesStart.append(self.mapTasks.originAddress)
                            self.nameOfRoutesEnd.append(self.mapTasks.destinationAddress)

                            completionHandler("Ok", true)
                            
                        } else {
                            completionHandler(status, false)
                        }
                    })
                }
                
                
            } catch { // On catch les erreurs potentielles
                print(error)
                completionHandler(error as! String, false)
            }
            
        }
        task.resume()

    }
}
