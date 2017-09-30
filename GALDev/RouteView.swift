//
//  RouteView.swift
//  GALDev
//
//  Created by Loan Aubergeon on 11/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation
import GoogleMaps


/// Classe permettant d'afficher les informations d'une route existente
class RouteView : UIViewController {
    
    //  #################### Variables ####################
    
    /// Variables des Maps
    
    /// The map
    @IBOutlet var viewMap : GMSMapView?
    
    /// Markers
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    
    /// The route (draw)
    var routePolyline: GMSPolyline!
    
    
    /// Tasks
    var mapTasks = MapTasks()
    var routeTasks = RouteTasks()
    var userTasks = UserTasks()
    
    
    /// User's Token
    var token = Home.GlobalsVariables.userToken
    
    
    /// Adress
    var origin : String!
    var destination : String!
    
    /// Driver's Id
    var driverIndex : Int!
    
    /// Liste d'origines l'ensembles des routes
    var nameOfRoutesStart: [String] = []
    var nameOfRoutesEnd: [String] = []
    
    ///Listes des conducteurs
    var driver: [Int] = []
    
    /// Listes de Id des routes
    var routeId: [Int] = []
    
    /// Labels pour affichage des informations
    @IBOutlet var originLabel : UILabel?
    @IBOutlet var destinationLabel : UILabel?
    @IBOutlet var usernameDriverLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var weeklyreccurenceLabel : UILabel?
    @IBOutlet var durationLabel : UILabel?
    @IBOutlet var distanceLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async{
            self.routeTasks.route(completionHandler: { (status, success) -> Void in
                if success {
                    self.nameOfRoutesStart = self.routeTasks.nameOfRoutesStart
                    self.nameOfRoutesEnd = self.routeTasks.nameOfRoutesEnd
                    self.driver = self.routeTasks.driver
                    self.routeId = self.routeTasks.routeId
                    
                    self.origin = self.nameOfRoutesStart[myIndex]
                    self.destination = self.nameOfRoutesEnd[myIndex]
                    self.driverIndex = self.driver[myIndex]
                    
                    self.originLabel?.text = self.nameOfRoutesStart[myIndex]
                    self.destinationLabel?.text = self.nameOfRoutesEnd[myIndex]
                    
                    
                    self.userTasks.user(driverId: self.driverIndex, completionHandler: { (status, success) -> Void in
                        if success {
                            self.usernameDriverLabel?.text = self.userTasks.username
                            
                            self.createRoute()
                            self.routeDate()
                        }
                    })
                    
                }
            })
            
            
            
            
        }
    }
    

    func createRoute() {
        // Requete à Google pour creer une route
        self.mapTasks.getDirections(origin: origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                self.viewMap?.clear()
                self.configureMapAndMarkersForRoute()
                self.drawRoute()
                self.displayRouteInfo()
                
            }
            else {
                print(status)
            }
        })
        
    }
    
   
    
    func routeDate() {
        
        let routeID = String(self.routeId[myIndex])
        
        let urlString : String = ServerAdress+":3000/api/routedate/"+routeID
        
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
                    for index in 0...(jsonResult).count-1 {
                        let jsonObjects = (jsonResult[index]) as AnyObject
                        let stringDate = jsonObjects["route_date"] as? String
                        /*for i in 0...(2) {
                            stringDate?.remove(at: (stringDate?.endIndex)!)
                        }*/
                        self.dateLabel?.text = stringDate?.replacingOccurrences(of:"T", with: " ").replacingOccurrences(of:"Z", with: " ")
                        
                        
                        let intRec = jsonObjects["weekly_repeat"] as? Int
                        if intRec == 1 {
                            self.weeklyreccurenceLabel?.text = "True"
                        } else {
                            self.weeklyreccurenceLabel?.text = "False"
                        }
                        
                    }
                })
                
            } catch { // On catch les erreurs potentielles
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.strokeWidth = 5
        routePolyline.strokeColor = UIColor.blue
        routePolyline.map = viewMap
    }
    
    func configureMapAndMarkersForRoute() {
        viewMap?.camera = GMSCameraPosition.camera(withTarget: mapTasks.originCoordinate, zoom: 10.0)
        
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.title = self.mapTasks.destinationAddress
        
    }
    
    func displayRouteInfo() {
        DispatchQueue.main.async() {
            self.durationLabel?.text = self.mapTasks.totalDuration
            self.distanceLabel?.text = self.mapTasks.totalDistance
        }
    }
    

    

}
