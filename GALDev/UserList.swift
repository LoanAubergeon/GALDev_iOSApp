//
//  UserList.swift
//  GALDev
//
//  Created by Loan Aubergeon on 25/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit

class UserList : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet var userTableView : UITableView!
    
    var token = Home.GlobalsVariables.userToken
    
    
    var id: [Int] = []
    var username: [String] = []
    var name: [String] = []
    var surname: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userList()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        userTableView.dataSource = self
        userTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Nombre de sections en tout
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.id.count
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Users : "
        default: return ""
        }
    }
    
    //Cellule à l'index concerné
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "basic")
        for i in 0...self.id.count-1 {
            if (indexPath.row == i) {
                cell.textLabel?.text = self.username[i]+" : "+self.name[i]+" "+self.surname[i]
            }
        }
        return cell
    }
    
    
    // Requete pour avoir la liste des utilisateur
    func userList(){
        
        //let tokenString = "token="+token
        
        let url = NSURL(string: ServerAdress+":3000/api/users/")!
        
        var request = URLRequest(url: url as URL)
        
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        
        request.httpMethod = "GET"
        
        //request.httpBody = tokenString.data(using: String.Encoding.utf8)
        
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
                        self.id.append(jsonObjects["id"] as! Int)
                        self.username.append(jsonObjects["username"] as! String)
                        self.name.append(jsonObjects["name"] as! String)
                        self.surname.append(jsonObjects["surname"] as! String)
                        //self.userTableView.reloadData()
                    }
                    self.userTableView.reloadData()
                })
                
            } catch { // On catch les erreurs potentielles
                print(error)
            }
            
        }
        task.resume()
        
    }




}
