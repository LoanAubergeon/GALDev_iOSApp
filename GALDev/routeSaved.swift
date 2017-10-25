//
//  routeSaved.swift
//  GALDev
//
//  Created by Loan Aubergeon on 03/10/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation

class routeSaved : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
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
        
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        routeTableView.dataSource = self
        routeTableView.delegate = self
        
        let driverId = Home.UserConnectedInformations.user.id
        
        self.routeTasks.route(driverId : driverId!, completionHandler: { (status, success) -> Void in
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
        
        /*let numOfSections = self.routes.count
         if numOfSections == 0
         {
         routeTableView.separatorStyle = .singleLine
         routeTableView.backgroundView = nil
         }
         else
         {
         routeTableView.separatorStyle  = .none
         routeTableView.backgroundView = noItemsView
         }
         return numOfSections*/
        
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
                    cell.originLabel.text = self.routes[i].nameOfStartingPoint
                    cell.destinationLabel.text = self.routes[i].nameOfEndpoint
                    
                    let routeId : Int = self.routes[i].id
                    self.dateTasks.date(routeId: routeId, completionHandler: { (status, success) -> Void in
                        if success {
                            DispatchQueue.main.async {
                                cell.dateLabel.text = self.dateTasks.date
                                cell.reccurence.isHidden = !self.dateTasks.weeklyReccurence
                            }
                        }
                    })
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // handle delete (by removing the data from your array and updating the tableview)
            
            // On demande la confirmation avant de supprimer
            let alert = UIAlertController(title: "Delete this route !", message: "Are you sure you want delete this route ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
                
                let routeId = self.routes[indexPath.row].id
                self.routeTasks.deleteRoute(routeId: routeId!, completionHandler: { (status, success) -> Void in})
                self.routes.remove(at: indexPath.row)
                self.routeTableView.reloadData()
            })
            alert.addAction(delete)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segueFromFavoriteToDriverView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromFavoriteToDriverView" {
            if let destination = segue.destination as? RouteView {
                destination.routes = self.routes
            }
        }
    }
}

