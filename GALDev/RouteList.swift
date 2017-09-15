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
var myIndex : Int = 0


class RouteList : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Route recherché 
    var origin : String! = SearchRoute.TransfertDonnee.originT
    var destination : String! = SearchRoute.TransfertDonnee.destinationT
    var token = Home.GlobalsVariables.userToken
    
    @IBOutlet var routeTableView : UITableView!
    
    // Route id
    var id: [Int] = []
    
    // Coordonate
    var xStartingPoint: [Float] = []
    var xEndPoint: [Float] = []
    var yStartingPoint: [Float] = []
    var yEndPoint: [Float] = []
    
    var mapTasks = MapTasks()
    
    override func viewDidLoad() {
        
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
        case 0: return self.id.count
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "basic")
        for i in 0...self.id.count-1 {
            if (indexPath.row == i) {
                
                cell.textLabel?.text = nameOfRoutesStart[i]+"  --->  "+nameOfRoutesEnd[i]+" - driver : " + String(driver[i])
                cell.textLabel?.numberOfLines = 0;
                cell.textLabel?.lineBreakMode = .byWordWrapping;
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    
    
    
    /*func findNameByCoords(){
        // Fonction pour trouver les noms d'une route a partir des coordonnées
        
        for j in 0...(self.id.count-1) {
            
            let addressStart = String(self.xStartingPoint[j])+" "+String(self.yStartingPoint[j])
            let addressEnd = String(self.xEndPoint[j])+" "+String(self.yEndPoint[j])
            
            self.mapTasks.getDirections(origin: addressStart, destination: addressEnd, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                if success{
                    self.nameOfRoutes.append(self.mapTasks.originAddress)
                    self.nameOfRoutes.append(self.mapTasks.destinationAddress)
                } else {
                    print(status)
                }
            })
        }

    }*/
    
    // Requete pour avoir la liste des routes
    func routeList(){
    
        let url = NSURL(string: "http://169.254.111.193:3000/api/routes/")!
        
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
                    //if jsonResult.count-1 > 0 {
                        for index in 0...(jsonResult).count-1 {
                            let jsonObjects = (jsonResult[index]) as AnyObject
                            
                            let startingPoint = jsonObjects["startingPoint"] as AnyObject
                            let endPoint = jsonObjects["endPoint"] as AnyObject
                            
                            self.id.append(jsonObjects["id"] as! Int)
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
                                self.routeTableView.reloadData()
                                
                            })
                            
                            // Position théorique du reloadData, sinon tester en enlevant le DispatchQueu.main... pour voir si la liste s'affiche directement, ou ajouter un delay en plus.. ou je ne sais pas :) 
                            
                        }
                    //}
                   
                })
                
                
                
            } catch { // On catch les erreurs potentielles
                print(error)
            }
            
        }
        task.resume()
        
    }
}
