//
//  RouteList.swift
//  GALDev
//
//  Created by Loan Aubergeon on 29/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit

var myIndex : Int = 0

class RouteList : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// Date about the searched route
    var searchedRoute : Route = SearchRoute.SearchedRoute.searchedRoute
    
    /// User's token
    var token = Home.UserConnectedInformations.userToken
    
    /// Table for show the list of available route
    @IBOutlet var routeTableView : UITableView!
    
    /// Data array for show routes one by one
    var routes : [Route] = []
    
    /// Differents tasks
    var mapTasks = MapTasks()
    var userTasks = UserTasks()
    var routeTasks = RouteTasks()
    var dateTasks = DateTasks()
    var favoriteRouteTasks = FavoriteRouteTasks()
    
    override func viewDidLoad() {
        
        routeTableView.dataSource = self
        routeTableView.delegate = self

        
        let fullDate : String = self.searchedRoute.date+""+self.searchedRoute.time
        let startLat : Double = self.searchedRoute.latitudeOfStartigPoint
        let startLong : Double = self.searchedRoute.longitudeOfStartingPoint
        let endLat : Double = self.searchedRoute.longitudeOfEndPoint
        let endLong : Double = self.searchedRoute.longitudeOfEndPoint
        
        // Chargement de la liste des routes 
        self.routeTasks.route(date: fullDate, startLat : startLat, startLong : startLong, endLat : endLat, endLong : endLong,  completionHandler: { (status, success) -> Void in
            if success {
                self.routes = self.routeTasks.routes
                
                DispatchQueue.main.async {
                    self.routeTableView.reloadData()
                }
            }
        })
    }
    

    
    //Nombre de sections en tout
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.routes.count == 0 {
            let emptyStateLabel = UILabel(frame: tableView.frame)
            emptyStateLabel.text = "No routes available !"
            emptyStateLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = emptyStateLabel
            return 0
        } else {
            tableView.backgroundView = nil
            return self.routes.count
        }
    }
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     switch section {
     case 0: return "Routes : "
     default: return ""
     }
     }*/
    
    
    //Cellule à l'index concerné
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCustomCell
        
        for i in 0...self.routes.count {
            
            if (indexPath.row == i) {
                DispatchQueue.main.async {
                    cell.originLabel.text = self.routes[i].nameOfStartingPoint
                    cell.destinationLabel.text = self.routes[i].nameOfEndpoint
                    cell.favorite.isHidden = true
                    
                    let routeId : Int = self.routes[i].id
                    self.dateTasks.date(routeId: routeId, completionHandler: { (status, success) -> Void in
                        if success {
                            DispatchQueue.main.async {
                                cell.dateLabel.text = self.dateTasks.date
                                cell.reccurence.isHidden = !self.dateTasks.weeklyReccurence
                                
                                let id = self.routes[i].driver
                                self.userTasks.user(driverId: id, completionHandler: { (status, success) -> Void in
                                    if success {
                                        DispatchQueue.main.async {
                                            cell.driverLabel.text = self.userTasks.user.username
                                            
                                            let userId = Home.UserConnectedInformations.user.id
                                            self.favoriteRouteTasks.favoriteRoute(routeId: routeId, userId: userId!, completionHandler: { (status, success) -> Void in
                                                if status == "Existing" {
                                                    DispatchQueue.main.async {
                                                        cell.favorite.isHidden = false
                                                    }
                                                }
                                            })
                                            
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "routeViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routeViewSegue" {
            if let destination = segue.destination as? RouteView {
                destination.routes = self.routes
            }
        }
    }
    
}
