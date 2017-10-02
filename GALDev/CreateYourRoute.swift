//
//  CreateYourRoute.swift
//  GALDev
//
//  Created by Loan Aubergeon on 29/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateYourRoute : UIViewController, CLLocationManagerDelegate {
    
    
    // Variables transmises par la requetes
    var userDictionary = Home.GlobalsVariables.user
    var token = Home.GlobalsVariables.userToken
    
    var origin : String! = SearchRoute.TransfertDonnee.originT
    var destination : String! = SearchRoute.TransfertDonnee.destinationT
    
    var time : String! = SearchRoute.TransfertDonnee.timeT
    var date : String! = SearchRoute.TransfertDonnee.dateT
    
    var reccurence : Bool = SearchRoute.TransfertDonnee.reccurenceT
    
    
    
    
    // Variables utilisés pour afficher la map
    @IBOutlet var viewMap : GMSMapView?
    
    var originMarker: GMSMarker!
    
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    
    var mapTasks = MapTasks()
    
    // Variables pour l'affichage des données
    
    @IBOutlet var originLabel : UILabel?
    @IBOutlet var destinationLabel : UILabel?
    @IBOutlet var timeLabel : UILabel?
    @IBOutlet var wReccurence : UIImageView!
    @IBOutlet var durationLabel : UILabel?
    @IBOutlet var distanceLabel : UILabel?
    
    
    // Variable pour ajouter la route dans la base de donnée
    
    var startLat : Float = 0.0
    var endLat : Float = 0.0
    var startLng : Float = 0.0
    var endLng : Float = 0.0
    
    @IBOutlet var button : UIButton?
    
    override func viewDidLoad() {
        //originLabel?.text = origin
        //destinationLabel?.text = destination
        timeLabel?.text = date+" "+time
        self.wReccurence.isHidden = !reccurence
        createRoute()
    
    }
    
    @IBAction func routeOnDataBase() {
        
        //let parameters = ["token" : token, "startLat": self.startLat, "endLat": self.endLat, "startLng": self.startLng, "endLng": self.endLng, "driverId": 2, "dates" : "[]" ] as [String : Any]
        
        let reccurenceString : String = (self.reccurence ? "1" : "0")
        
        let driverId = userDictionary["id"] as! Int

        let url = NSURL(string: ServerAdress+":3000/api/routes")!
        
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "PUT"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "x-access-token")
        
        let postString = "startLat="+String(self.startLat)+"&endLat="+String(self.endLat)+"&startLng="+String(self.startLng)+"&endLng="+String(self.endLng)+"&driverId="+String(driverId)+"&dates="+self.date+" "+self.time+";"+reccurenceString
        
        request.httpBody = postString.data(using: .utf8)
            
        /*do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }*/
            
        let alertController = UIAlertController(title: "Route added", message: "The route has been added", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        
        do {
            // Execute the request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                // Check for error
                if error != nil
                {
                    print("Error")
                    return
                }
            }
            task.resume()
        }
        
    }
    
    
    func createRoute() {
        // Requete à Google pour creer une route
        self.mapTasks.getDirections(origin: self.origin, destination: self.destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                DispatchQueue.main.async(execute: {
                    
                    self.startLat = Float(self.mapTasks.originCoordinate.latitude)
                    self.endLat = Float(self.mapTasks.destinationCoordinate.latitude)
                    self.startLng = Float(self.mapTasks.originCoordinate.longitude)
                    self.endLng = Float(self.mapTasks.destinationCoordinate.longitude)
                    
                    self.viewMap?.clear()
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                    self.displayRouteInfo()
                })
            }
            else {
                print(status)
            }
        })
        
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
        viewMap?.camera = GMSCameraPosition.camera(withTarget: mapTasks.originCoordinate, zoom: 12.0)
        
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.title = self.mapTasks.destinationAddress
        
        // Ajout des adresses dans la barre du haut
        DispatchQueue.main.async(execute: {
            self.originLabel?.text = self.mapTasks.originAddress
            self.destinationLabel?.text = self.mapTasks.destinationAddress

        })
    }
    
    func displayRouteInfo() {
        DispatchQueue.main.async() {
            self.durationLabel?.text = self.mapTasks.totalDuration
            self.distanceLabel?.text = self.mapTasks.totalDistance
        }
    }
    
    
}
