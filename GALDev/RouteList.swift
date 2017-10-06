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
    var searchedRoute : Route = SearchRoute.TransfertDonnee.routeTransfer
    
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
    
    override func viewDidLoad() {
        routeTableView.dataSource = self
        routeTableView.delegate = self
        
        let fullDate : String = self.searchedRoute.date+""+self.searchedRoute.time
        
        self.routeTasks.route(date: fullDate, completionHandler: { (status, success) -> Void in
            if success {
                DispatchQueue.main.async {
                    self.routes = self.routeTasks.routes
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
        switch section {
        case 0: return self.routes.count
        default: return 0
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
                    cell.originLabel.text = self.routes[i].originName
                    cell.destinationLabel.text = self.routes[i].destinationName
                }
                
                let id = routes[i].driver
                self.userTasks.user(driverId: id, completionHandler: { (status, success) -> Void in
                    if success {
                        DispatchQueue.main.async {
                            cell.driverLabel.text = self.userTasks.user.username
                        }
                    }
                })
                
                let routeId : Int = routes[i].id
                self.dateTasks.date(routeId: routeId, completionHandler: { (status, success) -> Void in
                    if success {
                        DispatchQueue.main.async {
                            cell.dateLabel.text = self.dateTasks.date
                            cell.reccurence.isHidden = !self.dateTasks.weeklyReccurence
                        }
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

}
