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
    
    // Route recherché 
    var origin : String! = SearchRoute.TransfertDonnee.originT
    var destination : String! = SearchRoute.TransfertDonnee.destinationT
    var token = Home.GlobalsVariables.userToken
    
    @IBOutlet var routeTableView : UITableView!
    
    var nameOfRoutesStart: [String] = []
    var nameOfRoutesEnd: [String] = []
    var driver: [Int] = []
    var routeId: [Int] = []
    
    var mapTasks = MapTasks()
    var userTasks = UserTasks()
    var routeTasks = RouteTasks()
    var dateTasks = DateTasks()
    
    override func viewDidLoad() {
    
        self.routeTasks.route(completionHandler: { (status, success) -> Void in
            if success {
                self.nameOfRoutesStart = self.routeTasks.nameOfRoutesStart
                self.nameOfRoutesEnd = self.routeTasks.nameOfRoutesEnd
                self.driver = self.routeTasks.driver
                self.routeId = self.routeTasks.routeId
                self.routeTableView.reloadData()
            }
        })
        
        routeTableView.dataSource = self
        routeTableView.delegate = self
    }
    
    //Nombre de sections en tout
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return driver.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCustomCell
        for i in 0...nameOfRoutesStart.count {
            if (indexPath.row == i) {
                
                cell.originLabel.text = nameOfRoutesStart[i]
                cell.destinationLabel.text = nameOfRoutesEnd[i]
                
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
