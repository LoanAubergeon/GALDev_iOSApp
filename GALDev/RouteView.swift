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
    
    var origin : String = nameOfRoutesStart[myIndex]
    var destination : String = nameOfRoutesEnd[myIndex]
    var driverIndex = driver[myIndex]
    
    @IBOutlet var originLabel : UILabel?
    @IBOutlet var destinationLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originLabel?.text = nameOfRoutesStart[myIndex]
        destinationLabel?.text = nameOfRoutesEnd[myIndex]
        self.createRoute()
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
