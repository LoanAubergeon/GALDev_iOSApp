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
    
    /*
    @IBOutlet var buttonMonday : UIButton!
    @IBOutlet var buttonTuesday : UIButton!
    @IBOutlet var buttonWednesday : UIButton!
    @IBOutlet var buttonThursday : UIButton!
    @IBOutlet var buttonFriday : UIButton!
    @IBOutlet var buttonSaturday : UIButton!
    @IBOutlet var buttonSunday : UIButton!
    */
    
    @IBOutlet var originTextField : UITextField!
    @IBOutlet var destinationTextField : UITextField!
    
    
    struct TransfertDonnee {
        static var originT : String = ""
        static var destinationT : String = ""
        static var dateT : String = ""
        static var timeT : String = ""
        static var reccurenceT : Bool = false
    }
    
    
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        
        /*buttonMonday.isSelected = false
        buttonTuesday.isSelected = false
        buttonWednesday.isSelected = false
        buttonThursday.isSelected = false
        buttonFriday.isSelected = false
        buttonSaturday.isSelected = false
        buttonSunday.isSelected = false*/
    }
    
    
    
    override func viewDidLoad() {
        // On reinitialise le transfert de donnée si jamais on veut refaire une nouvelle recherche 
        TransfertDonnee.originT = ""
        TransfertDonnee.destinationT = ""
        TransfertDonnee.timeT = ""
        TransfertDonnee.dateT = ""
        TransfertDonnee.reccurenceT = false
        
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
        
        TransfertDonnee.originT = originTextField.text!
        TransfertDonnee.destinationT = destinationTextField.text!
        TransfertDonnee.timeT = hourTextField.text!
        TransfertDonnee.dateT = dateTextField.text!
        
        if affichageJour {
            TransfertDonnee.reccurenceT = true
        } else {
            TransfertDonnee.reccurenceT = false
        }
        
        
        
        // Pour enregistrer la reccurence
        /*
        if affichageJour {
            if buttonMonday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Monday")
            }
            if buttonTuesday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Tuesday")
            }
            if buttonWednesday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Wednesay")
            }
            if buttonThursday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Thurday")
            }
            if buttonFriday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Friday")
            }
            if buttonSaturday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Saturday")
            }
            if buttonSunday.isSelected == true{
                TransfertDonnee.reccurenceT.append("Sunday")
            }
        }*/
        
        
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
        /*buttonMonday.isHidden = !affichageJour  //Cache la vue
        buttonTuesday.isHidden = !affichageJour  //Cache la vue
        buttonWednesday.isHidden = !affichageJour  //Cache la vue
        buttonThursday.isHidden = !affichageJour  //Cache la vue
        buttonFriday.isHidden = !affichageJour  //Cache la vue
        buttonSaturday.isHidden = !affichageJour  //Cache la vue
        buttonSunday.isHidden = !affichageJour */ //Cache la vue
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
