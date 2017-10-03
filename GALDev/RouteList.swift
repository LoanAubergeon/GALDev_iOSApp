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
    var origin : String! = SearchRoute.TransfertDonnee.originT
    var destination : String! = SearchRoute.TransfertDonnee.destinationT
    var time : String! = SearchRoute.TransfertDonnee.timeT
    var date : String! = SearchRoute.TransfertDonnee.dateT

    /// User's token
    var token = Home.GlobalsVariables.userToken
    
    /// Table for show the list of available route
    @IBOutlet var routeTableView : UITableView!
    
    /// Data array for show routes one by one
    var nameOfRoutesStart: [String] = []
    var nameOfRoutesEnd: [String] = []
    var driver: [Int] = []
    var routeId: [Int] = []
    
    /// Differents tasks
    var mapTasks = MapTasks()
    var userTasks = UserTasks()
    var routeTasks = RouteTasks()
    var dateTasks = DateTasks()
    
    override func viewDidLoad() {
        routeTableView.dataSource = self
        routeTableView.delegate = self
        
        let fullDate : String = date+""+time
        
        self.routeTasks.route(date: fullDate, completionHandler: { (status, success) -> Void in
            if success {
                self.nameOfRoutesStart = self.routeTasks.nameOfRoutesStart
                self.nameOfRoutesEnd = self.routeTasks.nameOfRoutesEnd
                self.driver = self.routeTasks.driver
                self.routeId = self.routeTasks.routeId
                
                self.routeTableView.reloadData()
            }
           
        })
    }
    
    //Nombre de sections en tout
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.routeId.count
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
        
        for i in 0...self.routeId.count {
            
            if (indexPath.row == i) {
                cell.originLabel.text = self.nameOfRoutesStart[i]
                cell.destinationLabel.text = self.nameOfRoutesEnd[i]
                
                let id = driver[i]
                self.userTasks.user(driverId: id, completionHandler: { (status, success) -> Void in
                    if success {
                        cell.driverLabel.text = self.userTasks.username
                    }
                })
                
                let rId : Int = self.routeId[i]
                self.dateTasks.date(routeId: rId, completionHandler: { (status, success) -> Void in
                    if success {
                        cell.dateLabel.text = self.dateTasks.date
                        cell.reccurence.isHidden = !self.dateTasks.weeklyReccurence
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
