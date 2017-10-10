//
//  SearchRoute.swift
//  GALDev
//
//  Created by Loan Aubergeon on 24/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit
import GoogleMaps



class SearchRoute: UIViewController, CLLocationManagerDelegate {
    
    var affichageJour = false
    
    let locationManager = CLLocationManager()
    
    var locationMarker: GMSMarker!
    
    var myLocationLat : Float = 0
    var myLocationLng : Float = 0
    
    @IBOutlet var viewMap : GMSMapView?
    
    @IBOutlet var hourTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    
    @IBOutlet var originTextField : SearchTextField!
    @IBOutlet var destinationTextField : SearchTextField!
    
    var mapTasks = MapTasks()
    
    struct SearchedRoute {
        static var searchedRoute : Route = Route.init()
    }
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
    }
    
    
    
    override func viewDidLoad() {
        // On reinitialise le transfert de donnée si jamais on veut refaire une nouvelle recherche 
        SearchedRoute.searchedRoute = Route.init()
        
       // Suggestions
        originTextField.theme = SearchTextFieldTheme.darkTheme()
        destinationTextField.theme = SearchTextFieldTheme.darkTheme()
        originTextField.filterStrings(["Attard","Balzan","Birgu","Birkirkara","Birzebbuga","Bormla","Dingli","Fgura","Fontana","Ghajnsielem","Gharb","Gharghur","Ghasri","Ghaxaq","Gudja","Gzira","Hamrun","Iklin","Imdina","Imgarr","Imqabba","Imsida","Imtarfa","Isla","Kalkara","Kercem","Kirkop","Lija","Luqa","Marsa","Marsaskala","Mellieha","Mosta","Munxar","Nadur","Naxxar","Paola","Pembroke","Pieta","Qala","Qormi","Qrendi","Rabat","Rabat","Safi","San Gwann","San Giljan","San Lawrenz","Saint Lucia","Saint Pauls Bay","Saint Venera","Sannat","Siggiewi","Sliema","Swieqi","Tarxien","Ta Xbiex","Valletta","Xaghra","Xewkija","Xghajra","Zabbar","Zebbug","Zebbug","Zejtun","Zurrieq"])
        
        destinationTextField.filterStrings(["Attard","Balzan","Birgu","Birkirkara","Birzebbuga","Bormla","Dingli","Fgura","Fontana","Ghajnsielem","Gharb","Gharghur","Ghasri","Ghaxaq","Gudja","Gzira","Hamrun","Iklin","Imdina","Imgarr","Imqabba","Imsida","Imtarfa","Isla","Kalkara","Kercem","Kirkop","Lija","Luqa","Marsa","Marsaskala","Mellieha","Mosta","Munxar","Nadur","Naxxar","Paola","Pembroke","Pieta","Qala","Qormi","Qrendi","Rabat","Rabat","Safi","San Gwann","San Giljan","San Lawrenz","Saint Lucia","Saint Pauls Bay","Saint Venera","Sannat","Siggiewi","Sliema","Swieqi","Tarxien","Ta Xbiex","Valletta","Xaghra","Xewkija","Xghajra","Zabbar","Zebbug","Zebbug","Zejtun","Zurrieq"])
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    
    @IBAction func myLocationOrigin(sender: UIButton){
        originTextField.text = String(myLocationLat)+" , "+String(myLocationLng)
    }
    
    @IBAction func myLocationDestination(sender: UIButton){
        destinationTextField.text = String(myLocationLat)+" , "+String(myLocationLng)
    }
    
    @IBAction func go(sender: UIButton){
        
        let origin = originTextField.text!
        let destination = destinationTextField.text!
        let time = hourTextField.text!
        let date = dateTextField.text!
        let recurrence : Bool = affichageJour ? true : false
        
        self.mapTasks.getDirections(origin: origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                print("success")
                let originAdress = self.mapTasks.originAddress!
                let destinationAdress = self.mapTasks.destinationAddress!
                let latitudeOfOrigin = self.mapTasks.originCoordinate.latitude
                let longitudeOfOrigin = self.mapTasks.originCoordinate.longitude
                let latitudeOfDestination = self.mapTasks.destinationCoordinate.latitude
                let longititudeOfDestination = self.mapTasks.destinationCoordinate.longitude
                self.mapTasks.calculateTotalDistanceAndDuration()
                let distance = self.mapTasks.totalDistance!
                let duration = self.mapTasks.totalDuration!
                let overviewPolyline = self.mapTasks.overviewPolyline
                
                SearchedRoute.searchedRoute = Route.init(
                    nameOfStartingPoint: originAdress,
                    latitudeOfStartigPoint: latitudeOfOrigin,
                    longitudeOfStartingPoint: longitudeOfOrigin,
                    nameOfEndpoint: destinationAdress,
                    latitudeOfEndPoint: latitudeOfDestination,
                    longitudeOfEndPoint: longititudeOfDestination,
                    overviewPolyline: overviewPolyline,
                    date: date,
                    time: time,
                    driver: Home.UserConnectedInformations.user.id,
                    recurrence: recurrence,
                    distance: distance,
                    duration: duration
                )
                DispatchQueue.main.async() {
                    self.performSegue(withIdentifier: "RouteListSegue", sender: nil)
                }
            } else {
                // Afficher une erreur
            }
        })
        
    }
    
    
    @IBAction func textFieldEditingDate(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    
    @IBAction func textFieldEditingTime(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.timePickerChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func autoOnOff (sender : UISwitch) {
        affichageJour = sender.isOn    //On attribue à modeAuto la valeur du UISwitch
    }
    
    
    @nonobjc func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap?.isMyLocationEnabled = true
        }
    }
    
    // For indicate the current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        self.myLocationLat = Float(userLocation!.coordinate.latitude)
        self.myLocationLng = Float(userLocation!.coordinate.longitude)
        
        viewMap?.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
    }
    
    
    @objc func timePickerChanged(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        hourTextField.text = timeFormatter.string(for: sender.date)
    }
    
    @objc func datePickerChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateTextField.text = dateFormatter.string(for: sender.date)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
