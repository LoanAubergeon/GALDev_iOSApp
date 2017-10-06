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
    var dateTasks = DateTasks()
    var calculationForMapDisplay = CalculationForMapDisplay()
    
    
    /// User's Token
    var token = Home.UserConnectedInformations.userToken
    
    var routes : [Route] = []
    
    /// Labels pour affichage des informations
    @IBOutlet var originLabel : UILabel?
    @IBOutlet var destinationLabel : UILabel?
    @IBOutlet var usernameDriverLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var weeklyReccurence : UIImageView!
    @IBOutlet var durationLabel : UILabel?
    @IBOutlet var distanceLabel : UILabel?
    
    var searchedRoute : Route = Route.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchedRoute = SearchRoute.TransfertDonnee.routeTransfer
        self.routeDisplay()
        
        
    }
    
    func routeDisplay(){
        
        let dateParameter : String = self.searchedRoute.date+""+self.searchedRoute.time
        
        self.routeTasks.route(date: dateParameter, completionHandler: { (status, success) -> Void in
            if success {
                self.routes = self.routeTasks.routes
                let driverIndex = self.routes[myIndex].driver
                
                DispatchQueue.main.async() {
                    self.originLabel?.text = self.routes[myIndex].originName
                    self.destinationLabel?.text = self.routes[myIndex].destinationName
                }
                
                self.userTasks.user(driverId: driverIndex, completionHandler: { (status, success) -> Void in
                    if success {
                        DispatchQueue.main.async() {
                            self.usernameDriverLabel?.text = self.userTasks.user.username
                        }
                        
                        let origin = self.routes[myIndex].originName
                        let destination = self.routes[myIndex].destinationName
                        DispatchQueue.main.async() {
                            self.createRoute(origin: origin, destination: destination)
                        }
                        let routeId = self.routes[myIndex].id
                        
                        self.dateTasks.date(routeId: routeId, completionHandler: { (status, success) -> Void in
                            if success {
                                DispatchQueue.main.async() {
                                    self.dateLabel?.text = self.dateTasks.date
                                    self.dateLabel?.sizeToFit()
                                    self.weeklyReccurence.isHidden = !self.dateTasks.weeklyReccurence
                                }
                                
                                
                            }
                            
                        })
                        
                    }
                })
                
            }
        })
        
    }
    
    
    
    func createRoute(origin : String!, destination : String!) {
        // Requete à Google pour creer une route
        self.mapTasks.getDirections(origin: origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                DispatchQueue.main.async() {
                    self.viewMap?.clear()
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                    self.displayRouteInfo()
                }
            }
            else {
                print(status)
            }
        })
        
    }
    
    func sizeToFit(){
        self.originLabel?.sizeToFit()
        self.destinationLabel?.sizeToFit()
        self.usernameDriverLabel?.sizeToFit()
        self.dateLabel?.sizeToFit()
        self.durationLabel?.sizeToFit()
        self.distanceLabel?.sizeToFit()
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
        
        // A refaire !!!
        let oLat = mapTasks.originCoordinate.latitude
        let oLong = mapTasks.originCoordinate.longitude
        let dLat = mapTasks.destinationCoordinate.latitude
        let dLong = mapTasks.destinationCoordinate.longitude
        
        self.calculationForMapDisplay.centerCalcul(xLat: oLat, yLat: dLat, xLong: oLong, yLong: dLong)
        
        let centerCoordinate = CLLocationCoordinate2DMake(self.calculationForMapDisplay.xCenter as Double, self.calculationForMapDisplay.xCenter as Double)
        
        viewMap?.camera = GMSCameraPosition.camera(withTarget: self.mapTasks.originCoordinate, zoom: 10.0)
        
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
        
        self.durationLabel?.text = self.mapTasks.totalDuration
        self.distanceLabel?.text = self.mapTasks.totalDistance
    }
    
    
    
    
}
