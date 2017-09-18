//
//  RouteView.swift
//  GALDev
//
//  Created by Loan Aubergeon on 11/09/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation
import GoogleMaps



class RouteView : UIViewController {
    
    @IBOutlet var viewMap : GMSMapView?
    
    var originMarker: GMSMarker!
    
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    
    var mapTasks = MapTasks()
    
    var token = Home.GlobalsVariables.userToken
    var origin : String = nameOfRoutesStart[myIndex]
    var destination : String = nameOfRoutesEnd[myIndex]
    var driverIndex = driver[myIndex]
    
    @IBOutlet var originLabel : UILabel?
    @IBOutlet var destinationLabel : UILabel?
    @IBOutlet var usernameDriverLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originLabel?.text = nameOfRoutesStart[myIndex]
        destinationLabel?.text = nameOfRoutesEnd[myIndex]
        self.createRoute()
        self.driverName()
    }
    

    func createRoute() {
        // Requete à Google pour creer une route
        self.mapTasks.getDirections(origin: origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                self.viewMap?.clear()
                self.configureMapAndMarkersForRoute()
                self.drawRoute()
                
                DispatchQueue.main.async(execute: {
                })
                
            }
            else {
                print(status)
            }
        })
        
    }
    
    func driverName() {
        
        let driverID = String(driverIndex)
        
        let urlString : String = ServerAdress+":3000/api/users/"+driverID
        
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

                        self.usernameDriverLabel?.text = jsonObjects["username"] as? String

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
        viewMap?.camera = GMSCameraPosition.camera(withTarget: mapTasks.originCoordinate, zoom: 8.0)
        
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.title = self.mapTasks.destinationAddress

    }
    

    

}
