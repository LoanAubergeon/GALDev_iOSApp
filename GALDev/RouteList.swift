//
//  RouteList.swift
//  GALDev
//
//  Created by Loan Aubergeon on 29/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit

var nameOfRoutesStart: [String] = []
var nameOfRoutesEnd: [String] = []
var driver: [Int] = []
var id: [Int] = []
var myIndex : Int = 0


class RouteList : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Route recherché 
    var origin : String! = SearchRoute.TransfertDonnee.originT
    var destination : String! = SearchRoute.TransfertDonnee.destinationT
    var token = Home.GlobalsVariables.userToken
    
    @IBOutlet var routeTableView : UITableView!
    
    // Coordonate
    var xStartingPoint: [Float] = []
    var xEndPoint: [Float] = []
    var yStartingPoint: [Float] = []
    var yEndPoint: [Float] = []
    
    var mapTasks = MapTasks()
    var userTasks = UserTasks()
    
    override func viewDidLoad() {
        
        // On vide ces tableaux
        nameOfRoutesEnd = []
        nameOfRoutesStart = []
        driver = []
        myIndex = 0
        id = []
        
        
        self.routeList()
        routeTableView.dataSource = self
        routeTableView.delegate = self
        self.routeTableView.reloadData()
    }
    
    //Nombre de sections en tout
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return id.count
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Routes : "
        default: return ""
        }
    }
    
    
    //Cellule à l'index concerné
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCustomCell
        for i in 0...nameOfRoutesStart.count {
            if (indexPath.row == i) {
                cell.originLabel.text = nameOfRoutesStart[i]
                cell.destinationLabel.text = nameOfRoutesEnd[i]
                let id = driver[i]
                self.userTasks.user(driverId: id, completionHandler: { (status, success) -> Void in
                    if success {
                        cell.driverLabel.text = self.userTasks.username
                    }
                })
                cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    

    
    // Requete pour avoir la liste des routes
    func routeList(){
    
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
                            
                            id.append(jsonObjects["id"] as! Int)
                            driver.append(jsonObjects["driver"] as! Int)
                            
                            let xStart = startingPoint["x"] as! Float
                            let yStart = startingPoint["y"] as! Float
                            let xEnd = endPoint["x"] as! Float
                            let yEnd = endPoint["y"] as! Float
                            
                            let addressStart = String(xStart)+" "+String(yStart)
                            let addressEnd = String(xEnd)+" "+String(yEnd)
                            
                            self.mapTasks.getDirections(origin: addressStart, destination: addressEnd, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                                if success{
                                    nameOfRoutesStart.append(self.mapTasks.originAddress)
                                    nameOfRoutesEnd.append(self.mapTasks.destinationAddress)
                                } else {
                                    print(status)
                                    print("Erreur")
                                }
                            })
                            self.routeTableView.reloadData()
                    }

            } catch { // On catch les erreurs potentielles
                print(error)
            }
            
        }
        task.resume()
        
    }
}
