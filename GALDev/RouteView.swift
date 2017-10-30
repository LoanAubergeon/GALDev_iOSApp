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
    var userOriginMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var userDestinationMarker: GMSMarker!
    
    /// The route (draw)
    var routeOnePolyline: GMSPolyline!
    var routeTwoPolyline: GMSPolyline!
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
        self.searchedRoute = SearchRoute.SearchedRoute.searchedRoute
        self.routeDisplay()
    }
    
    @IBAction func displayDriverView(sender: AnyObject){
        performSegue(withIdentifier: "driverViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driverViewSegue" {
            if let destination = segue.destination as? DriverView {
                destination.routes = self.routes
            }
        }
    }
    
    func routeDisplay(){
        
        let driverIndex = self.routes[myIndex].driver
        let driverOrigin = self.routes[myIndex].nameOfStartingPoint
        let driverDestination = self.routes[myIndex].nameOfEndpoint
        //let searchedOrigin = SearchRoute.SearchedRoute.searchedRoute.nameOfStartingPoint
        //let searchedDestination = SearchRoute.SearchedRoute.searchedRoute.nameOfEndpoint
        let routeId = self.routes[myIndex].id
        
        DispatchQueue.main.async() {
            self.originLabel?.text = self.routes[myIndex].nameOfStartingPoint
            self.destinationLabel?.text = self.routes[myIndex].nameOfEndpoint
        }
        
        self.userTasks.user(driverId: driverIndex, completionHandler: { (status, success) -> Void in
            if success {
                DispatchQueue.main.async() {
                    self.usernameDriverLabel?.text = self.userTasks.user.username
                }
                // Chemin parcouru par le conducteur
                self.mapTasks.getDirections(origin: driverOrigin, destination: driverDestination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                    if success {
                        DispatchQueue.main.async() {
                            self.viewMap?.clear()
                            self.configureMapAndMarkersForRoute()
                            self.drawRoute()
                            self.displayRouteInfo()
                        }
                        
                        
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
    
    
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.strokeWidth = 5
        routePolyline.strokeColor = UIColor.blue
        routePolyline.map = viewMap
    }
    
    func configureMapAndMarkersForRoute() {
        
        // On recupere les coordonner des deux points
        let oLat = mapTasks.originCoordinate.latitude
        let oLong = mapTasks.originCoordinate.longitude
        let dLat = mapTasks.destinationCoordinate.latitude
        let dLong = mapTasks.destinationCoordinate.longitude
        
        self.calculationForMapDisplay.centerCalcul(xA: oLat, yA: oLong, xB: dLat, yB: dLong)
        // On centre la camera par rapport au deux points
        // On applique le zoom en fonction de la distance
        let zoom : Float = self.calculationForMapDisplay.zoomCalcul(distance: Double(self.mapTasks.totalDistanceInMeters/1000))
        
        viewMap?.camera = GMSCameraPosition.camera(withLatitude: self.calculationForMapDisplay.xCenter, longitude: self.calculationForMapDisplay.yCenter, zoom: zoom)
        
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
